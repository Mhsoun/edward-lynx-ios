//
//  ELManagerUsersViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 23/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"
#import "ELSearchBar.h"

@interface ELManagerUsersViewController : ELBaseViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, ELAPIResponseDelegate, DZNEmptyDataSetSource>

@property (weak, nonatomic) IBOutlet ELSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *noOfPeopleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)onSelectAllButtonClick:(id)sender;
- (IBAction)onSubmitButtonClick:(id)sender;

@end
