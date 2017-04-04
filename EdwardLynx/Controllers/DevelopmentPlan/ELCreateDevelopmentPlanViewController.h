//
//  ELCreateDevelopmentPlanViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#import "ELBaseViewController.h"

@interface ELCreateDevelopmentPlanViewController : ELBaseViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ELAPIPostResponseDelegate, ELDevelopmentPlanGoalDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameErrorLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *addGoalButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)onDoneButtonClick:(id)sender;
- (IBAction)onAddGoalButtonClick:(id)sender;

@end
