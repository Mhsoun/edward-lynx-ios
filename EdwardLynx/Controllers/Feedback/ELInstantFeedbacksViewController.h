//
//  ELInstantFeedbacksViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAnswerInstantFeedbackViewController.h"
#import "ELBaseViewController.h"
#import "ELInstantFeedback.h"
#import "ELDataProvider.h"
#import "ELQuestion.h"
#import "ELTableDataSource.h"

@interface ELInstantFeedbacksViewController : ELBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
