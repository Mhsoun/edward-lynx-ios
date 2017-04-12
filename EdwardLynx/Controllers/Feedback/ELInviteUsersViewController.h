//
//  ELInviteUsersViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"

@class ELInstantFeedback;

@interface ELInviteUsersViewController : ELBaseViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, ELAPIPostResponseDelegate>

@property (nonatomic) kELInviteUsers inviteType;

@property (strong, nonatomic) ELInstantFeedback *instantFeedback;
@property (strong, nonatomic) NSDictionary *instantFeedbackDict;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *noOfPeopleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailButtonHeightConstraint;
- (IBAction)onSelectAllButtonClick:(id)sender;
- (IBAction)onInviteButtonClick:(id)sender;
- (IBAction)onInviteByEmailButtonClick:(id)sender;

@end
