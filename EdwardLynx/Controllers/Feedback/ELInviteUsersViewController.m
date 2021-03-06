//
//  ELInviteUsersViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <REValidation/REValidation.h>

#import "ELInviteUsersViewController.h"
#import "ELDataProvider.h"
#import "ELFeedbackViewManager.h"
#import "ELInstantFeedback.h"
#import "ELParticipant.h"
#import "ELParticipantTableViewCell.h"
#import "ELTableDataSource.h"

#pragma mark - Private Constants

static CGFloat const kELCellHeight = 70;
static CGFloat const kELEmailButtonHeight = 40;
static CGFloat const kELFormViewHeight = 110;
static CGFloat const kELIconSize = 17.5f;
static NSString * const kELCellIdentifier = @"ParticipantCell";

#pragma mark - Class Extension

@interface ELInviteUsersViewController ()

@property (nonatomic) BOOL selected, allCellsAction;
@property (nonatomic, strong) UIImage *checkIcon;
@property (nonatomic, strong) UIAlertAction *inviteAction;
@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) NSMutableArray *mInitialParticipants,
                                             *mParticipants;
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
    self.mInitialParticipants = [[AppSingleton participantsWithoutUser] mutableCopy];
    self.navigationItem.title = [self.navigationItem.title uppercaseString];
    
    // To display only the not yet invited participants
    if (self.instantFeedback && self.inviteType == kELInviteUsersInstantFeedback) {
        NSMutableSet *mergedSet = [NSMutableSet setWithArray:self.instantFeedback.participants];
        NSArray *descriptors = @[[[NSSortDescriptor alloc] initWithKey:@"isSelected" ascending:NO],
                                 [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
        
        [mergedSet unionSet:[NSSet setWithArray:[AppSingleton participantsWithoutUser]]];
        
        self.mInitialParticipants = [[[mergedSet allObjects] sortedArrayUsingDescriptors:descriptors] mutableCopy];
    }
    
    self.viewManager = [[ELFeedbackViewManager alloc] init];
    self.viewManager.delegate = self;
    
    self.provider = [[ELDataProvider alloc] initWithDataArray:[self.mInitialParticipants copy]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.dataSource dataSetEmptyText:NSLocalizedString(@"kELInviteUsersRetrievalEmpty", nil) description:@""];
    
    RegisterNib(self.tableView, kELCellIdentifier);
    
    // Additional details
    self.infoView.hidden = YES;
    
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
    
    // UI
    self.infoLabel.text = NSLocalizedString(@"kELInviteUsersInfoMessage", nil);
    self.infoLabel.textColor = ThemeColor(kELTextFieldBGColor);
    self.checkIcon = [FontAwesome imageWithIcon:fa_check_circle
                                      iconColor:ThemeColor(kELGreenColor)
                                       iconSize:kELIconSize
                                      imageSize:CGSizeMake(kELIconSize, kELIconSize)];
    self.infoImageView.image = [FontAwesome imageWithIcon:fa_info_circle
                                                iconColor:ThemeColor(kELTextFieldBGColor)
                                                 iconSize:kELIconSize
                                                imageSize:CGSizeMake(kELIconSize, kELIconSize)];
    
    [self updateTableViewHeight];
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

- (void)dealloc {
    DLog(@"%@", [self class]);
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
    ELParticipant *participant = (ELParticipant *)[self.provider rowObjectAtIndexPath:indexPath];
    ELParticipantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier
                                                                       forIndexPath:indexPath];
    
    [cell configure:participant atIndexPath:indexPath];
    [cell setUserInteractionEnabled:!participant.isAlreadyInvited];
    [cell setAccessoryView:cell.participant.isSelected ? [[UIImageView alloc] initWithImage:self.checkIcon] : nil];
    
    // Button state
//    [self updateSelectAllButtonForIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ELParticipantTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (!cell.isUserInteractionEnabled) {
        return;
    }
    
    if (self.allCellsAction) {
        cell.participant.isSelected = self.selected;
    } else {
        [cell handleObject:[self.provider rowObjectAtIndexPath:indexPath] selectionActionAtIndexPath:indexPath];
    }
    
    // Toggle selected state
    if (cell.participant.isSelected) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:self.checkIcon];
        
        if (![self.mParticipants containsObject:cell.participant]) {
            [self.mParticipants addObject:cell.participant];
        }
    } else {
        cell.accessoryView = nil;
        
        [self.mParticipants removeObject:cell.participant];
    }
    
    // Button state
    [self updateSelectAllButtonForIndexPath:indexPath];

    // Updated selected users label
    self.noOfPeopleLabel.text = Format(NSLocalizedString(@"kELUsersNumberSelectedLabel", nil),
                                       @(self.mParticipants.count));
}

#pragma mark - Protocol Methods (ELFeedbackViewManager)

