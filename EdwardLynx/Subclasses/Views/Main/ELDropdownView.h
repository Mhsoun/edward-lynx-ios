//
//  ELDropdownView.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ELBaseViewController.h"

@interface ELDropdownView : UIView<ELListPopupDelegate>

@property (nonatomic) BOOL enabled, hasSelection;
@property (nonatomic, weak) id<ELDropdownDelegate> delegate;

@property (nonatomic, strong) __kindof ELBaseViewController *baseController;

- (instancetype)initWithItems:(NSMutableArray *)items
               baseController:(__kindof ELBaseViewController *)controller
             defaultSelection:(NSString *)defaultSelection;

- (NSString *)currentItem;
- (void)reset;
- (void)setDefaultValue:(NSString *)value;

@end
