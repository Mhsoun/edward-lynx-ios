//
//  ELReportFreeTextTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 14/02/2018.
//  Copyright © 2018 Ingenuity Global Consulting. All rights reserved.
//

#import "ELReportFreeTextTableViewCell.h"

@implementation ELReportFreeTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bulletImageView.image = [FontAwesome imageWithIcon:fa_circle
                                                  iconColor:[UIColor whiteColor]
                                                   iconSize:5
                                                  imageSize:CGSizeMake(5, 5)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
