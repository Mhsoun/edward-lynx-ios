//
//  ELConfigurationViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"
#import "ELCategory.h"
#import "ELInstantFeedback.h"
#import "ELParticipant.h"
#import "ELQuestionsAPIClient.h"
#import "ELSurveysAPIClient.h"

@interface ELConfigurationViewController : ELBaseViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end
