//
//  ELDevelopmentPlansViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"
#import "ELDevelopmentPlan.h"
#import "ELDevelopmentPlanDetailsViewController.h"
#import "ELListViewController.h"

@interface ELDevelopmentPlansViewController : ELBaseViewController<UISearchBarDelegate, ELListViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
