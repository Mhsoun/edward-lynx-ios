//
//  ELTableDataSource.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 19/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@class ELDataProvider;

@interface ELTableDataSource : NSObject<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/**
 A custom initializer method for ELTableViewDataSource.

 @param tableView The table view to be manipulated.
 @param dataProvider Where the data will be taken from.
 @param cellIdentifier Identifier of the cell to be used for displaying rows.
 @return ELTableViewDataSource instance.
 */
- (instancetype)initWithTableView:(UITableView *)tableView
                     dataProvider:(ELDataProvider *)dataProvider
                   cellIdentifier:(NSString *)cellIdentifier;
/**
 Configures table view to display text and description when dataset is empty.

 @param text Header text to be displayed.
 @param description A more detailed information to be displayed.
 */
- (void)dataSetEmptyText:(NSString *)text description:(NSString *)description;

/**
 Reload table view with new dataset.

 @param dataArray The new dataset to be fed to the table view.
 */
- (void)updateTableViewData:(__kindof NSArray *)dataArray;

@end
