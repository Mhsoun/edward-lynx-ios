//
//  NSString+HTML.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HTML)

- (NSString *)htmlString;
- (NSString *)htmlStringWithOptions:(NSDictionary *)options;

@end
