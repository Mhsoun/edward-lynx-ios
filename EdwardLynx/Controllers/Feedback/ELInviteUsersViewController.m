//
//  ELInviteUsersViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELInviteUsersViewController.h"

#pragma mark - Private Constants

static CGFloat const kELEmailButtonHeight = 40;
static CGFloat const kELFormViewHeight = 120;
static NSString * const kELCellIdentifier = @"ParticipantCell";

static NSString * const kELSelectAllButtonLabel = @"Select all";
static NSString * const kELDeselectAllButtonLabel = @"Deselect all";

static NSString * const kELNoOfPeopleLabel = @"No. of people selected: %@";
static NSString * const kELEvaluationLabel = @"The person evaluated is: %@";

static NSString * const kELSuccessMessageShareReport = @"Reports successfully shared.";
static NSString * const kELSuccessMessageInstantFeedback = @"Instant Feedback successfully created.";

#pragma mark - Class Extension

@interface ELInviteUsersViewController ()

@property (nonatomic) BOOL selected, allCellsAction;
@property (nonatomic, strong) UIAlertAction *inviteAction;
@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) NSMutableArray *mInitialParticipants, *mParticipants;
@property (nonatomic, strong) ELTableDataSource *dataSource;
@property (nonatomic, strong) ELDataProvider<ELParticipant *> *provider;
@property (nonatomic, strong) ELFeedbackViewManager *viewManager;

@end

@implementation ELInviteUsersViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.selected = NO;
    self.allCellsAction = NO;
    self.searchBar.delegate = self;
    self.mParticipants = [[NSMutableArray alloc] init];
    self.mInitialParticipants = [[ELAppSingleton sharedInstance].participants mutableCopy];
    self.selectAllButton.titleLabel.text = kELSelectAllButtonLabel;
    
    self.viewManager = [[ELFeedbackViewManager alloc] init];
    self.viewManager.delegate = self;
    
    self.provider = [[ELDataProvider alloc] initWithDataArray:[self.mInitialParticipants copy]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.dataSource dataSetEmptyText:@"No users" description:@""];
    [self.tableView registerNib:[UINib nibWithNibName:kELCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELCellIdentifier];
    
    // Additional details
    switch (self.inviteType) {
        case kELInviteUsersInstantFeedback:
            [self layoutInstantFeedbackSharePage];
            
            break;
        case kELInviteUsersReports:
            [self layoutReportSharePage];
            
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Dynamically adjust scroll view based on table view content
    [self adjustScrollViewContentSize];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // Clear selections
    [self clearSelection];
}

#pragma mark - Protocol Methods (UISearchBar)

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSMutableArray *mFilteredParticipants = [self.mInitialParticipants mutableCopy];
    NSString *condition = @"SELF.name CONTAINS [cd]%@ || SELF.email CONTAINS [cd]%@";
    
    if (searchText.length > 0) {
        [mFilteredParticipants filterUsingPredicate:[NSPredicate predicateWithFormat:condition,
                                                     searchText,
                                                     searchText]];
    }
    
    self.provider = [[ELDataProvider alloc] initWithDataArray:[mFilteredParticipants copy]];
    
    [self.tableView reloadData];
    [self adjustScrollViewContentSize];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [[searchBar delegate] searchBar:searchBar textDidChange:@""];
    
    [searchBar setText:@""];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar endEditing:YES];
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.provider numberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELParticipantTableViewCell *cell = (ELParticipantTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kELCellIdentifier];
    
    [cell configure:[self.provider rowObjectAtIndexPath:indexPath] atIndexPath:indexPath];
    [cell setAccessoryType:cell.participant.isSelected ? UITableViewCellAccessoryCheckmark :
                                                         UITableViewCellAccessoryNone];
    
    // Button state
    [self updateSelectAllButtonForIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ELParticipantTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // FIX Cell being need to be clicked twice to invoke method
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.allCellsAction) {
        cell.participant.isSelected = self.selected;
    } else {
        [cell handleObject:[self.provider rowObjectAtIndexPath:indexPath] selectionActionAtIndexPath:indexPath];
    }
    
    // Toggle selected state
    if (cell.participant.isSelected) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        if (![self.mParticipants containsObject:cell.participant]) {
            [self.mParticipants addObject:cell.participant];
        }
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [self.mParticipants removeObject:cell.participant];
    }
    
    // Button state
    [self updateSelectAllButtonForIndexPath:indexPath];

    // Updated selected users label
    self.noOfPeopleLabel.text = [NSString stringWithFormat:kELNoOfPeopleLabel, @(self.mParticipants.count)];
}

