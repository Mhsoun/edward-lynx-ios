//
//  ELDashboardHeaderTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDashboardHeaderTableViewCell.h"
#import "ELActionView.h"
#import "ELShortcutView.h"

@interface ELDashboardHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *devPlanView;
@property (weak, nonatomic) IBOutlet UIView *feedbackView;
@property (weak, nonatomic) IBOutlet UIView *surveyView;

@property (weak, nonatomic) IBOutlet UIView *answerActionView;
@property (weak, nonatomic) IBOutlet UIView *resultsActionView;
@property (weak, nonatomic) IBOutlet UIView *inviteActionView;
@property (weak, nonatomic) IBOutlet UIView *createActionView;

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

- (void)setupHeaderContent {
    ELActionView *actionView;
    ELShortcutView *shortcutView;
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"Development Plan",
                                                             @"color": kELBlueColor,
                                                             @"icon": fa_bar_chart_o}];
//    shortcutView.delegate = self;
    shortcutView.frame = self.devPlanView.bounds;
    
    [self.devPlanView addSubview:shortcutView];
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"Instant Feedback",
                                                             @"color": kELGreenColor,
                                                             @"icon": fa_plane}];
//    shortcutView.delegate = self;
    shortcutView.frame = self.feedbackView.bounds;
    
    [self.feedbackView addSubview:shortcutView];
    
    shortcutView = [[ELShortcutView alloc] initWithDetails:@{@"title": @"Lynx Management",
                                                             @"color": kELPinkColor,
                                                             @"icon": fa_edit}];
//    shortcutView.delegate = self;
    shortcutView.frame = self.surveyView.bounds;
    
    [self.surveyView addSubview:shortcutView];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"title": @"Answer", @"count": @0}];
    actionView.frame = self.answerActionView.bounds;
    
    [self.answerActionView addSubview:actionView];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"title": @"Results", @"count": @0}];
    actionView.frame = self.answerActionView.bounds;
    
    [self.resultsActionView addSubview:actionView];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"title": @"Invite", @"count": @0}];
    actionView.frame = self.answerActionView.bounds;
    
    [self.inviteActionView addSubview:actionView];
    
    actionView = [[ELActionView alloc] initWithDetails:@{@"title": @"Create", @"count": @0}];
    actionView.delegate = self;
    actionView.frame = self.answerActionView.bounds;
    
    [self.createActionView addSubview:actionView];
}

- (void)viewTapToPerformSegueWithIdentifier:(NSString *)identifier {
    [self.delegate viewTapToPerformSegueWithIdentifier:identifier];
}

@end
