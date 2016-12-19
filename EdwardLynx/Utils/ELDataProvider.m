//
//  ELDataProvider.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 19/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDataProvider.h"

#pragma mark - Class Extension

@interface ELDataProvider ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ELDataProvider

#pragma mark - Lifecycle

- (instancetype)initWithDataArray:(__kindof NSArray *)dataArray {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _dataArray = [dataArray copy];
    
    return self;
}

#pragma mark - Methods

- (NSInteger)numberOfRows {
    return [self numberOfRowsInSection:0];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    if (self.numberOfSections > 1) {
        return [self.dataArray[section] count];
    }
    
    return self.dataArray.count;
}

- (NSInteger)numberOfSections {
    return 1;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataArray[indexPath.row];
}

@end
