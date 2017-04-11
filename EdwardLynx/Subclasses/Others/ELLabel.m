//
//  ELLabel.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 05/04/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELLabel.h"

@implementation ELLabel

- (void)drawTextInRect:(CGRect)uiLabelRect {
    UIEdgeInsets myLabelInsets = {0, 5, 0, 5};
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(uiLabelRect, myLabelInsets)];
}

- (CGSize)intrinsicContentSize {
    CGSize intrinsicSuperViewContentSize = [super intrinsicContentSize];
    
    intrinsicSuperViewContentSize.width += 10;
    
    return intrinsicSuperViewContentSize ;
}

@end
