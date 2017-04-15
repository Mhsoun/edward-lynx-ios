//
//  ELGoalTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 01/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELGoalTableViewCell.h"
#import "AppDelegate.h"
#import "ELDevelopmentPlanAPIClient.h"
#import "ELGoal.h"
#import "ELGoalActionTableViewCell.h"

#pragma mark - Private Constants

static CGFloat const kELIconSize = 15;
static NSString * const kELCellIdentifier = @"ActionCell";

#pragma mark - Class Extension

@interface ELGoalTableViewCell ()

@property (nonatomic, strong) ELGoal *goal;

@end

@implementation ELGoalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.tintColor = [[RNThemeManager sharedManager] colorForKey:kELGreenColor];
    
    self.tableView.separatorColor = [[RNThemeManager sharedManager] colorForKey:kELDevPlanSeparatorColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = kELActionCellHeight;
    self.tableView.scrollEnabled = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:kELCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELCellIdentifier];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Protocol Methods

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    self.goal = (ELGoal *)object;
    
    // Content
    [self updateContent];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goal.actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELGoalActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier];
    ELGoalAction *action = self.goal.actions[indexPath.row];
    NSString *colorKey = action.checked ? kELGreenColor : kELWhiteColor;
    UIImage *checkIcon = [FontAwesome imageWithIcon:action.checked ? fa_check_circle : fa_circle_o
                                          iconColor:[[RNThemeManager sharedManager] colorForKey:colorKey]
                                           iconSize:kELIconSize
                                          imageSize:CGSizeMake(kELIconSize, kELIconSize)];
    
    action.urlLink = [NSString stringWithFormat:@"%@/actions/%@", self.goal.urlLink, @(action.objectId)];
    
    cell.accessoryView = [[UIImageView alloc] initWithImage:checkIcon];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.titleLabel.text = action.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *controller;
    NSMutableArray *mActions = [[NSMutableArray alloc] initWithArray:self.goal.actions];
    ELGoalAction *goalAction = mActions[indexPath.row];
    __kindof UIViewController *visibleController = [ApplicationDelegate visibleViewController:self.window.rootViewController];
    void (^actionBlock)(UIAlertAction *) = ^(UIAlertAction *action) {
        UITableViewCell *cell;
        UIActivityIndicatorView *indicatorView;
        ELDevelopmentPlanAPIClient *client = [[ELDevelopmentPlanAPIClient alloc] init];
        
        goalAction.checked = YES;
        
        // Action indicator
        cell = [tableView cellForRowAtIndexPath:indexPath];
        indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, kELIconSize, kELIconSize)];
        indicatorView.backgroundColor = [UIColor clearColor];
        indicatorView.tintColor = [UIColor whiteColor];
        
        [cell setAccessoryView:indicatorView];
        [indicatorView startAnimating];
        
        // API Call to update action
        [client updateGoalActionWithParams:[goalAction apiPatchDictionary]
                                      link:goalAction.urlLink
                                completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
            UIImage *checkIcon;
            
            if (error) {
                return;
            }
            
            goalAction.checked = YES;
            checkIcon = [FontAwesome imageWithIcon:fa_check_circle
                                         iconColor:[[RNThemeManager sharedManager] colorForKey:kELGreenColor]
                                          iconSize:kELIconSize
                                         imageSize:CGSizeMake(kELIconSize, kELIconSize)];
            
            [cell setAccessoryView:[[UIImageView alloc] initWithImage:checkIcon]];
            [mActions replaceObjectAtIndex:indexPath.row withObject:goalAction];
            
            [self.goal setActions:[mActions copy]];
            [self.delegate onGoalUpdate:self.goal];
            
            if ([[self.goal progressDetails][@"value"] floatValue] == 1.0f) {
                NSDictionary *detailsDict = @{@"title": [self.devPlanName uppercaseString],
                                              @"header": NSLocalizedString(@"kELDevelopmentPlanGoalCompleteHeader", nil),
                                              @"details": NSLocalizedString(@"kELDevelopmentPlanGoalCompleteDetail", nil),
                                              @"image": @"Ribbon"};
                
                // Display popup
                [ELUtils displayPopupForViewController:visibleController
                                                  type:kELPopupTypeMessage
                                               details:detailsDict];
            } else {
                [ELUtils presentToastAtView:visibleController.view
                                    message:@"Action successfully updated."
                                 completion:^{}];
            }
        }];
    };
    
    // FIX Cell being need to be clicked twice to invoke method
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (goalAction.checked) {
        return;
    }
    
    controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"kELDevelopmentPlanGoalActionCompleteHeaderMessage", nil)
                                                     message:NSLocalizedString(@"kELDevelopmentPlanGoalActionCompleteDetaislMessage", nil)
                                              preferredStyle:UIAlertControllerStyleAlert];
    
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELCompleteButton", nil)
                                                   style:UIAlertActionStyleDefault
                                                 handler:actionBlock]];
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELCancelButton", nil)
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
    
    [visibleController presentViewController:controller
                                    animated:YES
                                  completion:nil];
}

#pragma mark - Private Methods

- (void)updateContent {
    NSInteger days = [[NSDate date] mt_daysSinceDate:self.goal.createdAt];
    NSString *colorKey = self.goal.progress == 1 ? kELOrangeColor : kELBlueColor;
    NSString *stringKey = days == 1 ? @"kELDevelopmentPlanGoalTimestampSingular" : @"kELDevelopmentPlanGoalTimestampPlural";
    UIColor *color = [[RNThemeManager sharedManager] colorForKey:colorKey];
    
    stringKey = days == 0 ? @"kELDevelopmentPlanGoalTimestampToday" : stringKey;
    
    // Content
    self.goalLabel.text = self.goal.title;
    self.completedLabel.text = [self.goal progressDetails][@"text"];
    self.completedLabel.textColor = color;
    self.timestampLabel.text = [NSString stringWithFormat:NSLocalizedString(stringKey, nil), @(days)];
    self.descriptionLabel.text = self.goal.shortDescription.length == 0 ? NSLocalizedString(@"kELNoDescriptionLabel", nil) :
                                                                          self.goal.shortDescription;
    
    // Progress
    self.leftView.backgroundColor = color;
    self.progressView.layer.cornerRadius = 2.5;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.progress = self.goal.progress;
    self.progressView.progressTintColor = color;
    self.progressView.progressViewStyle = UIProgressViewStyleBar;
    
    [self.tableView reloadData];
}

@end
