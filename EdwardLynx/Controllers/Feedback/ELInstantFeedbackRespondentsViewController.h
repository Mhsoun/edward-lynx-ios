//
//  ELInstantFeedbackRespondentsViewController.h
//  EdwardLynxAppStore
//
//  Created by Jason Jon E. Carreos on 09/02/2018.
//  Copyright © 2018 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELInstantFeedbackRespondentsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ELBaseViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
