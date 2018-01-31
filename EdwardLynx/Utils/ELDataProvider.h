//
//  ELDataProvider.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 19/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

@interface ELDataProvider<__covariant ObjectType> : NSObject

/**
 A custom initializer method for ELDataProvider for tables with only one(1) section.

 @param dataArray List of items.
 @return ELDataProvider instance.
 */
- (instancetype)initWithDataArray:(__kindof NSArray *)dataArray;

/**
 A custom initializer method for ELDataProvider for tables with more than one section.

 @param dataArray List of items.
 @param sections Number of table view sections.
 @return ELDataProvider instance.
 */
- (instancetype)initWithDataArray:(__kindof NSArray *)dataArray sections:(NSInteger)sections;

/**
 @return Number of data set items.
 */
- (NSInteger)numberOfRows;
/**
 @return Number of data set sections.
 */
- (NSInteger)numberOfSections;
/**
 Returns an ObjectType for a given index path row.

 @param indexPath Selected index of table.
 @return ObjectType instance.
 */
- (ObjectType)rowObjectAtIndexPath:(NSIndexPath *)indexPath;
/**
 Returns an ObjectType for a given index path section.

 @param indexPath Selected index of table.
 @return ObjectType instance.
 */
- (ObjectType)sectionObjectAtIndexPath:(NSIndexPath *)indexPath;
/**
 Updates current object at selected index path with another.

 @param object New object to replace the old.
 @param indexPath Location of object to replace.
 */
- (void)updateObject:(ObjectType)object atIndexPath:(NSIndexPath *)indexPath;

@end
