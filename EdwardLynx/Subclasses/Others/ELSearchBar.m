//
//  ELSearchBar.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 11/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSearchBar.h"

@implementation ELSearchBar

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // UI customization
    id barButtonAppearanceInSearchBar;
    CGRect rect;
    UIFont *font;
    UIButton *clearButton;
    UIView *lineView;
    UITextField *searchTextField;
    UIImageView *scopeImageView;
    UIColor *inputColor = ThemeColor(kELTextFieldInputColor);
    
    // Search Bar
    self.tintColor = inputColor;
    
    rect = self.frame;
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height - 2, rect.size.width, 2)];
    lineView.backgroundColor = ThemeColor(kELHeaderColor);
    
    [self addSubview:lineView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 2)];
    lineView.backgroundColor = ThemeColor(kELHeaderColor);
    
    [self addSubview:lineView];
    
    // Text Field
    font = [UIFont fontWithName:@"Lato-Regular" size:16];
    searchTextField = [self valueForKey:@"_searchField"];
    
    [searchTextField setFont:font];
    [searchTextField setTextColor:inputColor];
    [searchTextField setBackgroundColor:ThemeColor(kELTextFieldBGColor)];
    [searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [searchTextField setMinimumFontSize:12];
    [searchTextField setBounds:CGRectMake(0, 0, CGRectGetWidth(searchTextField.frame) - 15, 35)];
    [searchTextField setValue:inputColor forKeyPath:@"_placeholderLabel.textColor"];
    
    // Cancel Button
    barButtonAppearanceInSearchBar = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]];
    
    [barButtonAppearanceInSearchBar setTitle:@"Cancel"];
    [barButtonAppearanceInSearchBar setTitleTextAttributes:@{NSFontAttributeName:font,
                                                             NSForegroundColorAttributeName:[UIColor whiteColor]}
                                                  forState:UIControlStateNormal];
    
    // Button and Icon
    scopeImageView = (UIImageView *)searchTextField.leftView;
    scopeImageView.image = [scopeImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    scopeImageView.tintColor = inputColor;
    
    clearButton = (UIButton *)[searchTextField valueForKey:@"clearButton"];
    
    [clearButton setImage:[clearButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                 forState:UIControlStateNormal];
    [clearButton setTintColor:inputColor];
}

@end
