//
//  ELGoalDetailsViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"
#import "ELDevelopmentPlanViewManager.h"
#import "ELGoal.h"

@interface ELGoalDetailsViewController : ELBaseViewController

@property (nonatomic) BOOL toAddNew;

@property (strong, nonatomic) ELGoal *goal;
@property (strong, nonatomic) id<ELDevelopmentPlanGoalDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameErrorLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UISwitch *remindSwitch;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *dateErrorLabel;
@property (weak, nonatomic) IBOutlet UISwitch *categorySwitch;
@property (weak, nonatomic) IBOutlet UIView *categoryView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryViewHeightConstraint;
- (IBAction)onSwitchValueChange:(id)sender;
- (IBAction)onCategoryButtonClick:(id)sender;
- (IBAction)onAddGoalButtonClick:(id)sender;

@end
