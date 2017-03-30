//
//  ELReportsViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <XLPagerTabStrip-AnthonyMDev/XLBarPagerTabStripViewController.h>

#import "ELBasePageChildViewController.h"

@class ELInstantFeedback;

@interface ELReportsViewController : ELBasePageChildViewController<UISearchBarDelegate, ELListViewControllerDelegate, XLPagerTabStripChildItem>

@end
