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
    
    RegisterNib(self.tableView, kELCellIdentifier);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *detailDict = (NSDictionary *)object;
    
    self.nameLabel.text = detailDict[@"name"];
    self.reports = detailDict[@"reports"];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reports.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELManagerReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier
                                                                         forIndexPath:indexPath];
    
    [cell configure:self.reports[indexPath.row] atIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kELManagerReportCellHeight;
}

@end
