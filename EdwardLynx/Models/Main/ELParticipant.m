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
    return ([propertyName isEqualToString:@"isSelected"] ||
            [propertyName isEqualToString:@"isAddedByEmail"] ||
            [propertyName isEqualToString:@"isAlreadyInvited"]);
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return [propertyName isEqualToString:@"role"] || [propertyName isEqualToString:@"managed"];
}

- (BOOL)isEqual:(id)object {
    ELParticipant *compareObject = (ELParticipant *)object;
    
    return (self.objectId == compareObject.objectId && [self.email isEqualToString:compareObject.email]);
}

- (NSUInteger)hash {
    return [self.email hash] ^ (NSUInteger)self.objectId;
}

- (NSDictionary *)addedByEmailDictionary {
    return @{@"name": self.name, @"email": self.email};
}

- (NSDictionary *)apiPostDictionary {
    return @{@"id": @(self.objectId)};
}

- (NSDictionary *)othersRateDictionary {
    NSMutableDictionary *mDict = [[self addedByEmailDictionary] mutableCopy];
    
    [mDict setObject:@(self.role) forKey:@"role"];
    
    return [mDict copy];
}

@end
