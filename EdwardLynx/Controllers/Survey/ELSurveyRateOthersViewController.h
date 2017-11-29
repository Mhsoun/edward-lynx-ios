//
//  ELSurveyRateOthersViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 24/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#import "ELBaseDetailViewController.h"

@class ELSurvey;

@interface ELSurveyRateOthersViewController : ELBaseDetailViewController<UITableViewDataSource, UITableViewDelegate, ELAPIPostResponseDelegate, ELAPIResponseDelegate, ELDropdownDelegate, DZNEmptyDataSetSource>

@property (strong, nonatomic) ELSurvey *survey;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameErrorLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *emailErrorLabel;
@property (weak, nonatomic) IBOutlet UIView *dropdownView;
- (IBAction)onAddUserButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
- (IBAction)onInviteButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end
