//
//  ELGoalAction.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELModel.h"

@interface ELGoalAction : ELModel

@property (nonatomic) int64_t position;
@property (nonatomic) BOOL checked;
@property (nonatomic) NSString *title;

- (NSDictionary *)apiDictionary;

@end
