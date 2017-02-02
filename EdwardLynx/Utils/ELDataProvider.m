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

@property (nonatomic) NSInteger sections;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ELDataProvider

#pragma mark - Lifecycle

- (instancetype)initWithDataArray:(__kindof NSArray *)dataArray {
    return [self initWithDataArray:dataArray sections:1];
}

- (instancetype)initWithDataArray:(__kindof NSArray *)dataArray sections:(NSInteger)sections {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _sections = sections;
    _dataArray = dataArray;
    
    return self;
}

#pragma mark - Methods

- (NSInteger)numberOfRows {
    return self.dataArray.count;
}

- (NSInteger)numberOfSections {
    return self.sections;
}

- (id)rowObjectAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataArray[indexPath.row];
}

- (id)sectionObjectAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataArray[indexPath.section];
}

- (void)updateObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    [[self.dataArray mutableCopy] insertObject:object atIndex:indexPath.row];
}

@end