- (void)onAPIPostResponseError:(NSDictionary *)errorDict {
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    [ELUtils presentToastAtView:self.view
//                        message:NSLocalizedString(@"kELPostMethodError", nil)
//                     completion:nil];
}

- (void)onAPIPostResponseSuccess:(NSDictionary *)responseDict {
    NSString *message;
    __weak typeof(self) weakSelf = self;
    
    switch (self.inviteType) {
        case kELInviteUsersInstantFeedback:
            message = NSLocalizedString(@"kELInviteUsersSuccess", nil);
            
            break;
        case kELInviteUsersReports:
            message = NSLocalizedString(@"kELInviteUsersShareSuccess", nil);
            
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self clearSelection];
    
    // Back to the Dashboard
    [ELUtils presentToastAtView:self.view
                        message:message
                     completion:^{
        if (weakSelf.inviteType != kELInviteUsersInstantFeedback) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            AppSingleton.needsPageReload = YES;
            
            [weakSelf presentViewController:StoryboardController(@"LeftMenu", nil)
                                   animated:YES
                                 completion:nil];
        }
    }];
}

#pragma mark - Private Methods

- (void)adjustScrollViewContentSize {
    CGFloat tableViewContentSizeHeight = kELCellHeight * self.mInitialParticipants.count;
    
    if (tableViewContentSizeHeight == 0) {
        return;
    }
    
    [self updateTableViewHeight];
    
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
    self.title = [NSLocalizedString(@"kELInviteTitleFeedback", nil) uppercaseString];
    
    // Button
    [self.inviteButton setTitle:NSLocalizedString(@"kELShareButtonFeedback", nil)
                       forState:UIControlStateNormal];
    
    [self.emailButtonHeightConstraint setConstant:kELEmailButtonHeight];
    [self.emailButton updateConstraints];
}

- (void)layoutPage {
    [self.selectAllButton setTitle:@"" forState:UIControlStateNormal];
    [self toggleSelectAllButton:fa_square_o];
    
//    [self toggleSelectAllButton:@"kELSelectAllButton"];
}

- (void)layoutReportSharePage {
    self.title = [NSLocalizedString(@"kELInviteTitleReport", nil) uppercaseString];
    
    // Button
    [self.inviteButton setTitle:NSLocalizedString(@"kELShareButtonReport", nil)
                       forState:UIControlStateNormal];
    
    [self.emailButtonHeightConstraint setConstant:0];
    [self.emailButton updateConstraints];
}

- (void)toggleSelectAllButton:(NSString *)key {
    CGFloat size = 20;

//    [self.selectAllButton setTitle:NSLocalizedString(key, nil)
//                          forState:UIControlStateNormal];
    
    [self.selectAllButton setTag:[key isEqualToString:fa_square_o] ? 0 : 1];
    [self.selectAllButton setTintColor:ThemeColor(kELOrangeColor)];
    [self.selectAllButton setImage:[FontAwesome imageWithIcon:key
                                                    iconColor:ThemeColor(kELOrangeColor)
                                                     iconSize:size
                                                    imageSize:CGSizeMake(size, size)]
                          forState:UIControlStateNormal];
}

- (void)updateSelectAllButtonForIndexPath:(NSIndexPath *)indexPath {
    NSString *key;
    NSInteger selectedCount = self.mParticipants.count, rowsCount = [self.provider numberOfRows];
    
    if (selectedCount == 0 || !selectedCount) {
//        key = @"kELSelectAllButton";
        key = fa_square_o;
    } else if ((selectedCount >= rowsCount) ||
               (self.instantFeedback && selectedCount >= rowsCount - self.instantFeedback.participants.count)) {
//        key = self.mInitialParticipants.count ? @"kELDeselectAllButton" : nil;
        key = self.mInitialParticipants.count ? fa_check_square : nil;
    }
    
    if (!key) {
        return;
    }
    
    [self toggleSelectAllButton:key];
}

- (void)updateTableViewHeight {
    CGFloat tableViewContentSizeHeight = kELCellHeight * self.mInitialParticipants.count;
    
    [self.tableHeightConstraint setConstant:tableViewContentSizeHeight];
    [self.tableView updateConstraints];
}

#pragma mark - Interface Builder Actions

