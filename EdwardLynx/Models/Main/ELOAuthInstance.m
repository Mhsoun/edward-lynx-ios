//
//  ELOAuthInstance.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 22/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELOAuthInstance.h"

@implementation ELOAuthInstance

@synthesize authHeader = _authHeader;

+ (JSONKeyMapper *)keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

- (NSString *)authHeader {
    return Format(@"%@ %@", self.tokenType, self.accessToken);
}

- (void)setAuthHeader:(NSString<Ignore> *)authHeader {
    _authHeader = authHeader;
}

#pragma mark - NSCoder Methods

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:@(self.expiresIn) forKey:@"expiresIn"];
    [encoder encodeObject:self.tokenType forKey:@"tokenType"];
    [encoder encodeObject:self.accessToken forKey:@"accessToken"];
    [encoder encodeObject:self.refreshToken forKey:@"refreshToken"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        self.expiresIn = [[decoder decodeObjectForKey:@"expiresIn"] intValue];
        self.tokenType = [decoder decodeObjectForKey:@"tokenType"];
        self.accessToken = [decoder decodeObjectForKey:@"accessToken"];
        self.refreshToken = [decoder decodeObjectForKey:@"refreshToken"];
    }
    
    return self;
}

@end
