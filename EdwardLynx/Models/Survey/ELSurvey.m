//
//  ELSurvey.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurvey.h"

#import <MTDates/NSDate+MTDates.h>

@implementation ELSurvey

@synthesize endDateString = _endDateString;
@synthesize searchTitle = _searchTitle;
@synthesize startDateString = _startDateString;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id",
                                                                  @"shortDescription": @"description",
                                                                  @"evaluationText": @"personsEvaluatedText",
                                                                  @"answered": @"stats.answered",
                                                                  @"invited": @"stats.invited",
                                                                  @"disallowedRecipients": @"disallowed_recipients"
                                                                  }];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    return ([propertyName isEqualToString:@"searchTitle"] ||
            [propertyName isEqualToString:@"isExpired"]);
}

- (BOOL)isExpired {
    return [[NSDate date] mt_isAfter:self.endDate];
}

- (NSString *)searchTitle {
    return self.name;
}

- (NSString<Ignore> *)endDateString {
    return [AppSingleton.printDateFormatter stringFromDate:self.endDate];
}

- (NSString<Ignore> *)startDateString {
    return [AppSingleton.printDateFormatter stringFromDate:self.startDate];
}

@end
