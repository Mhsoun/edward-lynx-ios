//
//  ELTeamMemberGoalTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <PNChart/PNChart.h>

#import "ELTeamMemberGoalTableViewCell.h"
#import "ELGoalActionTableViewCell.h"

#pragma mark - Private Constants

static NSString * const kELCellIdentifier = @"ActionCell";

#pragma mark - Class Extension

@interface ELTeamMemberGoalTableViewCell ()

@property (nonatomic, strong) ELTeamDevelopmentPlanGoal *goal;
@property (nonatomic, strong) PNCircleChart *circleChart;

@end

@implementation ELTeamMemberGoalTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.tintColor = ThemeColor(kELWhiteColor);
    self.circleChart = [[PNCircleChart alloc] initWithFrame:self.chartView.bounds
                                                      total:@100
                                                    current:@0
                                                  clockwise:YES
                                                     shadow:YES
                                                shadowColor:ThemeColor(kELHeaderColor)
                                       displayCountingLabel:YES
                                          overrideLineWidth:@7];
    
    [self.chartView addSubview:self.circleChart];
    
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.separatorColor = ThemeColor(kELDevPlanSeparatorColor);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = kELActionCellHeight;
    self.tableView.scrollEnabled = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    RegisterNib(self.tableView, kELCellIdentifier);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Protocol Methods

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    ELTeamDevelopmentPlanUser *user = (ELTeamDevelopmentPlanUser *)object;
    
    self.goal = user.goals[indexPath.row];
    
    // Content
    [self updateContentForUser:user indexPath:indexPath];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goal.actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELGoalActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier
                                                                      forIndexPath:indexPath];
    
    [cell.moreButton setHidden:YES];
    [cell configure:self.goal.actions[indexPath.row] atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Private Methods

- (void)updateContentForUser:(ELTeamDevelopmentPlanUser *)user indexPath:(NSIndexPath *)indexPath {
    CGFloat progress;
    UIColor *color = ThemeColor(self.goal.progress == 1 ? kELOrangeColor : kELBlueColor);
    
    self.goalLabel.text = self.goal.title;
    self.goalLabel.text = self.goal.title;
    self.completedLabel.text = [self.goal progressDetails][@"text"];
    self.completedLabel.textColor = color;
    
    // Progress
    self.leftView.backgroundColor = color;
    self.progressView.layer.cornerRadius = 2.5;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.progress = self.goal.progress;
    self.progressView.progressTintColor = color;
    self.progressView.progressViewStyle = UIProgressViewStyleBar;
    self.progressView.trackTintColor = HEXCOLORALPHA(0x995db, 0.3);
    
    // Chart View
    if (self.chartView.hidden) {
        return;
    }
    
    progress = [[user.goals valueForKeyPath:@"@avg.progress"] floatValue];
    
    [ELUtils circleChart:self.circleChart progress:progress];
    
    [self.circleChart.countingLabel setFont:Font(@"Lato-Bold", 12.0f)];
    [self.circleChart setDisplayAnimated:NO];
    [self.circleChart strokeChart];
}

#pragma mark - Interface Builder Action

- (void)onMoreButtonClick:(id)sender {
    
}

@end
