//
//  ELEmailValidator.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 10/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELEmailValidator.h"

@implementation ELEmailValidator

+ (NSString *)name {
    return @"email";
}

+ (NSError *)validateObject:(NSString *)object
               variableName:(NSString *)name
                 parameters:(NSDictionary *)parameters {
    NSError *error;
    NSString *expression;
    NSRegularExpression *regex;
    NSTextCheckingResult *match;
    NSString *string = object ? object : @"";
    
    if (string.length == 0) {
        return nil;
    }
    
    error = nil;
    expression = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,63}";
    regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                      options:NSRegularExpressionCaseInsensitive
                                                        error:&error];
    match = [regex firstMatchInString:string
                              options:0
                                range:NSMakeRange(0, string.length)];
    
    if (!match) {
        return [NSError re_validationErrorForDomain:@"com.REValidation.email", name];
    }
    
    return nil;
}

@end
