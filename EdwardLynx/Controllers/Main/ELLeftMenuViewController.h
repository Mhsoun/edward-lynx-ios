//
//  ELLeftMenuViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 19/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <SASlideMenu/SASlideMenuViewController.h>

#import "ELBaseViewController.h"
#import "ELDataProvider.h"
#import "ELMenuItem.h"
#import "ELTableDataSource.h"

@interface ELLeftMenuViewController : SASlideMenuViewController<UITableViewDelegate, SASlideMenuDataSource, SASlideMenuDelegate, ELBaseViewControllerDelegate>

@end
