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

- (void)processCreateDevelopmentPlan:(NSDictionary *)formDict {
    [self.client createDevelopmentPlansWithParams:formDict completion:self.requestCompletionBlock];
}

- (BOOL)validateAddGoalFormValues:(NSDictionary *)formDict {
    NSString *key;
    NSArray *nameErrors,
            *dateErrors,
            *categoryErrors;
    ELFormItemGroup *formFieldGroup;
    
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
        date = [[ELAppSingleton sharedInstance].apiDateFormatter dateFromString:[formFieldGroup textValue]];
        dateErrors = [date mt_isBefore:[NSDate date]] ? @[NSLocalizedString(@"kELGoalReminderValidationMessage", nil)] :
                                                        nil;
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:dateErrors];
    }
    
    key = @"category";
    
    if (formDict[key]) {
        formFieldGroup = formDict[key];
        categoryErrors = [[formFieldGroup textValue] isEqualToString:kELNoCategorySelected] ? @[NSLocalizedString(@"kELGoalCategoryValidationMessage", nil)] :
                                                                                              nil;
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:categoryErrors];
    }
    
    return (nameErrors.count == 0 &&
            dateErrors.count == 0 &&
            categoryErrors.count == 0);
}

- (BOOL)validateDevelopmentPlanFormValues:(NSDictionary *)formDict {
    NSString *key;
    NSArray *nameErrors;
    ELFormItemGroup *formFieldGroup;
    
    key = @"name";
    
    if (formDict[key]) {
        formFieldGroup = formDict[key];
        nameErrors = [REValidation validateObject:[formFieldGroup textValue]
                                             name:NSLocalizedString(@"kELNameField", nil)
                                       validators:@[@"presence"]];
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:nameErrors];
    }
    
    return nameErrors.count == 0;
}

#pragma mark - Private Methods

- (void)setupValidators {
    [REValidation registerDefaultValidators];
    [REValidation setErrorMessages:[ELAppSingleton sharedInstance].validationDict];
}

@end
