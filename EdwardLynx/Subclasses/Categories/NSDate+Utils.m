//
//  NSDate+Utils.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 13/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

- (NSDate *)toLocalTime {
    NSInteger seconds = [[NSTimeZone localTimeZone] secondsFromGMTForDate:self];
    
    return [NSDate dateWithTimeInterval:seconds sinceDate:self];
}

- (NSDate *)toGlobalTime {
    NSInteger seconds = -[[NSTimeZone localTimeZone] secondsFromGMTForDate:self];
    
    return [NSDate dateWithTimeInterval:seconds sinceDate:self];
}

@end
