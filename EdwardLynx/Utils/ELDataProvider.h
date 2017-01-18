//
//  ELDataProvider.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 19/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

@interface ELDataProvider<__covariant ObjectType> : NSObject

- (instancetype)initWithDataArray:(__kindof NSArray *)dataArray;
- (NSInteger)numberOfRows;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (NSInteger)numberOfSections;
- (ObjectType)objectAtIndexPath:(NSIndexPath *)indexPath;
- (void)updateObject:(ObjectType)object atIndexPath:(NSIndexPath *)indexPath;

@end
