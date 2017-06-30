//
//  ELTeamDevelopmentPlan.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELModel.h"

@interface ELTeamDevelopmentPlan : ELModel

@property (nonatomic) int position;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString<Optional> *category;

@end
