//
//  NSString+HTML.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "NSString+HTML.h"

@implementation NSString (HTML)

- (NSString *)htmlString {
    return [self htmlStringWithOptions:nil];
}

- (NSString *)htmlStringWithOptions:(NSDictionary *)options {
    NSAttributedString *attributedString;
    NSError *error = nil;
    NSDictionary *defaultOptions = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    
    attributedString = [[NSAttributedString alloc] initWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                        options:defaultOptions
                                             documentAttributes:nil
                                                          error:&error];
    
    return [[[NSMutableAttributedString alloc] initWithString:[attributedString string] attributes:options] string];
}

@end
