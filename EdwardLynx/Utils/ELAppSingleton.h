//
//  ELAppSingleton.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 22/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "ELUser.h"

@interface ELAppSingleton : NSObject

@property (nonatomic) BOOL hasLoadedApplication;
@property (nonatomic) BOOL needsPageReload;
@property (nonatomic) int64_t devPlanUserId;
@property (nonatomic, strong) ELUser *user;
@property (nonatomic, strong) NSArray *categories, *participants;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSDictionary *validationDict;
@property (nonatomic, strong) NSMutableDictionary *mSurveyFormDict;
@property (nonatomic, strong) NSDateFormatter *apiDateFormatter, *printDateFormatter;
@property (nonatomic, strong) UIAlertController *loadingAlert;
@property (nonatomic, strong) AFURLSessionManager *manager;

+ (instancetype)sharedInstance;

@end
