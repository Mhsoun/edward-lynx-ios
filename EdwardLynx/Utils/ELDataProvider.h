//
//  ELDataProvider.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 19/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

@interface ELDataProvider<__covariant ObjectType> : NSObject

- (instancetype)initWithDataArray:(__kindof NSArray *)dataArray;
- (instancetype)initWithDataArray:(__kindof NSArray *)dataArray sections:(NSInteger)sections;
- (NSInteger)numberOfRows;
- (NSInteger)numberOfSections;
- (ObjectType)rowObjectAtIndexPath:(NSIndexPath *)indexPath;
- (ObjectType)sectionObjectAtIndexPath:(NSIndexPath *)indexPath;
- (void)updateObject:(ObjectType)object atIndexPath:(NSIndexPath *)indexPath;

@end
