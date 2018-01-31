//
//  ELNotification.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 09/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELNotification.h"

@implementation ELNotification

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return [propertyName isEqualToString:@"badge"];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _title = dict[@"aps"][@"alert"][@"title"];
    _body = dict[@"aps"][@"alert"][@"body"];
    _type = dict[@"type"];
    
    if (dict[@"key"]) {
        _key = dict[@"key"];
    }
    
    _objectId = [dict[@"id"] intValue];
    _badge = !dict[@"badge"] ? 0 : [dict[@"badge"] intValue];
    
    return self;
}

@end
