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

/**
 Determines if app has alread loaded all API resources on start of app.
 */
@property (nonatomic) BOOL hasLoadedApplication;
/**
 Determines if a specific page needs to be reloaded based on previous controller's action (e.g. added new development plan, etc.).
 */
@property (nonatomic) BOOL needsPageReload;
/**
 Current development plan id being viewed.
 */
@property (nonatomic) int64_t devPlanUserId;
/**
 ELUser instance of the currently logged in user.
 */
@property (nonatomic, strong) ELUser *user;
/**
 List of categories used for development plan goals.
 */
@property (nonatomic, strong) NSArray *categories;
/**
 List of participants used for inviting users.
 */
@property (nonatomic, strong) NSArray *participants;
/**
 Current search text query input in the list page.
 */
@property (nonatomic, strong) NSString *searchText;
/**
 Validation messages to be used globally.
 */
@property (nonatomic, strong) NSDictionary *validationDict;
/**
 Current survey form answers being accessed.
 */
@property (nonatomic, strong) NSMutableDictionary *mSurveyFormDict;
/**
 NSDateFormatter instance for formatting dates to conform to API date format.
 */
@property (nonatomic, strong) NSDateFormatter *apiDateFormatter;
/**
 NSDateFormatter instance for formatting dates to a more readable format.
 */
@property (nonatomic, strong) NSDateFormatter *printDateFormatter;
/**
 An alert view used to indicate an ongoing process, mostly used for API requests.
 */
@property (nonatomic, strong) UIAlertController *loadingAlert;
/**
 Manager used for API requests.
 */
@property (nonatomic, strong) AFURLSessionManager *manager;

+ (instancetype)sharedInstance;

/**
 Returns list of participants not including the currently logged in user.

 @return A list of participants.
 */
- (NSArray *)participantsWithoutUser;

@end
