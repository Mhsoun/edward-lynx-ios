//
//  ELDashboardViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 16/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"
#import "ELStatusView.h"

@interface ELDashboardViewController : ELBaseViewController

@property (weak, nonatomic) IBOutlet ELStatusView *devPlanStatusView;
@property (weak, nonatomic) IBOutlet ELStatusView *feedbackStatusView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
