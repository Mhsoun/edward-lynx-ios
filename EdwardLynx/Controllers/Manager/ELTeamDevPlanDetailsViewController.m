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

#pragma mark - Private Constants

static CGFloat const kELGoalCellHeight = 105;
static NSString * const kELCellIdentifier = @"TeamMemberGoalCell";

#pragma mark - Class Extension

@interface ELTeamDevPlanDetailsViewController ()

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) NSInteger selectedSection;

@end

@implementation ELTeamDevPlanDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.selectedIndex = -1;
    self.selectedSection = -1;
    
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    RegisterNib(self.tableView, kELCellIdentifier);
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELTeamMemberGoalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier
                                                                          forIndexPath:indexPath];
    
    // TODO Populate
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex == indexPath.row) {  // User taps expanded row
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
    ELGoal *goal = self.goals[indexPath.section][indexPath.row];
    
    isSelected = self.selectedIndex == indexPath.row && self.selectedSection == indexPath.section;
    expandedHeight = (kELActionCellHeight * (goal.actions.count + 1)) + kELGoalCellHeight;
    
    return isSelected ? expandedHeight : kELGoalCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 35)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(tableView.frame), 30)];
    
    label.font = Font(@"Lato-Medium", 16.0f);
    label.textColor = [UIColor whiteColor];
    label.text = @"";  // TEMP Supply user's name
    
    [view addSubview:label];
    
    return view;
}

@end
