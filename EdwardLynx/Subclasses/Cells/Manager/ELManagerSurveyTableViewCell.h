//
//  ELManagerSurveyTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/07/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ELManagerReportTableViewCell.h"

@interface ELManagerSurveyTableViewCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate, ELConfigurableCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (NSInteger)reportCount;

@end
