//
//  ELDashboardViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 16/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELActionView.h"
#import "ELBaseViewController.h"
#import "ELShortcutView.h"
#import "ELStatusView.h"

@interface ELDashboardViewController : ELBaseViewController

@property (weak, nonatomic) IBOutlet ELStatusView *devPlanStatusView;
@property (weak, nonatomic) IBOutlet ELStatusView *feedbackStatusView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet ELShortcutView *createFeedbackView;
@property (weak, nonatomic) IBOutlet ELShortcutView *createDevPlanView;
@property (weak, nonatomic) IBOutlet ELShortcutView *reportsView;
@property (weak, nonatomic) IBOutlet ELShortcutView *surveysView;

@property (weak, nonatomic) IBOutlet ELActionView *feedbackActionView;
@property (weak, nonatomic) IBOutlet ELActionView *reportsActionView;
@property (weak, nonatomic) IBOutlet ELActionView *instantFeedbackActionView;

@end
