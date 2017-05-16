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
    self.hasLoadedApplication = NO;
    self.searchText = @"";
    self.mSurveyFormDict = [[NSMutableDictionary alloc] init];
    self.validationDict = @{@"com.REValidation.presence": @"%@ can't be blank.",
                            @"com.REValidation.email": @"%@ is not a valid email."};
    
    self.apiDateFormatter = [[NSDateFormatter alloc] init];
    self.printDateFormatter = [[NSDateFormatter alloc] init];
    self.apiDateFormatter.dateFormat = kELAPIDateFormat;
    self.apiDateFormatter.timeZone = [NSTimeZone systemTimeZone];
    self.apiDateFormatter.locale = [NSLocale systemLocale];
    
    self.loadingAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"kELProcessingLabel", nil)
                                                            message:nil
                                                     preferredStyle:UIAlertControllerStyleAlert];
    self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    self.printDateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    return self;
}

@end
