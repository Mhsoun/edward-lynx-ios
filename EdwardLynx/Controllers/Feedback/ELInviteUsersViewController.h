//
//  ELInviteUsersViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"
#import "ELDataProvider.h"
#import "ELFeedbackViewManager.h"
#import "ELParticipant.h"
#import "ELTableDataSource.h"

@interface ELInviteUsersViewController : ELBaseViewController<ELAPIResponseDelegate>

@property (strong, nonatomic) NSDictionary *instantFeedbackDict;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *evaluationLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)onDoneButtonClick:(id)sender;

@end
