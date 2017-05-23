//
//  ELAddObjectTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 18/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAddObjectTableViewCell.h"

@implementation ELAddObjectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return [self.textField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (textField.text.length == 0) {
        return YES;
    }
    
    [self.delegate onAddNewItem:textField.text];
    [self.textField setText:@""];
    
    return YES;
}

- (IBAction)onAddButtonClick:(id)sender {
    if (self.textField.text.length == 0) {
        return;
    }
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    [self.delegate onAddNewItem:self.textField.text];
    [self.textField setText:@""];
}

@end