#pragma mark - Protocol Methods (UITextField)

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSArray *emailErrors, *nameErrors;
    NSArray<UITextField *> *textFields = self.alertController.textFields;
    NSString *finalEmailString = textFields.lastObject.text;
    NSString *finalNameString = textFields.firstObject.text;
    
    [REValidation registerDefaultValidators];
    [REValidation registerDefaultErrorMessages];
    
    // TODO Polish validation
    
    emailErrors = [REValidation validateObject:finalEmailString
                                          name:@"Email"
                                    validators:@[@"presence", @"email"]];
    nameErrors = [REValidation validateObject:finalNameString
                                         name:@"Email"
                                   validators:@[@"presence"]];
    
    [self.inviteAction setEnabled:(nameErrors.count == 0 && emailErrors.count == 0)];
    
    return YES;
}

#pragma mark - Protocol Methods (ELFeedbackViewManager)

- (void)onAPIPostResponseError:(NSDictionary *)errorDict {
    DLog(@"%@", errorDict);
}

- (void)onAPIPostResponseSuccess:(NSDictionary *)responseDict {
    NSString *successMessage = self.inviteType == kELInviteUsersInstantFeedback ? kELSuccessMessageInstantFeedback :
                                                                                  kELSuccessMessageShareReport;
    
    self.inviteButton.enabled = YES;
    
    // Clear selections
    [self clearSelection];
    
    // Back to the Dashboard
    [ELUtils presentToastAtView:self.view
                        message:successMessage
                     completion:^{
        [self presentViewController:[[UIStoryboard storyboardWithName:@"LeftMenu" bundle:nil]
                                     instantiateInitialViewController]
                           animated:YES
                         completion:nil];
    }];
}

#pragma mark - Private Methods

- (void)adjustScrollViewContentSize {
    CGRect tableFrame = self.tableView.frame;
    CGFloat tableViewContentSizeHeight = self.tableView.contentSize.height;
    
    if (tableViewContentSizeHeight == 0) {
        return;
    }
    
    tableFrame.size.height = tableViewContentSizeHeight;
    
    [self.tableView setFrame:tableFrame];
    [self.tableView setContentSize:CGSizeMake(self.tableView.contentSize.width,
                                              tableViewContentSizeHeight)];
    
    // Set the content size of your scroll view to be the content size of your
    // table view + whatever else you have in the scroll view.
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width,
                                               (kELFormViewHeight + tableViewContentSizeHeight + 30))];
}

- (void)clearSelection {
    for (int i = 0; i < self.mParticipants.count; i++) {
        ELParticipant *participant = self.mParticipants[i];
        
        participant.isSelected = NO;
        
        [self.provider updateObject:participant
                        atIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.mParticipants removeAllObjects];
}

- (void)layoutInstantFeedbackSharePage {
    // Details
    self.headerLabel.text = @"Invite people to participate";
    self.detailLabel.text = [NSString stringWithFormat:kELEvaluationLabel, [ELAppSingleton sharedInstance].user.name];
    
    // Button
    [self.emailButtonHeightConstraint setConstant:kELEmailButtonHeight];
    [self.emailButton updateConstraints];
}

- (void)layoutReportSharePage {
    // Details
    self.headerLabel.text = @"Share report to users";
    self.detailLabel.text = @"Select users for them to be able to view this report";
    
    // Button
    [self.emailButtonHeightConstraint setConstant:0];
    [self.emailButton updateConstraints];
}

- (void)updateSelectAllButtonForIndexPath:(NSIndexPath *)indexPath {
    if (self.mParticipants.count == 0) {
        [self.selectAllButton setTitle:kELSelectAllButtonLabel forState:UIControlStateNormal];
    } else if (self.mParticipants.count == [self.provider numberOfRows]) {
        [self.selectAllButton setTitle:self.mInitialParticipants.count ? kELDeselectAllButtonLabel : self.selectAllButton.titleLabel.text
                              forState:UIControlStateNormal];
    } else if (self.allCellsAction) {
        if (self.mParticipants.count >= [self.provider numberOfRows] && indexPath.row == [self.provider numberOfRows] - 1) {
            [self.selectAllButton setTitle:self.selected ? kELDeselectAllButtonLabel : kELSelectAllButtonLabel
                                  forState:UIControlStateNormal];
        }
    }
}

#pragma mark - Interface Builder Actions

- (IBAction)onSelectAllButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *title = [button.titleLabel.text isEqualToString:kELSelectAllButtonLabel] ? kELDeselectAllButtonLabel :
                                                                                         kELSelectAllButtonLabel;
    
    self.allCellsAction = YES;
    self.selected = [button.titleLabel.text isEqualToString:kELSelectAllButtonLabel];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    for (int i = 0; i < [self.provider numberOfRows]; i++) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionBottom];
        [[self.tableView delegate] tableView:self.tableView
                     didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    self.allCellsAction = NO;
}

