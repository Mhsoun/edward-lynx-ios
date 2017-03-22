//
//  ELDropdownView.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ELBaseViewController.h"

@interface ELDropdownView : UIView

@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL hasSelection;
@property (nonatomic, strong) id<ELDropdownDelegate> delegate;

- (instancetype)initWithItems:(NSMutableArray *)items
               baseController:(__kindof ELBaseViewController *)controller
             defaultSelection:(NSString *)defaultSelection;

@end
