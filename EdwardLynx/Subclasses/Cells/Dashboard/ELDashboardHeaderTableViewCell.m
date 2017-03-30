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
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"Development Plan",
                                                             @"color": kELDevPlanColor,
                                                             @"icon": fa_bar_chart_o,
                                                             @"segue": kELDashboardActionTypeDevPlan}];
    shortcutView.delegate = self;
    shortcutView.frame = self.devPlanView.bounds;
    
    [self.devPlanView addSubview:shortcutView];
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"Instant Feedback",
                                                             @"color": kELFeedbackColor,
                                                             @"icon": fa_paper_plane_o,
                                                             @"segue": kELDashboardActionTypeFeedback}];
    shortcutView.delegate = self;
    shortcutView.frame = self.feedbackView.bounds;
    
    [self.feedbackView addSubview:shortcutView];
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"Lynx Management",
                                                             @"color": kELLynxColor,
                                                             @"icon": fa_edit,
                                                             @"segue": kELDashboardActionTypeLynx}];
    shortcutView.delegate = self;
    shortcutView.frame = self.surveyView.bounds;
    
    [self.surveyView addSubview:shortcutView];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"title": @"Answer", @"count": @0}];
//    actionView.delegate = self;
    actionView.frame = self.answerActionView.bounds;
    
    [self.answerActionView addSubview:actionView];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"title": @"Results", @"count": @0}];
//    actionView.delegate = self;
    actionView.frame = self.answerActionView.bounds;
    
    [self.resultsActionView addSubview:actionView];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"title": @"Invite", @"count": @0}];
//    actionView.delegate = self;
    actionView.frame = self.answerActionView.bounds;
    
    [self.inviteActionView addSubview:actionView];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"title": @"Create",
                                                         @"count": @0,
                                                         @"segue": @"Create"}];
    actionView.delegate = self;
    actionView.frame = self.answerActionView.bounds;
    
    [self.createActionView addSubview:actionView];
}

- (void)viewTapToPerformSegueWithIdentifier:(NSString *)identifier {
    UIAlertController *controller;
    
    if (![identifier isEqualToString:@"Create"]) {
        [self.delegate viewTapToPerformSegueWithIdentifier:identifier];
        
        return;
    }
    
    controller = [UIAlertController alertControllerWithTitle:@"Create New"
                                                     message:@""
                                              preferredStyle:UIAlertControllerStyleAlert];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"Goals"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     [self.delegate viewTapToPerformSegueWithIdentifier:kELDashboardActionTypeCreateDevPlan];
                                                 }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"Instant Feedback"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                     [self.delegate viewTapToPerformSegueWithIdentifier:kELDashboardActionTypeCreateFeedback];
                                                 }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
    
    [self.controller presentViewController:controller
                                  animated:YES
                                completion:nil];
}

@end
