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

- (void)setupHeaderContentForController:(__kindof ELBaseViewController *)controller {
    ELActionView *actionView;
    ELShortcutView *shortcutView;
    
    self.controller = controller;
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": NSLocalizedString(@"kELDashboardItemDevelopmentPlan", nil),
                                                             @"color": kELDevPlanColor,
                                                             @"icon": fa_bar_chart_o,
                                                             @"segue": kELDashboardActionTypeDevPlan}];
    shortcutView.delegate = self;
    shortcutView.frame = self.devPlanView.bounds;
    
    [self.devPlanView addSubview:shortcutView];
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": NSLocalizedString(@"kELDashboardItemInstantFeedback", nil),
                                                             @"color": kELFeedbackColor,
                                                             @"icon": fa_paper_plane_o,
                                                             @"segue": kELDashboardActionTypeFeedback}];
    shortcutView.delegate = self;
    shortcutView.frame = self.feedbackView.bounds;
    
    [self.feedbackView addSubview:shortcutView];
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": NSLocalizedString(@"kELDashboardItemLynxManagement", nil),
                                                             @"color": kELLynxColor,
                                                             @"icon": fa_edit,
                                                             @"segue": kELDashboardActionTypeLynx}];
    shortcutView.delegate = self;
    shortcutView.frame = self.surveyView.bounds;
    
    [self.surveyView addSubview:shortcutView];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"title": NSLocalizedString(@"kELDashboardItemAnswer", nil),
                                                         @"count": @0,
                                                         @"segue": @"Answer"}];
    actionView.delegate = self;
    actionView.frame = self.answerActionView.bounds;
    
    [self.answerActionView addSubview:actionView];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"title": NSLocalizedString(@"kELDashboardItemResults", nil),
                                                         @"count": @0,
                                                         @"segue": kELDashboardActionTypeReport}];
    actionView.delegate = self;
    actionView.frame = self.answerActionView.bounds;
    
    [self.resultsActionView addSubview:actionView];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"title": NSLocalizedString(@"kELDashboardItemInvite", nil),
                                                         @"count": @0}];
//    actionView.delegate = self;
    actionView.frame = self.answerActionView.bounds;
    
    [self.inviteActionView addSubview:actionView];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"title": NSLocalizedString(@"kELDashboardItemCreate", nil),
                                                         @"count": @0,
                                                         @"segue": @"Create"}];
    actionView.delegate = self;
    actionView.frame = self.answerActionView.bounds;
    
    [self.createActionView addSubview:actionView];
}

- (void)viewTapToPerformSegueWithIdentifier:(NSString *)identifier {
    BOOL isAnswer;
    UIAlertController *controller;
    UIAlertAction *answerFeedbackAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"kELInstantFeedbackTitle", nil)
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     [self.delegate viewTapToPerformSegueWithIdentifier:kELDashboardActionTypeFeedback];
                                                                 }];
    UIAlertAction *answerSurveyAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"kELDashboardItemSurveys", nil)
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                   [self.delegate viewTapToPerformSegueWithIdentifier:kELDashboardActionTypeLynx];
                                                               }];
    UIAlertAction *createDevPlanAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"kELDevelopmentPlanTitle", nil)
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    [self.delegate viewTapToPerformSegueWithIdentifier:kELDashboardActionTypeCreateDevPlan];
                                                                }];
    UIAlertAction *createFeedbackAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"kELInstantFeedbackTitle", nil)
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     [self.delegate viewTapToPerformSegueWithIdentifier:kELDashboardActionTypeCreateFeedback];
                                                                 }];
    
    if (![@[@"Answer", @"Create"] containsObject:identifier]) {
        [self.delegate viewTapToPerformSegueWithIdentifier:identifier];
        
        return;
    }
    
    isAnswer = [identifier isEqualToString:@"Answer"];
    controller = [UIAlertController alertControllerWithTitle:isAnswer ? NSLocalizedString(@"kELDashboardAddNew", nil) : NSLocalizedString(@"kELDashboardCreateNew", nil)
                                                     message:@""
                                              preferredStyle:UIAlertControllerStyleAlert];
    
    [controller addAction:isAnswer ? answerSurveyAction : createDevPlanAction];
    [controller addAction:isAnswer ? answerFeedbackAction : createFeedbackAction];
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELCancelButton", nil)
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
    
    [self.controller presentViewController:controller
                                  animated:YES
                                completion:nil];
}

@end
