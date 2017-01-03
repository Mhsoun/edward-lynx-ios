//
//  ELDevelopmentPlan.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ELDevelopmentPlan : JSONModel

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *timestamp;
@property (nonatomic) NSString *status;

@end
