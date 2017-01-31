//
//  ELGoal.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ELGoal : JSONModel

@property (nonatomic) NSString *name;
@property (nonatomic) NSString<Optional> *shortDescription;
@property (nonatomic) NSDate *dueDate;

@end
