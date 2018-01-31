//
//  ELAverage.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAverage.h"

@implementation ELAverage

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id",
                                                                  @"value": @"average"}];
}

@end

@implementation ELAverageIndex

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id",
                                                                  @"value": @"average",
                                                                  @"color": @"role_style"}];
}

- (void)setColorWithNSString:(NSString *)colorKey {
    if ([colorKey isEqualToString:@"otherColor"]) {
        self.color = ThemeColor(kELOtherColor);
    } else if ([colorKey isEqualToString:@"selfColor"]) {
        self.color = ThemeColor(kELLynxColor);
    } else {
        self.color = ThemeColor(kELRedColor);
    }
}

@end
