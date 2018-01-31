//
//  ELGoalAction.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELGoalAction.h"

@implementation ELGoalAction

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id"}];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    return [propertyName isEqualToString:@"isAlreadyAdded"];
}

- (NSDictionary *)apiGetDictionary {
    return @{@"title": self.title,
             @"position": @(self.position)};
}

- (NSDictionary *)apiPatchDictionary {
    return @{@"title": self.title,
             @"checked": @(self.checked),
             @"position": @(self.position)};
}

@end
