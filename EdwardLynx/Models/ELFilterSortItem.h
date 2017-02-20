//
//  ELFilterSortItem.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 14/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ELFilterSortItem : JSONModel

@property (nonatomic) BOOL selected;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *key;

@end
