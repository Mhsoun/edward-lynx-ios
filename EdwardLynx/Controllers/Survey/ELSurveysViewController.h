//
//  ELSurveysViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"

@interface ELSurveysViewController : ELBaseViewController<UISearchBarDelegate, ELListViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
