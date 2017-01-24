//
//  ELInviteUsersViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELInviteUsersViewController.h"

#pragma mark - Private Constants

static CGFloat const kELFormViewHeight = 120;
static NSString * const kELCellIdentifier = @"ParticipantCell";
static NSString * const kELEvaluationLabel = @"The person evaluated is: %@";
static NSString * const kELSuccessMessageShareReport = @"Reports successfully shared.";
static NSString * const kELSuccessMessageInstantFeedback = @"Instant Feedback successfully created.";

#pragma mark - Class Extension

@interface ELInviteUsersViewController ()

@property (nonatomic, strong) ELTableDataSource *dataSource;
@property (nonatomic, strong) ELDataProvider<ELParticipant *> *provider;
@property (nonatomic, strong) ELFeedbackViewManager *viewManager;
@property (nonatomic, strong) NSMutableArray *mParticipants;

@end

@implementation ELInviteUsersViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.searchBar.delegate = self;
    self.mParticipants = [[NSMutableArray alloc] init];
    
    self.viewManager = [[ELFeedbackViewManager alloc] init];
    self.viewManager.delegate = self;
    
    self.provider = [[ELDataProvider alloc] initWithDataArray:[ELAppSingleton sharedInstance].participants];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.dataSource dataSetEmptyText:@"No participants"
                          description:@""];
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

#pragma mark - Private Methods

- (void)layoutInstantFeedbackSharePage {
    self.headerLabel.text = @"Invite people to participate";
    self.detailLabel.text = [NSString stringWithFormat:kELEvaluationLabel, [ELAppSingleton sharedInstance].user.name];
    self.searchBar.placeholder = @"Search Participants";
}

- (void)layoutReportSharePage {
    self.headerLabel.text = @"Share report to users";
    self.detailLabel.text = @"Select users for them to be able to view this report";
    self.searchBar.placeholder = @"Search Users";
}

#pragma mark - Protocol Methods (UISearchBar)

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSMutableArray *mParticipants = [[ELAppSingleton sharedInstance].participants mutableCopy];
    NSString *condition = @"SELF.name CONTAINS [cd]%@ || SELF.email CONTAINS [cd]%@";
    
    if (searchText.length > 0) {
        [mParticipants filterUsingPredicate:[NSPredicate predicateWithFormat:condition,
                                             searchText,
                                             searchText]];
    }
    
    self.provider = [[ELDataProvider alloc] initWithDataArray:[mParticipants copy]];
    
    [self.tableView reloadData];
    [self adjustScrollViewContentSize];
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.provider numberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELParticipantTableViewCell *cell = (ELParticipantTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kELCellIdentifier];
    
    [cell configure:[self.provider objectAtIndexPath:indexPath] atIndexPath:indexPath];
    
    // Toggle selected state
    if ([cell.participant.isSelected boolValue]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        if (![self.mParticipants containsObject:cell.participant]) {
            [self.mParticipants addObject:cell.participant];
        }
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [self.mParticipants removeObject:cell.participant];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __kindof UITableViewCell<ELRowHandlerDelegate> *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell handleObject:[self.provider objectAtIndexPath:indexPath] selectionActionAtIndexPath:indexPath];
    [self.tableView reloadData];
}

#pragma mark - Protocol Methods (ELFeedbackViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    // TODO Implementation
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    NSString *successMessage = self.inviteType == kELInviteUsersInstantFeedback ? kELSuccessMessageInstantFeedback :
                                                                                  kELSuccessMessageShareReport;
    
    // Clear selections
    for (int i = 0; i < self.mParticipants.count; i++) {
        ELParticipant *participant = self.mParticipants[i];
        participant.isSelected = @NO;
        
        [self.provider updateObject:participant
                        atIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.mParticipants removeAllObjects];
    
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

#pragma mark - Interface Builder Actions

- (IBAction)onInviteButtonClick:(id)sender {
    NSMutableArray *mUsers = [[NSMutableArray alloc] init];
    
    if (self.inviteType == kELInviteUsersInstantFeedback) {
        NSArray *questions = @[@{@"text": [self.instantFeedbackDict[@"question"] textValue],
                                 @"isNA": @([self.instantFeedbackDict[@"isNA"] boolValue]),
                                 @"answer": @{@"type": @([ELUtils answerTypeByLabel:[self.instantFeedbackDict[@"type"] textValue]])}}];
        
        for (ELParticipant *participant in self.mParticipants) [mUsers addObject:[participant toDictionary]];
        
        [self.viewManager processInstantFeedback:@{@"lang": @"en",
                                                   @"anonymous": self.instantFeedbackDict[@"anonymous"],
                                                   @"questions": questions,
                                                   @"recipients": [mUsers copy]}];
    } else if (self.inviteType == kELInviteUsersReports) {
        for (ELParticipant *participant in self.mParticipants) [mUsers addObject:@(participant.objectId)];
        
        [self.viewManager processSharingOfReportToUsers:@{@"users": [mUsers copy]}
                                                   atId:self.instantFeedback.objectId];
    }
}

@end
