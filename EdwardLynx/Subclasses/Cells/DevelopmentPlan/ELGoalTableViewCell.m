//
//  ELGoalTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 01/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELGoalTableViewCell.h"
#import "AppDelegate.h"
#import "ELAddGoalActionTableViewCell.h"
#import "ELDevelopmentPlanAPIClient.h"
#import "ELGoal.h"
#import "ELGoalActionTableViewCell.h"

#pragma mark - Private Constants

static NSString * const kELCellIdentifier = @"ActionCell";
static NSString * const kELAddActionCellIdentifier = @"AddGoalActionCell";

#pragma mark - Class Extension

@interface ELGoalTableViewCell ()

@property (nonatomic, strong) ELGoal *goal;

@end

@implementation ELGoalTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    CGFloat size;
    
    [super awakeFromNib];
    // Initialization code
    
    size = 20;
    self.tintColor = ThemeColor(kELWhiteColor);
    
    [self.moreButton setHidden:[AppSingleton.user isNotAdminDevPlan]];
    [self.moreButton setImage:[FontAwesome imageWithIcon:fa_ellipsis_vertical
                                               iconColor:[UIColor whiteColor]
                                                iconSize:size
                                               imageSize:CGSizeMake(size, size)]
                     forState:UIControlStateNormal];
    
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.separatorColor = ThemeColor(kELDevPlanSeparatorColor);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = kELActionCellHeight;
    self.tableView.scrollEnabled = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    RegisterNib(self.tableView, kELCellIdentifier);
    RegisterNib(self.tableView, kELAddActionCellIdentifier);    
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
    return [AppSingleton.user isNotAdminDevPlan] ? self.goal.actions.count : self.goal.actions.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELGoalAction *action;
    ELGoalActionTableViewCell *cell;
    ELAddGoalActionTableViewCell *addCell;
    
    if (indexPath.row == self.goal.actions.count) {
        addCell = [tableView dequeueReusableCellWithIdentifier:kELAddActionCellIdentifier forIndexPath:indexPath];
        
        addCell.addLink = Format(@"%@/actions", self.goal.urlLink);
        addCell.tag = indexPath.row;
        
        return addCell;
    }
    
    action = self.goal.actions[indexPath.row];
    action.urlLink = Format(@"%@/actions/%@", self.goal.urlLink, @(action.objectId));
    
    cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier forIndexPath:indexPath];
    
    [cell configure:action atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *detailMessage;
    UIAlertController *controller;
    ELGoalAction *goalAction;
    ELGoalActionTableViewCell *cell;
    __weak typeof(self) weakSelf = self;
    void (^actionBlock)(UIAlertAction *);
    void (^completionBlock)(NSURLResponse *response, NSDictionary *responseDict, NSError *error);
    NSMutableArray *mActions = [[NSMutableArray alloc] initWithArray:self.goal.actions];
    __kindof UIViewController *visibleController = [ApplicationDelegate visibleViewController:self.window.rootViewController];
    
    if (indexPath.row == mActions.count || [AppSingleton.user isNotAdminDevPlan]) {
        return;
    }
    
    goalAction = mActions[indexPath.row];
    cell = [tableView cellForRowAtIndexPath:indexPath];
    completionBlock = ^(NSURLResponse *response,
                        NSDictionary *responseDict,
                        NSError *error) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.statusView.bounds];
        
        if (error) {
            imageView.image = [FontAwesome imageWithIcon:fa_circle_o
                                               iconColor:[UIColor whiteColor]
                                                iconSize:kELIconSize
                                               imageSize:CGSizeMake(kELIconSize, kELIconSize)];
            
            [cell updateStatusView:imageView];
            
            return;
        }
        
        AppSingleton.needsPageReload = YES;
        
        goalAction.checked = YES;
        imageView.image = [FontAwesome imageWithIcon:fa_check_circle
                                           iconColor:ThemeColor(kELGreenColor)
                                            iconSize:kELIconSize
                                           imageSize:CGSizeMake(kELIconSize, kELIconSize)];
        
        [cell updateStatusView:imageView];
        [mActions replaceObjectAtIndex:indexPath.row withObject:goalAction];
        
        [weakSelf.goal setActions:[mActions copy]];
        [weakSelf.delegate onGoalUpdate:weakSelf.goal];
        
        if ([[weakSelf.goal progressDetails][@"value"] floatValue] == 1.0f) {
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
                                message:NSLocalizedString(@"kELDevelopmentPlanGoalActionUpdateSuccess", nil)
                             completion:nil];
        }
    };
    actionBlock = ^(UIAlertAction *action) {
        UIActivityIndicatorView *indicatorView;
        ELDevelopmentPlanAPIClient *client = [[ELDevelopmentPlanAPIClient alloc] init];
        
        goalAction.checked = YES;
        
        // Action indicator
        indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:cell.statusView.bounds];
        indicatorView.backgroundColor = [UIColor clearColor];
        indicatorView.tintColor = [UIColor whiteColor];
        
        [indicatorView startAnimating];
        [cell updateStatusView:indicatorView];
        
        // API Call to update action
        [client updateDevelopmentPlanGoalActionWithParams:[goalAction apiPatchDictionary]
                                                     link:goalAction.urlLink
                                               completion:completionBlock];
    };
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (goalAction.checked) {
        return;
    }
    
    detailMessage = Format(NSLocalizedString(@"kELDevelopmentPlanGoalActionCompleteDetailsMessage", nil), goalAction.title);
    controller = Alert(NSLocalizedString(@"kELDevelopmentPlanGoalActionCompleteHeaderMessage", nil), detailMessage);
    
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
    NSString *timestamp;
    BOOL completed = self.goal.progress == 1;
    UIColor *color = ThemeColor(completed ? kELOrangeColor : kELBlueColor);
    
    if (completed) {
        timestamp = NSLocalizedString(@"kELListFilterCompleted", nil);
    } else {
        if (self.goal.dueDateChecked) {
            timestamp = Format(NSLocalizedString(@"kELDevelopmentPlanGoalTimestampDueDate", nil),
                               self.goal.dueDateString);
        } else {
            timestamp = @"";
        }
    }
    
    // Content
    self.goalLabel.text = self.goal.title;
    self.completedLabel.text = [self.goal progressDetails][@"text"];
    self.completedLabel.textColor = color;
    self.timestampLabel.text = timestamp;
    self.descriptionLabel.text = self.goal.shortDescription;
    
    // Progress
    self.leftView.backgroundColor = color;
    self.progressView.layer.cornerRadius = 2.5;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.progress = self.goal.progress;
    self.progressView.progressTintColor = color;
    self.progressView.progressViewStyle = UIProgressViewStyleBar;
    self.progressView.trackTintColor = HEXCOLORALPHA(0x995db, 0.3);
    
    [self.tableView reloadData];
}

#pragma mark - Interface Builder Actions

- (IBAction)onMoreButtonClick:(id)sender {
    [self.delegate onGoalOptions:self.goal sender:(UIButton *)sender];
}

@end
