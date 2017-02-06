//
//  ELDevelopmentPlanDetailsViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 01/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDevelopmentPlanDetailsViewController.h"

#pragma mark - Private Constants

static CGFloat const kELActionCellHeight = 60;
static CGFloat const kELGoalCellHeight = 85;

static NSString * const kELCellIdentifier = @"GoalCell";

#pragma mark - Class Extension

@interface ELDevelopmentPlanDetailsViewController ()

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) ELDetailViewManager *detailViewManager;

@end

@implementation ELDevelopmentPlanDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    if (!self.devPlan) {
        self.detailViewManager = [[ELDetailViewManager alloc] initWithObjectId:self.objectId];
        
        [self.detailViewManager processRetrievalOfDevelopmentPlanDetails];
    } else {
        self.detailViewManager = [[ELDetailViewManager alloc] initWithDetailObject:self.devPlan];
        self.title = [self.devPlan.name uppercaseString];
    }

    self.selectedIndex = -1;
    self.detailViewManager.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.devPlan.goals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELGoal *goal = self.devPlan.goals[indexPath.row];
    ELGoalTableViewCell *cell = (ELGoalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kELCellIdentifier];
    
    goal.urlLink = [NSString stringWithFormat:@"%@/goals/%@", self.devPlan.urlLink, @(goal.objectId)];
    
    [cell configure:goal atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex == indexPath.row) {  // User taps expanded row
        self.selectedIndex = -1;
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (self.selectedIndex != -1) {  // User taps different row
        NSIndexPath *prevPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
        
        self.selectedIndex = indexPath.row;
        
        [tableView reloadRowsAtIndexPaths:@[prevPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {  // User taps new row with none expanded
        self.selectedIndex = indexPath.row;
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    // Scroll selected cell to top (to initially display much content as possible)
    [tableView scrollToRowAtIndexPath:indexPath
                     atScrollPosition:UITableViewScrollPositionTop
                             animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELGoal *goal = self.devPlan.goals[indexPath.row];
    CGFloat expandedHeight = (kELActionCellHeight * goal.actions.count) + kELGoalCellHeight;
    
    return self.selectedIndex == indexPath.row ? expandedHeight : kELGoalCellHeight;
}

#pragma mark - Protocol Methods (ELDetailViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    DLog(@"%@", errorDict);
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    self.devPlan = [[ELDevelopmentPlan alloc] initWithDictionary:responseDict error:nil];
    self.title = self.devPlan.name;
    
    [self.tableView reloadData];
}

#pragma mark - Protocol Methods (ELDevelopmentPlanGoalAction)

- (void)onGoalActionUpdate:(__kindof ELModel *)object {
    ELGoalAction *action = (ELGoalAction *)object;
    ELDevelopmentPlanAPIClient *client = [[ELDevelopmentPlanAPIClient alloc] init];
    
    [client updateGoalActionWithParams:[action apiPatchDictionary]
                                  link:action.urlLink
                            completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        if (error) {
            return;
        }
        
        [ELUtils presentToastAtView:self.view
                            message:@"Action successfully updated."
                         completion:^{
                             //
                         }];
    }];
}

@end
