//
//  ELNotification.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 09/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELNotification.h"

@implementation ELNotification

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _title = dict[@"aps"][@"alert"][@"title"];
    _body = dict[@"aps"][@"alert"][@"body"];
    _type = dict[@"type"];
    _objectId = [dict[@"id"] intValue];
    
    return self;
}

@end