- (IBAction)onSelectAllButtonClick:(id)sender {
    BOOL isSelected;
    NSString *key;
    UIButton *button = (UIButton *)sender;
    
//    isSelected = [button.titleLabel.text isEqualToString:NSLocalizedString(@"kELSelectAllButton", nil)];
//    title = isSelected ? NSLocalizedString(@"kELDeselectAllButton", nil) :
//                         NSLocalizedString(@"kELSelectAllButton", nil);
    
    isSelected = button.tag == 0;
    key = isSelected ? fa_check_square : fa_square_o;

//    self.selected = [button.titleLabel.text isEqualToString:NSLocalizedString(@"kELSelectAllButton", nil)];
    
    self.selected = button.tag == 0;
    self.allCellsAction = YES;
    
    [self toggleSelectAllButton:key];
    
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
    
    if (!self.mParticipants.count || self.mParticipants.count == 0) {
        [ELUtils presentToastAtView:self.view
                            message:NSLocalizedString(@"kELInviteUsersNoSelectionMessage", nil)
                         completion:nil];
        
        return;
    }
    
    // Loading alert
    [self presentViewController:[ELUtils loadingAlert]
                       animated:YES
                     completion:nil];
    
    if (self.inviteType == kELInviteUsersInstantFeedback) {
        kELAnswerType answerType;
        NSArray *questions;
        NSMutableDictionary *mAnswerDict;
        
        // Retrieve selected user(s)
        for (ELParticipant *participant in self.mParticipants) {
            [mUsers addObject:participant.isAddedByEmail ? [participant addedByEmailDictionary] :
                                                           [participant apiPostDictionary]];
        }
        
        // Add more participants
        if (self.instantFeedback) {
            [self.viewManager processInstantFeedbackAddParticipantsWithId:self.instantFeedback.objectId
                                                                 formData:@{@"recipients": [mUsers copy]}];
            
            return;
        }
        
        // Create new Instant Feedback
        answerType = [ELUtils answerTypeByLabel:self.instantFeedbackDict[@"type"]];
        mAnswerDict = [NSMutableDictionary dictionaryWithDictionary:@{@"type": @(answerType)}];
        
        if (self.instantFeedbackDict[@"options"]) {
            [mAnswerDict setObject:self.instantFeedbackDict[@"options"] forKey:@"options"];
        }
        
        questions = @[@{@"text": [self.instantFeedbackDict[@"question"] textValue],
                        @"isNA": @([self.instantFeedbackDict[@"isNA"] boolValue]),
                        @"answer": [mAnswerDict copy]}];
        
        [self.viewManager processInstantFeedback:@{@"lang": @"en",
                                                   @"anonymous": self.instantFeedbackDict[@"anonymous"],
                                                   @"questions": questions,
                                                   @"recipients": [mUsers copy]}];
    } else if (self.inviteType == kELInviteUsersReports) {
        for (ELParticipant *participant in self.mParticipants) [mUsers addObject:@(participant.objectId)];
        
        [self.viewManager processSharingOfReportToUsersWithId:self.instantFeedback.objectId
                                                     formData:@{@"users": [mUsers copy]}];
    }
}

- (IBAction)onInviteByEmailButtonClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    self.alertController = Alert(NSLocalizedString(@"kELInviteUsersAddEmailHeaderMessage", nil),
                                 NSLocalizedString(@"kELInviteUsersAddEmailDetailsMessage", nil));
    self.inviteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"kELAddButton", nil)
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * _Nonnull action) {
        NSArray<UITextField *> *textFields = self.alertController.textFields;
        ELParticipant *participant = [[ELParticipant alloc] initWithDictionary:@{@"id": @(-1),
                                                                                 @"name": textFields.firstObject.text,
                                                                                 @"email": textFields.lastObject.text}
                                                                         error:nil];
        
        participant.isSelected = YES;
        participant.isAddedByEmail = YES;
        
        [weakSelf.mParticipants addObject:participant];
        [weakSelf.mInitialParticipants addObject:participant];
        
        weakSelf.provider = [[ELDataProvider alloc] initWithDataArray:[weakSelf.mInitialParticipants copy]];
        
        [weakSelf.tableView reloadData];
        [weakSelf adjustScrollViewContentSize];
        
        [ELUtils scrollViewToBottom:weakSelf.scrollView];
        
        // Updated selected users label
        weakSelf.noOfPeopleLabel.text = Format(NSLocalizedString(@"kELUsersNumberSelectedLabel", nil),
                                               @(weakSelf.mParticipants.count));
    }];
    self.inviteAction.enabled = NO;
    
    [self.alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"kELNameLabel", nil);
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        
        [textField addTarget:weakSelf
                      action:@selector(onAlertControllerTextsChanged:)
            forControlEvents:UIControlEventEditingChanged];
    }];
    [self.alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"kELEmailLabel", nil);
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        [textField addTarget:weakSelf
                      action:@selector(onAlertControllerTextsChanged:)
            forControlEvents:UIControlEventEditingChanged];
    }];
    [self.alertController addAction:self.inviteAction];
    [self.alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELCancelButton", nil)
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
    
    [ELUtils registerValidators];
    [self presentViewController:self.alertController
                       animated:YES
                     completion:nil];
}

- (void)onAlertControllerTextsChanged:(UITextField *)sender {
    BOOL enabled;
    NSString *email;
    NSArray *emailErrors, *nameErrors;
    NSArray<UITextField *> *textFields = self.alertController.textFields;
    
    email = textFields.lastObject.text;
    emailErrors = [REValidation validateObject:email
                                          name:@"Email"
                                    validators:@[@"presence", @"email"]];
    nameErrors = [REValidation validateObject:textFields.firstObject.text
                                         name:@"Name"
                                   validators:@[@"presence"]];
    enabled = ((emailErrors.count == 0 && nameErrors.count == 0) &&
               ![email isEqualToString:AppSingleton.user.email]);
    
    [self.inviteAction setEnabled:enabled];
}

@end
