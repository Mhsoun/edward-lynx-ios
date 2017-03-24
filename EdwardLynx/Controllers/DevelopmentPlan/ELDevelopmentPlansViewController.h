//
//  ELDevelopmentPlansViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <XLPagerTabStrip-AnthonyMDev/XLBarPagerTabStripViewController.h>

#import "ELBaseViewController.h"

@interface ELDevelopmentPlansViewController : ELBaseViewController<UISearchBarDelegate, ELListViewControllerDelegate, XLPagerTabStripChildItem>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
