//
//  ELManagerCategoryViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"
#import "ELTeamDevelopmentPlan.h"

@interface ELManagerCategoryViewController : ELBaseViewController<UITableViewDataSource, UITableViewDelegate, ELAPIPostResponseDelegate>

@property (strong, nonatomic) NSMutableArray<ELTeamDevelopmentPlan *> *mItems;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *nameErrorLabel;
@property (weak, nonatomic) IBOutlet UIView *radioGroupView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)onAddButtonClick:(id)sender;
- (IBAction)onSubmitButtonClick:(id)sender;

@end
