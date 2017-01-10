//
//  ELAppSingleton.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 22/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAppSingleton.h"

@implementation ELAppSingleton

#pragma mark - Singleton Methods

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.user = nil;
    self.participants = nil;
    
    return self;
}

@end
