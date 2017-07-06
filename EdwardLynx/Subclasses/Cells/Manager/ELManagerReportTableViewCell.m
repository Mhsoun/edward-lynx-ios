//
//  ELManagerReportTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/07/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELManagerReportTableViewCell.h"

@implementation ELManagerReportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.downloadButton setTintColor:ThemeColor(kELOrangeColor)];
    [self.downloadButton setImage:[FontAwesome imageWithIcon:fa_download
                                                   iconColor:ThemeColor(kELOrangeColor)
                                                    iconSize:15
                                                   imageSize:CGSizeMake(15, 15)]
                         forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *detailDict = (NSDictionary *)object;
    
    self.nameLabel.text = detailDict[@"name"];
}

- (IBAction)onDownloadButtonClick:(id)sender {
    
}

@end
