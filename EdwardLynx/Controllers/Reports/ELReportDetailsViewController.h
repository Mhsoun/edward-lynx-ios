//
//  ELReportDetailsViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"
#import "ELInstantFeedback.h"

@interface ELReportDetailsViewController : ELBaseViewController<ELAPIResponseDelegate>

@property (nonatomic, strong) ELInstantFeedback *instantFeedback;
- (IBAction)onShareButtonClick:(id)sender;

@end
