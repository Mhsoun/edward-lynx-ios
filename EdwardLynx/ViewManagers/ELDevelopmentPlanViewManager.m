//
//  ELDevelopmentPlanViewManager.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDevelopmentPlanViewManager.h"

#pragma mark - Class Extension

@interface ELDevelopmentPlanViewManager  ()

@property (nonatomic, strong) ELDevelopmentPlanAPIClient *client;
@property (nonatomic, strong) void (^requestCompletionBlock)(NSURLResponse *response, NSDictionary *responseDict, NSError *error);

@end

@implementation ELDevelopmentPlanViewManager

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _client = [[ELDevelopmentPlanAPIClient alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    self.requestCompletionBlock = ^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [weakSelf.delegate onAPIPostResponseError:error.userInfo];
                
                return;
            }
            
            [weakSelf.delegate onAPIPostResponseSuccess:responseDict];
        });
    };
    
    [self setupValidators];
    
    return self;
}

#pragma mark - Public Methods

- (BOOL)validateAddGoalFormValues:(NSDictionary *)formDict {
    NSString *key;
    NSArray *nameErrors, *dateErrors;
    ELFormItemGroup *formFieldGroup;
    NSDateFormatter *formatter;
    
    key = @"name";
    
    if (formDict[key]) {
        formFieldGroup = formDict[key];
        nameErrors = [REValidation validateObject:[formFieldGroup textValue]
                                             name:@"Name"
                                       validators:@[@"presence"]];
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:nameErrors];
    }
    
    key = @"date";
    
    if (formDict[key]) {
        NSDate *date;
        
        formFieldGroup = formDict[key];
        formatter = [ELAppSingleton sharedInstance].dateFormatter;
        formatter.dateFormat = kELAPIDateFormat;
        formatter.timeZone = [NSTimeZone systemTimeZone];
        formatter.locale = [NSLocale systemLocale];
        date = [formatter dateFromString:[formFieldGroup textValue]];
        dateErrors = [date mt_isBefore:[NSDate date]] ? @[@"Reminder date should be on or after today."] : nil;
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:dateErrors];
    }
    
    return nameErrors.count == 0 && dateErrors.count == 0;
}

- (BOOL)validateDevelopmentPlanFormValues:(NSDictionary *)formDict {
    NSString *key;
    NSArray *nameErrors;
    ELFormItemGroup *formFieldGroup;
    
    key = @"name";
    
    if (formDict[key]) {
        formFieldGroup = formDict[key];
        nameErrors = [REValidation validateObject:[formFieldGroup textValue]
                                             name:@"Name"
                                       validators:@[@"presence"]];
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:nameErrors];
    }
    
    return nameErrors.count == 0;
}

#pragma mark - Private Methods

- (void)setupValidators {
    [REValidation registerDefaultValidators];
    [REValidation registerDefaultErrorMessages];
}

@end
