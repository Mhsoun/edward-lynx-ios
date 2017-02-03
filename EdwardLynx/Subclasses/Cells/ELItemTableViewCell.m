//
//  ELItemTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 18/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELItemTableViewCell.h"

@implementation ELItemTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Interface Builder Actions

- (IBAction)onDeleteButtonClick:(id)sender {
    [self.delegate onDeletionAtRow:self.tag];
}

@end
