//
//  ELSurveysViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"
#import "ELListViewController.h"
#import "ELSurvey.h"

#import <DYSlideView/DYSlideView.h>

@interface ELSurveysViewController : ELBaseViewController<ELListViewControllerDelegate, DYSlideViewDelegate>

@property (strong, nonatomic) ELSurvey *selectedSurvey;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet DYSlideView *slideView;

@end
