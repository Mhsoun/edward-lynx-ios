//
//  ELAppSingleton.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 22/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELUser.h"

@interface ELAppSingleton : NSObject

@property (nonatomic, strong) ELUser *user;
@property (nonatomic, strong) NSArray *instantFeedbacks;
@property (nonatomic, strong) NSArray *participants;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSDateFormatter *apiDateFormatter;
@property (nonatomic, strong) NSDateFormatter *printDateFormatter;

+ (instancetype)sharedInstance;

@end