- (IBAction)onInviteButtonClick:(id)sender {
    NSMutableArray *mUsers = [[NSMutableArray alloc] init];
    
    if (self.inviteType == kELInviteUsersInstantFeedback) {
        kELAnswerType answerType;
        NSArray *questions;
        NSMutableDictionary *mAnswerDict;
        
        if (!self.mParticipants.count) {
            [ELUtils presentToastAtView:self.view
                                message:@"No participants selected"
                             completion:^{}];
            
            return;
        }
        
        self.inviteButton.enabled = NO;
        
        answerType = [ELUtils answerTypeByLabel:[self.instantFeedbackDict[@"type"] textValue]];
        mAnswerDict = [NSMutableDictionary dictionaryWithDictionary:@{@"type": @(answerType)}];
        
        if (self.instantFeedbackDict[@"options"]) {
            [mAnswerDict setObject:self.instantFeedbackDict[@"options"] forKey:@"options"];
        }
        
        questions = @[@{@"text": [self.instantFeedbackDict[@"question"] textValue],
                        @"isNA": @([self.instantFeedbackDict[@"isNA"] boolValue]),
                        @"answer": [mAnswerDict copy]}];
        
        for (ELParticipant *participant in self.mParticipants) {
            [mUsers addObject:participant.isAddedByEmail ? [participant addedByEmailDictionary] :
                                                           [participant apiPostDictionary]];
        }
        
        [self.viewManager processInstantFeedback:@{@"lang": @"en",
                                                   @"anonymous": self.instantFeedbackDict[@"anonymous"],
                                                   @"questions": questions,
                                                   @"recipients": [mUsers copy]}];
    } else if (self.inviteType == kELInviteUsersReports) {
        if (!self.mParticipants.count) {
            [ELUtils presentToastAtView:self.view
                                message:@"No participants selected"
                             completion:^{}];
            
            return;
        }
        
        self.inviteButton.enabled = NO;
        
        for (ELParticipant *participant in self.mParticipants) [mUsers addObject:@(participant.objectId)];
        
        [self.viewManager processSharingOfReportToUsers:@{@"users": [mUsers copy]}
                                                   atId:self.instantFeedback.objectId];
    }
}

- (IBAction)onInviteByEmailButtonClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    self.alertController = [UIAlertController alertControllerWithTitle:@"Invite a user"
                                                               message:@"Enter user's name and e-mail address:"
                                                        preferredStyle:UIAlertControllerStyleAlert];
    
    self.inviteAction = [UIAlertAction actionWithTitle:@"Add User"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * _Nonnull action) {
        NSArray<UITextField *> *textFields = self.alertController.textFields;
        ELParticipant *participant = [[ELParticipant alloc] initWithDictionary:@{@"id": @(-1),
                                                                                 @"name": textFields.firstObject.text,
                                                                                 @"email": textFields.lastObject.text}
                                                                         error:nil];
        
        participant.isSelected = YES;
        participant.isAddedByEmail = YES;
        
        [self.mParticipants addObject:participant];
        [self.mInitialParticipants addObject:participant];
        
        self.provider = [[ELDataProvider alloc] initWithDataArray:[self.mInitialParticipants copy]];
        
        [self.tableView reloadData];
        [self adjustScrollViewContentSize];
        [ELUtils scrollViewToBottom:self.scrollView];
        
        // Updated selected users label
        self.noOfPeopleLabel.text = [NSString stringWithFormat:kELNoOfPeopleLabel, @(self.mParticipants.count)];
    }];
    self.inviteAction.enabled = NO;
    
    [self.alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.delegate = weakSelf;
        textField.placeholder = @"Name";
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    [self.alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.delegate = weakSelf;
        textField.placeholder = @"E-mail";
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }];
    [self.alertController addAction:self.inviteAction];
    [self.alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
    
    [self presentViewController:self.alertController
                       animated:YES
                     completion:nil];
}

@end
