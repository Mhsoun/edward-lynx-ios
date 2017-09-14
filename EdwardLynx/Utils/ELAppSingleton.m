//
//  ELAppSingleton.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 22/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAppSingleton.h"
#import "ELInstantFeedback.h"
#import "ELParticipant.h"

@implementation ELAppSingleton

@synthesize categories = _categories;

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
    NSURLSessionConfiguration *config;
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    self.devPlanUserId = -1;
    self.user = nil;
    self.participants = nil;
    self.hasLoadedApplication = NO;
    self.needsPageReload = NO;
    self.searchText = @"";
    self.mSurveyFormDict = [[NSMutableDictionary alloc] init];
    self.validationDict = @{@"com.REValidation.email": NSLocalizedString(@"kELREValidationEmailMessage", nil),
                            @"com.REValidation.presence": NSLocalizedString(@"kELREValidationPresenceMessage", nil)};
    
    self.apiDateFormatter = [[NSDateFormatter alloc] init];
    self.printDateFormatter = [[NSDateFormatter alloc] init];
    self.apiDateFormatter.dateFormat = kELAPIDateFormat;
    self.apiDateFormatter.timeZone = [NSTimeZone systemTimeZone];
    self.apiDateFormatter.locale = [NSLocale systemLocale];
    self.printDateFormatter.dateFormat = kELPrintDateFormat;
    
    self.loadingAlert = Alert(NSLocalizedString(@"kELProcessingLabel", nil), nil);
    self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    return self;
}

- (NSArray *)participantsWithoutUser {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.email != %@", self.user.email];
    
    return [self.participants filteredArrayUsingPredicate:predicate];
}

- (NSArray *)categories {
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                           ascending:YES
                                                            selector:@selector(caseInsensitiveCompare:)];
    
    _categories = [_categories sortedArrayUsingDescriptors:@[sort]];
    
    return _categories;
}

- (void)setCategories:(NSArray *)categories {
    _categories = categories;
}

@end
