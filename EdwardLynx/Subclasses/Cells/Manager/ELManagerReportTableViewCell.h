//
//  ELManagerReportTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/07/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger const kELManagerReportCellHeight = 55;

@interface ELManagerReportTableViewCell : UITableViewCell<ELConfigurableCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
- (IBAction)onDownloadButtonClick:(id)sender;

@end
