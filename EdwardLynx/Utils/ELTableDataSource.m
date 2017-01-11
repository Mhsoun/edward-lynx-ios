//
//  ELTableDataSource.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 19/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELTableDataSource.h"

@interface ELTableDataSource ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ELDataProvider *dataProvider;
@property (nonatomic, strong) NSString *cellIdentifier,
                                       *emptyText,
                                       *emptyDescription;

@end

@implementation ELTableDataSource

#pragma mark - Lifecycle

- (instancetype)initWithTableView:(UITableView *)tableView
                     dataProvider:(ELDataProvider *)dataProvider
                   cellIdentifier:(NSString *)cellIdentifier {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _cellIdentifier = cellIdentifier;
    _dataProvider = dataProvider;
    _tableView = tableView;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.emptyDataSetSource = self;
    
    _emptyDescription = @"";
    _emptyText = @"Data set is empty";
    
    return self;
}

#pragma mark - Public Methods

- (void)dataSetEmptyText:(NSString *)text description:(NSString *)description {
    self.emptyText = text.length == 0 ? self.emptyText : text;
    self.emptyDescription = description.length == 0 ? self.emptyDescription : description;
}

- (void)updateTableViewData:(__kindof NSArray *)dataArray {
    self.dataProvider = [[ELDataProvider alloc] initWithDataArray:dataArray];
    
    [self.tableView reloadData];
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataProvider numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataProvider numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __kindof UITableViewCell<ELConfigurableCellDelegate> *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    [cell configure:[self.dataProvider objectAtIndexPath:indexPath] atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __kindof UITableViewCell<ELRowHandlerDelegate> *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell handleObject:[self.dataProvider objectAtIndexPath:indexPath] selectionActionAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    __kindof UITableViewCell<ELRowHandlerDelegate> *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell handleObject:[self.dataProvider objectAtIndexPath:indexPath] deselectionActionAtIndexPath:indexPath];
}

#pragma mark - Protocol Methods (DZNEmptyDataSet)

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = self.emptyText;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:18],
                                 NSForegroundColorAttributeName: [[RNThemeManager sharedManager] colorForKey:kELWhiteColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attributes;
    NSMutableParagraphStyle *paragraph;
    NSString *text = self.emptyDescription;
    
    paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;    
    attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:14],
                   NSForegroundColorAttributeName: [[RNThemeManager sharedManager] colorForKey:kELWhiteColor],
                   NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
