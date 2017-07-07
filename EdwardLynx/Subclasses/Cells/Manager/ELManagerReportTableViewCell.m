//
//  ELManagerReportTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/07/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELManagerReportTableViewCell.h"

@interface ELManagerReportTableViewCell ()

@property (nonatomic, strong) NSDictionary *detailDict;

@end

@implementation ELManagerReportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.downloadButton setTintColor:ThemeColor(kELOrangeColor)];
    [self.downloadButton setImage:[FontAwesome imageWithIcon:fa_envelope
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
    self.detailDict = (NSDictionary *)object;
    self.nameLabel.text = self.detailDict[@"name"];
}

- (IBAction)onDownloadButtonClick:(id)sender {
    NSDictionary *emailDict = @{@"title": self.detailDict[@"name"],
                                @"body": self.detailDict[@"url"],
                                @"recipients": @[AppSingleton.user.email]};
    
    [NotificationCenter postNotificationName:kELManagerReportEmailNotification
                                      object:nil
                                    userInfo:emailDict];
}

@end
