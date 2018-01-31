//
//  JSONValueTransformer+CustomNSDate.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 13/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface JSONValueTransformer (CustomNSDate)

- (NSDate *)NSDateFromNSString:(NSString *)string;
- (NSString *)JSONObjectFromNSDate:(NSDate *)date;

@end
