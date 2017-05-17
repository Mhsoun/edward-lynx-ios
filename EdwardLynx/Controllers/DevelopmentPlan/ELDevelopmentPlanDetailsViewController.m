//
//  ELDevelopmentPlanDetailsViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 01/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <PNChart/PNCircleChart.h>

#import "ELDevelopmentPlanDetailsViewController.h"
#import "ELDetailViewManager.h"
#import "ELDevelopmentPlan.h"
#import "ELDevelopmentPlanAPIClient.h"
#import "ELGoalTableViewCell.h"

#pragma mark - Private Constants

static CGFloat const kELGoalCellHeight = 105;

static NSString * const kELCellIdentifier = @"GoalCell";

#pragma mark - Class Extension

@interface ELDevelopmentPlanDetailsViewController ()

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray<ELGoal *> *mGoals;
@property (nonatomic, strong) ELDetailViewManager *detailViewManager;
@property (nonatomic, strong) PNCircleChart *circleChart;

@end

@implementation ELDevelopmentPlanDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.mGoals = [[NSMutableArray alloc] init];
    self.circleChart = [[PNCircleChart alloc] initWithFrame:self.circleChartView.bounds
                                                      total:[NSNumber numberWithInt:100]
                                                    current:[NSNumber numberWithInt:0]
                                                  clockwise:YES
                                                     shadow:YES
                                                shadowColor:[UIColor blackColor]
                                       displayCountingLabel:YES
                                          overrideLineWidth:[NSNumber numberWithInteger:12]];
    
    [self.circleChartView addSubview:self.circleChart];
    
    if (!self.devPlan) {
        self.detailViewManager = [[ELDetailViewManager alloc] initWithObjectId:self.objectId];
                
        [self.detailViewManager processRetrievalOfDevelopmentPlanDetails];
    } else {
        self.title = [self.devPlan.name uppercaseString];
        self.mGoals = [NSMutableArray arrayWithArray:self.devPlan.goals];
        self.detailViewManager = [[ELDetailViewManager alloc] initWithDetailObject:self.devPlan];
        
        [self setupChart];
        [self.indicatorView stopAnimating];
    }

    self.selectedIndex = -1;
    self.detailViewManager.delegate = self;
    
    // Table View
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:kELCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DLog(@"%@", [self class]);
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.devPlan.goals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELGoal *goal = self.devPlan.goals[indexPath.row];
    ELGoalTableViewCell *cell = (ELGoalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kELCellIdentifier];
    
    goal.createdAt = self.devPlan.createdAt;
    goal.urlLink = [NSString stringWithFormat:@"%@/goals/%@", self.devPlan.urlLink, @(goal.objectId)];
    
    cell.delegate = self;
    cell.devPlanName = self.devPlan.name;
    
    [cell configure:goal atIndexPath:indexPath];
    [cell.tableView setHidden:self.selectedIndex != indexPath.row];
    
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
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELDetailsPageLoadError", nil)
                     completion:^{}];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    self.devPlan = [[ELDevelopmentPlan alloc] initWithDictionary:responseDict error:nil];
    self.mGoals = [NSMutableArray arrayWithArray:self.devPlan.goals];
    self.title = [self.devPlan.name uppercaseString];
    
    [self setupChart];
    [self.indicatorView stopAnimating];
    [self.tableView reloadData];
}

#pragma mark - Protocol Methods (ELDevelopmentPlan)

- (void)onGoalUpdate:(__kindof ELModel *)object {
    ELGoal *goal = (ELGoal *)object;
    
    [self.mGoals replaceObjectAtIndex:self.selectedIndex withObject:goal];
    [self.devPlan setGoals:[self.mGoals copy]];
    [self.tableView reloadData];
    
    [self.chartLabel setAttributedText:self.devPlan.attributedProgressText];
    [self.circleChart updateChartByCurrent:[NSNumber numberWithDouble:(self.devPlan.progress * 100)]];
}

#pragma mark - Private Methods

- (void)setupChart {
    self.chartLabel.attributedText = self.devPlan.attributedProgressText;
    
    // Chart
    [ELUtils circleChart:self.circleChart developmentPlan:self.devPlan];
    [self.circleChart setDisplayAnimated:NO];
    [self.circleChart strokeChart];
}

@end
