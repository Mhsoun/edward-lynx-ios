//
//  ELReportsViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"

@class ELInstantFeedback;

@interface ELReportsViewController : ELBaseViewController<UISearchBarDelegate, ELListViewControllerDelegate>

@property (strong, nonatomic) ELInstantFeedback *selectedInstantFeedback;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
