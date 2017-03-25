//
//  ELReportTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 23/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELReportTableViewCell.h"
#import "ELInstantFeedback.h"

@implementation ELReportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Protocol Methods

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    ELInstantFeedback *instantFeedback = (ELInstantFeedback *)object;
        
    self.reportLabel.text = instantFeedback.question.text;
}

- (void)handleObject:(id)object selectionActionAtIndexPath:(NSIndexPath *)indexPath {
    //
}

@end
