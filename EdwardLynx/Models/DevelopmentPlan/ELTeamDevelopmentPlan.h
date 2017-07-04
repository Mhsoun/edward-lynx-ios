//
//  ELTeamDevelopmentPlan.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELModel.h"

@interface ELTeamDevelopmentPlan : ELModel

@property (nonatomic) int64_t ownerId;
@property (nonatomic) int64_t position;
@property (nonatomic) BOOL checked;
@property (nonatomic) BOOL visible;
@property (nonatomic) NSString *name;

- (NSDictionary *)apiDictionary;

@end
