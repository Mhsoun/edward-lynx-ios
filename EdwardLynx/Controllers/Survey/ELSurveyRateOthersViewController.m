//
//  ELSurveyRateOthersViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 24/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurveyRateOthersViewController.h"
#import "ELDropdownView.h"
#import "ELParticipant.h"
#import "ELParticipantTableViewCell.h"
#import "ELSurvey.h"
#import "ELSurveyViewManager.h"

#pragma mark - Private Constants

static NSInteger const kELCellHeight = 90;
static NSString * const kELCellIdentifier = @"ParticipantCell";

#pragma mark - Class Extension

@interface ELSurveyRateOthersViewController ()

@property (nonatomic) kELUserRole selectedRole;
@property (nonatomic, strong) NSMutableArray *mRoles, *mUsers;
@property (nonatomic, strong) ELDropdownView *dropdown;
@property (nonatomic, strong) ELSurveyViewManager *viewManager;

@end

@implementation ELSurveyRateOthersViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.mUsers = [[NSMutableArray alloc] init];
    self.mRoles = [[NSMutableArray alloc] initWithArray:@[[ELUtils labelByUserRole:kELUserRoleColleague],
                                                          [ELUtils labelByUserRole:kELUserRoleManager],
                                                          [ELUtils labelByUserRole:kELUserRoleCustomer],
                                                          [ELUtils labelByUserRole:kELUserRoleMatrixManager],
                                                          [ELUtils labelByUserRole:kELUserRoleOtherStakeholder],
                                                          [ELUtils labelByUserRole:kELUserRoleDirectReport]]];
    self.selectedRole = [ELUtils userRoleByLabel:self.mRoles[0]];
    
    self.viewManager = [[ELSurveyViewManager alloc] initWithSurvey:self.survey];
    self.viewManager.delegate = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = kELCellHeight;
    self.tableView.emptyDataSetSource = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;    
    
    self.dropdown = [[ELDropdownView alloc] initWithItems:self.mRoles
                                           baseController:self
                                         defaultSelection:nil];
    
    [self.heightConstraint setConstant:kELCellHeight];
    [self.tableView updateConstraints];
    
    [self.tableView registerNib:[UINib nibWithNibName:kELCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELCellIdentifier];
    
    [self.dropdown setFrame:self.dropdownView.bounds];
    [self.dropdownView addSubview:self.dropdown];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.dropdown reset];
}

- (void)dealloc {
    DLog(@"%@", [self class]);
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELParticipantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier
                                                                       forIndexPath:indexPath];
    
    [cell configure:self.mUsers[indexPath.row] atIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Remove the deleted object from your data source.
        // If your data source is an NSMutableArray, do this
        [self.mUsers removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        [self adjustTableViewSize];
    }
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    self.title = [self.survey.name uppercaseString];
    self.descriptionLabel.text = self.survey.evaluationText;
}

#pragma mark - Protocol Methods (ELDropdown)

- (void)onDropdownSelectionValueChange:(NSString *)value index:(NSInteger)index {
    self.selectedRole = [ELUtils userRoleByLabel:value];
}

#pragma mark - Protocol Methods (ELSurveyViewManager)

- (void)onAPIPostResponseError:(NSDictionary *)errorDict {
    __weak typeof(self) weakSelf = self;
    
    [self dismissViewControllerAnimated:YES completion:^{
        [ELUtils presentToastAtView:weakSelf.view
                            message:errorDict[@"message"]
                         completion:nil];
    }];
}

- (void)onAPIPostResponseSuccess:(NSDictionary *)responseDict {
    __weak typeof(self) weakSelf = self;
    
    [self dismissViewControllerAnimated:YES completion:^{
        [ELUtils presentToastAtView:weakSelf.view
                            message:NSLocalizedString(@"kELSurveyRateSuccess", nil)
                         completion:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

#pragma mark - Protocol Methods (DZNEmptyDataSet)

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attributes = @{NSFontAttributeName: Font(@"Lato-Regular", 14.0f),
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"kELInviteUsersRetrievalEmpty", nil)
                                           attributes:attributes];
}

#pragma mark - Private Methods

- (void)adjustTableViewSize {
    CGFloat tableViewContentSizeHeight = self.mUsers.count == 0 ? kELCellHeight : kELCellHeight * self.mUsers.count;
    
    [self.heightConstraint setConstant:tableViewContentSizeHeight];
    [self.tableView updateConstraints];
}

#pragma mark - Interface Builder Actions

- (IBAction)onAddUserButtonClick:(id)sender {
    BOOL isValid;
    ELFormItemGroup *emailGroup = [[ELFormItemGroup alloc] initWithInput:self.emailTextField
                                                                    icon:nil
                                                              errorLabel:self.emailErrorLabel];
    ELFormItemGroup *nameGroup = [[ELFormItemGroup alloc] initWithInput:self.nameTextField
                                                                    icon:nil
                                                              errorLabel:self.nameErrorLabel];
    
    isValid = [self.viewManager validateAddInviteUserFormValues:@{@"name": nameGroup,
                                                                  @"email": emailGroup}];
    
    if (!isValid) {
        return;
    }
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    [self.mUsers addObject:[[ELParticipant alloc] initWithDictionary:@{@"id": @(-1),
                                                                       @"name": self.nameTextField.text,
                                                                       @"email": self.emailTextField.text,
                                                                       @"role": @(self.selectedRole)}
                                                               error:nil]];
    
    [self.nameTextField setText:@""];
    [self.emailTextField setText:@""];
    [self.tableView reloadData];
    [self adjustTableViewSize];
}

- (IBAction)onInviteButtonClick:(id)sender {
    NSMutableArray *mUsers;
    
    if (!self.mUsers.count || self.mUsers.count == 0) {
        [ELUtils presentToastAtView:self.view
                            message:NSLocalizedString(@"kELInviteUsersRetrievalEmpty", nil)
                         completion:nil];
        
        return;
    }
    
    [self presentViewController:[ELUtils loadingAlert]
                       animated:YES
                     completion:nil];
    
    mUsers = [[NSMutableArray alloc] init];
    
    for (ELParticipant *participant in self.mUsers) [mUsers addObject:[participant othersRateDictionary]];
    
    [self.viewManager processInviteOthersToRateYouWithParams:@{@"recipients": [mUsers copy]}];
}

@end
