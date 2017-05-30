//
//  ELDataPoint.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDataPoint.h"

@implementation ELDataPointBreakdown

@synthesize colorKey = _colorKey;
@synthesize title = _title;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"title": @"Title",
                                                                  @"percentage": @"Percentage",
                                                                  @"colorKey": @"role_style"}];
}

- (NSString *)colorKey {
    return [_colorKey isEqualToString:@"selfColor"] ? kELLynxColor : kELOrangeColor;
}

- (NSString *)title {
    return [_title stringByReplacingOccurrencesOfString:@"\"" withString:@""];
}

@end

@implementation ELDataPointSummary

@synthesize percentage = _percentage;
@synthesize percentage1 = _percentage1;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"question": @"Question",
                                                                  @"percentage": @"Percentage",
                                                                  @"percentage1": @"Percentage_1"}];
}

- (double)percentage {
    return _percentage > 1.0f ? _percentage / 100.0 : _percentage;
}

- (double)percentage1 {
    return _percentage1 > 1.0f ? _percentage1 / 100.0 : _percentage1;
}

@end
