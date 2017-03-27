//
//  ELListViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 23/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIViewController+CWPopup.h>

#import "ELBaseViewController.h"

@interface ELListViewController : ELBaseViewController<UITableViewDelegate, ELAPIResponseDelegate, ELListPopupDelegate>

@property (nonatomic) kELListType listType;
@property (nonatomic) kELListFilter listFilter;

@property (strong, nonatomic) id<ELListViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
- (IBAction)onAddButtonClick:(id)sender;

@end
