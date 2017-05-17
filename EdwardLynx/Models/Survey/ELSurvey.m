//
//  ELSurvey.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurvey.h"

@implementation ELSurvey

@synthesize endDateString = _endDateString;
@synthesize longEndDateString = _longEndDateString;
@synthesize longStartDateString = _longStartDateString;
@synthesize searchTitle = _searchTitle;
@synthesize startDateString = _startDateString;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id",
                                                                  @"shortDescription": @"description",
                                                                  @"evaluationText": @"personsEvaluatedText",
                                                                  @"answered": @"stats.answered",
                                                                  @"invited": @"stats.invited"}];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    return [propertyName isEqualToString:@"searchTitle"];
}

- (NSString *)searchTitle {
    return self.name;
}

- (NSString<Ignore> *)endDateString {
    AppSingleton.printDateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    return [AppSingleton.printDateFormatter stringFromDate:self.endDate];
}

- (NSString<Ignore> *)longEndDateString {
    AppSingleton.printDateFormatter.dateStyle = NSDateFormatterLongStyle;
    
    return [AppSingleton.printDateFormatter stringFromDate:self.endDate];
}

- (NSString<Ignore> *)startDateString {
    AppSingleton.printDateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    return [AppSingleton.printDateFormatter stringFromDate:self.startDate];
}

- (NSString<Ignore> *)longStartDateString {
    AppSingleton.printDateFormatter.dateStyle = NSDateFormatterLongStyle;
    
    return [AppSingleton.printDateFormatter stringFromDate:self.startDate];
}

@end
