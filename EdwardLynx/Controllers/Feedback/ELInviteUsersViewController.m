//
//  ELInviteUsersViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELInviteUsersViewController.h"

#pragma mark - Private Constants

static CGFloat const kELFormViewHeight = 395;
static NSString * const kELNoParticipantRole = @"No role selected";
static NSString * const kELCellIdentifier = @"ParticipantCell";

#pragma mark - Class Extension

@interface ELInviteUsersViewController ()

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
    self.roleLabel.text = kELNoParticipantRole;
    self.viewManager = [[ELFeedbackViewManager alloc] init];
    self.viewManager.delegate = self;
    self.provider = [[ELDataProvider alloc] initWithDataArray:@[]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.dataSource dataSetEmptyText:@"No participant(s) added yet."
                          description:@""];
    [self.tableView registerNib:[UINib nibWithNibName:kELCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELCellIdentifier];
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

#pragma mark - Protocol Methods (ELFeedbackViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    // TODO Implementation
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    // TODO Implementation
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
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width,
                                             (kELFormViewHeight + tableViewContentSizeHeight + 30));
}

#pragma mark - Interface Builder Actions

- (IBAction)onRoleButtonClick:(id)sender {
    // TODO Implementation
}

- (IBAction)onAddButtonClick:(id)sender {
    BOOL isValid;
    NSDictionary *formDict;
    ELFormItemGroup *nameGroup,
                    *emailGroup,
                    *roleGroup;
    
    nameGroup = [[ELFormItemGroup alloc] initWithText:self.nameTextField.text
                                                 icon:nil
                                           errorLabel:self.nameErrorLabel];
    emailGroup = [[ELFormItemGroup alloc] initWithText:self.emailTextField.text
                                                     icon:nil
                                               errorLabel:self.emailErrorLabel];
    roleGroup = [[ELFormItemGroup alloc] initWithText:self.roleLabel.text
                                                 icon:nil
                                           errorLabel:self.roleErrorLabel];
    isValid = [self.viewManager validateInstantFeedbackInviteUsersFormValues:@{@"name": nameGroup,
                                                                               @"email": emailGroup,
                                                                               @"role": roleGroup}];
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (!isValid) {
        return;
    }
    
    // TEMP Form data
    formDict = @{@"name": @"",
                 @"lang": @"en",
                 @"type": @"instant",
                 @"startDate": @"",
                 @"endDate": @"",
                 @"description": @"",
                 @"inviteText": @"",
                 @"thankYouText": @"",
                 @"questionInfoText": @"",
                 @"questions": @[@{@"text": [self.instantFeedbackDict[@"question"] textValue],
                                   @"isNA": @NO,
                                   @"answer": @{@"type": @([ELUtils answerTypeByLabel:[self.instantFeedbackDict[@"type"] textValue]]),
                                                @"options": @[]}}],
                 @"recipients": @[]};
    
//    [self.viewManager processInstantFeedback:formDict];
}

@end
