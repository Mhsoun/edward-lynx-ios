//
//  ELTeamDevPlanDetailsViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELTeamDevPlanDetailsViewController.h"
#import "ELGoal.h"
#import "ELTeamMemberGoalTableViewCell.h"
#import "ELTeamViewManager.h"

#pragma mark - Private Constants

static CGFloat const kELGoalCellHeight = 105;
static NSString * const kELCellIdentifier = @"TeamMemberGoalCell";

#pragma mark - Class Extension

@interface ELTeamDevPlanDetailsViewController ()

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) NSInteger selectedSection;
@property (nonatomic, strong) NSMutableArray<ELTeamDevelopmentPlanUser *> *mUsers;
@property (nonatomic, strong) ELTeamViewManager *viewManager;

@end

@implementation ELTeamDevPlanDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.selectedIndex = -1;
    self.selectedSection = -1;
    self.mUsers = [[NSMutableArray alloc] init];
    
    self.viewManager = [[ELTeamViewManager alloc] init];
    self.viewManager.delegate = self;
    
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.emptyDataSetSource = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.hidden = YES;
    
    RegisterNib(self.tableView, kELCellIdentifier);
    
    [self.viewManager processRetrieveTeamDevPlanDetails:self.devPlanId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DLog(@"%@", [self class]);
}

#pragma mark - Protocol Methods (UITableViewCell)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mUsers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.mUsers[section] goals] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELTeamMemberGoalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier
                                                                          forIndexPath:indexPath];
    
    [cell.chartView setHidden:indexPath.row > 0];
    [cell.tableView setHidden:(self.selectedSection != indexPath.section && self.selectedIndex != indexPath.row)];
    [cell configure:self.mUsers[indexPath.section] atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex == indexPath.row && self.selectedSection == indexPath.section) {  // User taps expanded row
        self.selectedIndex = -1;
        self.selectedSection = -1;
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (self.selectedIndex != -1) {  // User taps different row
        NSIndexPath *prevPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
        
        self.selectedIndex = indexPath.row;
        self.selectedSection = indexPath.section;
        
        [tableView reloadRowsAtIndexPaths:@[prevPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {  // User taps new row with none expanded
        self.selectedIndex = indexPath.row;
        self.selectedSection = indexPath.section;
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    // Scroll selected cell to top (to initially display much content as possible)
    [tableView scrollToRowAtIndexPath:indexPath
                     atScrollPosition:UITableViewScrollPositionTop
                             animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isSelected;
    CGFloat expandedHeight;
    ELTeamDevelopmentPlanGoal *goal = [self.mUsers[indexPath.section] goals][indexPath.row];
    
    isSelected = self.selectedSection == indexPath.section && self.selectedIndex == indexPath.row;
    expandedHeight = (kELActionCellHeight * goal.actions.count) + kELGoalCellHeight;
    
    return isSelected ? expandedHeight : kELGoalCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ELTeamDevelopmentPlanUser *user = self.mUsers[section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 35)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(tableView.frame), 30)];
    
    label.font = Font(@"Lato-Medium", 16.0f);
    label.textColor = [UIColor whiteColor];
    label.text = user.name;
    
    [view addSubview:label];
    
    return view;
}

#pragma mark - Protocol Methods (ELTeamViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    [self.tableView setHidden:NO];
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELDetailsPageLoadError", nil)
                     completion:nil];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    self.title = [responseDict[@"name"] uppercaseString];
    
    for (NSDictionary *dict in responseDict[@"goals"]) {
        [self.mUsers addObject:[[ELTeamDevelopmentPlanUser alloc] initWithDictionary:dict error:nil]];
    }
    
    [self.indicatorView stopAnimating];
    [self.tableView setHidden:NO];
    [self.tableView reloadData];
}

#pragma mark - Protocol Methods (DZNEmptyDataSet)

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attributes = @{NSFontAttributeName: Font(@"Lato-Regular", 14.0f),
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"kELInviteUsersRetrievalEmpty", nil)
                                           attributes:attributes];
}

@end
