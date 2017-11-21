//
//  ELGoalDetailsViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#import "ELBaseViewController.h"

@class ELGoal;

@interface ELGoalDetailsViewController : ELBaseViewController<UITableViewDataSource, UITableViewDelegate, ELAPIPostResponseDelegate, ELAPIResponseDelegate, ELAddItemDelegate, ELDropdownDelegate, ELItemCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic) BOOL toAddNew;
@property (nonatomic) BOOL withAPIProcess;

@property (strong, nonatomic) NSString *requestLink;
@property (strong, nonatomic) ELGoal *goal;

@property (weak, nonatomic) id<ELDevelopmentPlanGoalDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameErrorLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *addActionButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addActionTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addActionWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparatorView;

@property (weak, nonatomic) IBOutlet UISwitch *remindSwitch;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *dateErrorLabel;

@property (weak, nonatomic) IBOutlet UISwitch *categorySwitch;
@property (weak, nonatomic) IBOutlet UIView *dropdownView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dropdownHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *addGoalButton;
- (IBAction)onSwitchValueChange:(id)sender;
- (IBAction)onAddActionButtonClick:(id)sender;
- (IBAction)onAddGoalButtonClick:(id)sender;

@end
