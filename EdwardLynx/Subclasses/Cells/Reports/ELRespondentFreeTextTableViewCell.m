//
//  ELRespondentFreeTextTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/02/2018.
//  Copyright © 2018 Ingenuity Global Consulting. All rights reserved.
//

#import "ELRespondentFreeTextTableViewCell.h"

@implementation ELRespondentFreeTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *infoDict = (NSDictionary *)object;
    
    self.responseLabel.text = infoDict[@"response"];
    self.respondentLabel.text = infoDict[@"respondent"];
}

@end
