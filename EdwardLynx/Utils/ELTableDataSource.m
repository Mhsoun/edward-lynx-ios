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

- (instancetype)initWithTableView:(UITableView *)tableView dataProvider:(ELDataProvider *)dataProvider cellIdentifier:(NSString *)cellIdentifier {
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

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataProvider numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataProvider numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __kindof UITableViewCell<ELConfigurableCellDelegate> *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    // Configure cell content
    [cell configure:[self.dataProvider objectAtIndexPath:indexPath] atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __kindof UITableViewCell<ELRowHandlerDelegate> *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    [cell handleObject:[self.dataProvider objectAtIndexPath:indexPath] selectionActionAtIndexPath:indexPath];
}

#pragma mark - Protocol Methods (DZNEmptyDataSet)

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = self.emptyText;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18],
                                 NSForegroundColorAttributeName: [[RNThemeManager sharedManager] colorForKey:kELVioletColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = self.emptyDescription;
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end