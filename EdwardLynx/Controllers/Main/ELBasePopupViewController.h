//
//  ELBasePopupViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 14/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIViewController+CWPopup.h>

#import "ELBaseViewController.h"

@interface ELBasePopupViewController : ELBaseViewController

- (instancetype)initWithPreviousController:(__kindof UIViewController *)controller
                                   details:(NSDictionary *)detailsDict;

@end
