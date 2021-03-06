//
//  ELTabPageViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 23/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <XLPagerTabStrip-AnthonyMDev/XLButtonBarPagerTabStripViewController.h>

@interface ELTabPageViewController : XLButtonBarPagerTabStripViewController<UISearchBarDelegate>

@property (nonatomic) NSInteger initialIndex;
@property (nonatomic) kELListType type;

@property (nonatomic, strong) NSArray *tabs;

@end
