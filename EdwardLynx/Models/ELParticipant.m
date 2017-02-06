//
//  ELParticipant.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 09/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELParticipant.h"

@implementation ELParticipant

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id"}];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    return [propertyName isEqualToString:@"isSelected"] || [propertyName isEqualToString:@"isAddedByEmail"];
}

- (NSDictionary *)addedByEmailDictionary {
    return @{@"name": self.name,
             @"email": self.email};
}

- (NSDictionary *)apiPostDictionary {
    return @{@"id": @(self.objectId)};
}

@end
