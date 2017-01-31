//
//  ELDevelopmentPlanDetailViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"
#import "ELDevelopmentPlanViewManager.h"
#import "ELGoal.h"

@interface ELDevelopmentPlanDetailViewController : ELBaseViewController

@property (nonatomic) BOOL toAddNew;

@property (strong, nonatomic) ELGoal *goal;
@property (strong, nonatomic) id<ELDevelopmentPlanGoalDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameErrorLabel;
@property (weak, nonatomic) IBOutlet UISwitch *remindSwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *dateErrorLabel;
@property (weak, nonatomic) IBOutlet UISwitch *categorySwitch;
- (IBAction)onAddGoalButtonClick:(id)sender;

@end
