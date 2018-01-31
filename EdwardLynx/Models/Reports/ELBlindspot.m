//
//  ELBlindspot.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBlindspot.h"

@implementation ELBlindspot

@synthesize selfPercentage = _selfPercentage;
@synthesize othersPercentage = _othersPercentage;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id",
                                                                  @"selfPercentage": @"self",
                                                                  @"othersPercentage": @"others"}];
}

- (double)selfPercentage {
    return _selfPercentage > 1.0 ? _selfPercentage / 100.0 : _selfPercentage;
}

- (double)othersPercentage {
    return _othersPercentage > 1.0 ? _othersPercentage / 100.0 : _othersPercentage;
}

@end
