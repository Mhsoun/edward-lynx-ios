//
//  ELSurveysViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <DYSlideView/DYSlideView.h>

#import "ELBaseViewController.h"
#import "ELListViewController.h"
#import "ELSurvey.h"
#import "ELSurveyDetailsViewController.h"

@interface ELSurveysViewController : ELBaseViewController<UISearchBarDelegate, ELListViewControllerDelegate, DYSlideViewDelegate>

@property (strong, nonatomic) ELSurvey *selectedSurvey;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet DYSlideView *slideView;

@end
