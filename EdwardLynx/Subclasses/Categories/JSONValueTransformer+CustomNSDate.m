//
//  JSONValueTransformer+CustomNSDate.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 13/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "JSONValueTransformer+CustomNSDate.h"

@implementation JSONValueTransformer (CustomNSDate)

- (NSDate *)NSDateFromNSString:(NSString *)string {
    return [AppSingleton.apiDateFormatter dateFromString:string];
}

- (NSString *)JSONObjectFromNSDate:(NSDate *)date {
    return [AppSingleton.apiDateFormatter stringFromDate:date];
}

@end
