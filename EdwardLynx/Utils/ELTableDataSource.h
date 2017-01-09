//
//  ELTableDataSource.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 19/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#import "ELDataProvider.h"

@interface ELTableDataSource : NSObject<UITableViewDataSource, UITableViewDelegate,
                                        DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

- (instancetype)initWithTableView:(UITableView *)tableView
                     dataProvider:(ELDataProvider *)dataProvider
                   cellIdentifier:(NSString *)cellIdentifier;
- (void)dataSetEmptyText:(NSString *)text description:(NSString *)description;
- (void)updateTableViewData:(__kindof NSArray *)dataArray;

@end
