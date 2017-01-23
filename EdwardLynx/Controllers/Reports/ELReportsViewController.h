//
//  ELReportsViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"
#import "ELInstantFeedback.h"
#import "ELListViewController.h"
#import "ELReportDetailsViewController.h"

#import <DYSlideView/DYSlideView.h>

@interface ELReportsViewController : ELBaseViewController<ELListViewControllerDelegate, DYSlideViewDelegate>

@property (strong, nonatomic) ELInstantFeedback *selectedInstantFeedback;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet DYSlideView *slideView;

@end
