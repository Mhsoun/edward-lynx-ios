//
//  ELDashboardHeaderTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDashboardHeaderTableViewCell.h"
#import "ELActionView.h"
#import "ELBaseViewController.h"
#import "ELShortcutView.h"

@interface ELDashboardHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *devPlanView;
@property (weak, nonatomic) IBOutlet UIView *feedbackView;
@property (weak, nonatomic) IBOutlet UIView *surveyView;
@property (weak, nonatomic) IBOutlet UIView *teamView;

@property (weak, nonatomic) IBOutlet UIView *answerActionView;
@property (weak, nonatomic) IBOutlet UIView *resultsActionView;
@property (weak, nonatomic) IBOutlet UIView *inviteActionView;
@property (weak, nonatomic) IBOutlet UIView *createActionView;

@property (strong, nonatomic) __kindof ELBaseViewController *controller;

@end

@implementation ELDashboardHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupHeaderContent:(NSArray *)contents controller:(__kindof ELBaseViewController *)controller {
    ELActionView *actionView;
    ELShortcutView *shortcutView;
    
    self.controller = controller;
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": NSLocalizedString(@"kELDashboardActionDevelopmentPlan", nil),
                                                             @"color": kELDevPlanColor,
                                                             @"icon": fa_bar_chart_o,
                                                             @"segue": kELDashboardActionTypeDevPlan}];
    shortcutView.delegate = self;
    shortcutView.frame = self.devPlanView.bounds;
    
    [self.devPlanView addSubview:shortcutView];
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": NSLocalizedString(@"kELDashboardActionInstantFeedback", nil),
                                                             @"color": kELFeedbackColor,
                                                             @"icon": fa_paper_plane_o,
                                                             @"segue": kELDashboardActionTypeFeedback}];
    shortcutView.delegate = self;
    shortcutView.frame = self.feedbackView.bounds;
    
    [self.feedbackView addSubview:shortcutView];
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": NSLocalizedString(@"kELDashboardActionLynxMeasurement", nil),
                                                             @"color": kELLynxColor,
                                                             @"icon": fa_edit,
                                                             @"segue": kELDashboardActionTypeLynx}];
    shortcutView.delegate = self;
    shortcutView.frame = self.surveyView.bounds;
    
    [self.surveyView addSubview:shortcutView];
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": NSLocalizedString(@"kELDashboardActionTeam", nil),
                                                             @"color": kELTeamColor,
                                                             @"icon": fa_edit,
                                                             @"segue": kELDashboardActionTypeTeam}];
    shortcutView.delegate = self;
    shortcutView.frame = self.surveyView.bounds;
    
    [self.teamView addSubview:shortcutView];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"title": NSLocalizedString(@"kELDashboardActionAnswer", nil),
                                                         @"count": contents[0],
                                                         @"segue": kELDashboardActionTypeAnswer}];
    actionView.delegate = self;
    actionView.frame = self.answerActionView.bounds;
    
    [self.answerActionView addSubview:actionView];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"title": NSLocalizedString(@"kELDashboardActionResults", nil),
                                                         @"count": contents[1],
                                                         @"segue": kELDashboardActionTypeReport}];
    actionView.delegate = self;
    actionView.frame = self.answerActionView.bounds;
    
    [self.resultsActionView addSubview:actionView];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"title": NSLocalizedString(@"kELDashboardActionInvite", nil),
                                                         @"count": contents[2],
                                                         @"segue": kELDashboardActionTypeInvite}];
    actionView.delegate = self;
    actionView.frame = self.answerActionView.bounds;
    
    [self.inviteActionView addSubview:actionView];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"title": NSLocalizedString(@"kELDashboardActionCreate", nil),
                                                         @"count": contents[3],
                                                         @"segue": kELDashboardActionTypeCreate}];
    actionView.delegate = self;
    actionView.frame = self.answerActionView.bounds;
    
    [self.createActionView addSubview:actionView];
}

- (void)viewTapToPerformControllerPushWithIdentifier:(NSString *)identifier {
    UIAlertController *controller;
    __weak typeof(self) weakSelf = self;
    UIAlertAction *createDevPlanAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"kELDevelopmentPlanTitle", nil)
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    [weakSelf.delegate viewTapToPerformControllerPushWithIdentifier:kELDashboardActionTypeCreateDevPlan];
                                                                }];
    UIAlertAction *createFeedbackAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"kELInstantFeedbackTitle", nil)
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     [weakSelf.delegate viewTapToPerformControllerPushWithIdentifier:kELDashboardActionTypeCreateFeedback];
                                                                 }];
    
    if (![identifier isEqualToString:kELDashboardActionTypeCreate]) {
        [self.delegate viewTapToPerformControllerPushWithIdentifier:identifier];
        
        return;
    }
    
    controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"kELDashboardCreateNew", nil)
                                                     message:@""
                                              preferredStyle:UIAlertControllerStyleAlert];
    
    [controller addAction:createDevPlanAction];
    [controller addAction:createFeedbackAction];
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELCancelButton", nil)
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
    
    [self.controller presentViewController:controller
                                  animated:YES
                                completion:nil];
}

@end
