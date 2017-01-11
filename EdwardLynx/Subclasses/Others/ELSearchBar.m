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
    UIFont *font;
    UITextField *searchTextField;
    id barButtonAppearanceInSearchBar;
    
    self.tintColor = [[RNThemeManager sharedManager] colorForKey:kELVioletColor];
    
    // Text Field
    font = [UIFont fontWithName:@"Lato-Regular" size:16];
    searchTextField = [self valueForKey:@"_searchField"];

    [searchTextField setFont:font];
    [searchTextField setTextColor:[UIColor whiteColor]];
    [searchTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [searchTextField setMinimumFontSize:12];
    [searchTextField setBounds:CGRectMake(0, 0, CGRectGetWidth(searchTextField.frame), 40)];
    
    // Cancel Button
    barButtonAppearanceInSearchBar = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]];
    
    [barButtonAppearanceInSearchBar setTitle:@"Cancel"];
    [barButtonAppearanceInSearchBar setTitleTextAttributes:@{NSFontAttributeName: font,
                                                             NSForegroundColorAttributeName: [UIColor whiteColor]}
                                                  forState:UIControlStateNormal];
}

@end
