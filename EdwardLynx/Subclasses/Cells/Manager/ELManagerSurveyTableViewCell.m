//
//  ELManagerSurveyTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/07/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELManagerSurveyTableViewCell.h"

#pragma mark - Private Constants

static NSString * const kELCellIdentifier = @"ManagerReportCell";

#pragma mark - Class Extension

@interface ELManagerSurveyTableViewCell ()

@property (nonatomic, strong) NSArray *reports;

@end

@implementation ELManagerSurveyTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = ThemeColor(kELSurveySeparatorColor);
    
    RegisterNib(self.tableView, kELCellIdentifier);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *detailDict = (NSDictionary *)object;
    
    self.reports = detailDict[@"reports"];
    self.nameLabel.text = detailDict[@"name"];
    
    [self.tableView reloadData];
}

- (NSInteger)reportCount {
    return self.reports.count;
}

// MARK: - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reports.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELManagerReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier
                                                                         forIndexPath:indexPath];
    
    [cell configure:self.reports[indexPath.row] atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [NotificationCenter postNotificationName:kELManagerReportDetailsNotification
                                      object:nil
                                    userInfo:self.reports[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kELManagerReportCellHeight;
}

@end
