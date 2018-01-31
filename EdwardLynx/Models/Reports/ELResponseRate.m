//
//  ELResponseRate.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELResponseRate.h"

@implementation ELResponseRate

@synthesize maxValue = _maxValue;
@synthesize values = _values;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"dataPoints": @"data"}];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    return [propertyName isEqualToString:@"maxValue"];
}

- (double)maxValue {
    NSMutableArray *mPercentages = [[NSMutableArray alloc] init];
    
    for (ELDataPointBreakdown *dataPoint in self.dataPoints) [mPercentages addObject:@(dataPoint.percentage)];
    
    return [[[mPercentages copy] valueForKeyPath:@"@max.doubleValue"] doubleValue];
}

- (NSArray<Ignore> *)values {
    NSMutableArray *mPercentages = [[NSMutableArray alloc] init];
    
    for (ELDataPointBreakdown *dataPoint in self.dataPoints) [mPercentages addObject:@(dataPoint.percentage)];
    
    return [mPercentages copy];
}

@end
