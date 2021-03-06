//
//  ELDevelopmentPlanViewManager.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <REValidation/REValidation.h>

#import "ELCategory.h"
#import "ELDevelopmentPlanViewManager.h"
#import "ELDevelopmentPlanAPIClient.h"
#import "ELQuestionsAPIClient.h"

#pragma mark - Class Extension

@interface ELDevelopmentPlanViewManager  ()

@property (nonatomic) int64_t objectId;
@property (nonatomic, strong) __kindof ELModel *detailObject;
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
    
    self.requestCompletionBlock = ^(NSURLResponse *response,
                                    NSDictionary *responseDict,
                                    NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [weakSelf.postDelegate onAPIPostResponseError:error.userInfo];
                
                return;
            }
            
            [weakSelf.postDelegate onAPIPostResponseSuccess:responseDict];
        });
    };
    
    [ELUtils registerValidators];
    
    return self;
}

- (instancetype)initWithDetailObject:(__kindof ELModel *)detailObject {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _client = [[ELDevelopmentPlanAPIClient alloc] init];
    _detailObject = detailObject;
    
    __weak typeof(self) weakSelf = self;
    
    self.requestCompletionBlock = ^(NSURLResponse *response,
                                    NSDictionary *responseDict,
                                    NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [weakSelf.postDelegate onAPIPostResponseError:error.userInfo];
                
                return;
            }
            
            [weakSelf.postDelegate onAPIPostResponseSuccess:responseDict];
        });
    };
    
    [ELUtils registerValidators];
    
    return self;
}

- (instancetype)initWithObjectId:(int64_t)objectId {
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _client = [[ELDevelopmentPlanAPIClient alloc] init];
    _objectId = objectId;
    
    __weak typeof(self) weakSelf = self;
    
    self.requestCompletionBlock = ^(NSURLResponse *response,
                                    NSDictionary *responseDict,
                                    NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [weakSelf.postDelegate onAPIPostResponseError:error.userInfo];
                
                return;
            }
            
            [weakSelf.postDelegate onAPIPostResponseSuccess:responseDict];
        });
    };
    
    [ELUtils registerValidators];
    
    return self;
}

#pragma mark - Public Methods

- (void)fetchQuestionCategories {
    __weak typeof(self) weakSelf = self;
    
    [[[ELQuestionCategoriesAPIClient alloc] init] categoriesOfUserWithCompletion:^(NSURLResponse *response,
                                                                                   NSDictionary *responseDict,
                                                                                   NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *mCategories;
            
            if (error) {
                [weakSelf.delegate onAPIResponseError:error.userInfo];
                
                return;
            }
            
            mCategories = [[NSMutableArray alloc] init];
            
            for (NSDictionary *categoryDict in responseDict[@"items"]) {
                [mCategories addObject:[[ELCategory alloc] initWithDictionary:categoryDict error:nil]];
            }
            
            AppSingleton.categories = [mCategories copy];
            
            DLog(@"%@: Question categories fetch successful", [self class]);
            
            [weakSelf.delegate onAPIResponseSuccess:nil];
        });
    }];
}

- (void)processCreateDevelopmentPlan:(NSDictionary *)formDict {
    [self.client createDevelopmentPlansWithParams:formDict completion:self.requestCompletionBlock];
}

- (void)processUpdateDevelopmentPlan:(NSDictionary *)formDict {
    [self.client updateDevelopmentPlanWithId:self.detailObject ? self.detailObject.objectId : self.objectId
                                      params:formDict
                                  completion:self.requestCompletionBlock];
}

- (void)processAddDevelopmentPlanGoal:(NSDictionary *)formDict {
    NSString *link = formDict[@"link"];
    NSMutableDictionary *mFormDict = [formDict mutableCopy];
    
    [mFormDict removeObjectForKey:@"link"];
    
    [self.client addDevelopmentPlanGoalWithParams:[mFormDict copy]
                                             link:link
                                       completion:self.requestCompletionBlock];
}

- (void)processDeleteDevelopmentPlanGoalWithLink:(NSString *)link {
    [self.client deleteDevelopmentPlanGoalWithLink:link completion:self.requestCompletionBlock];
}

- (void)processUpdateDevelopmentPlanGoal:(NSDictionary *)formDict {
    NSString *link = formDict[@"link"];
    NSMutableDictionary *mFormDict = [formDict mutableCopy];
    
    [mFormDict removeObjectForKey:@"link"];
    
    [self.client updateDevelopmentPlanGoalWithParams:[mFormDict copy]
                                                link:link
                                          completion:self.requestCompletionBlock];
}

- (void)processAddDevelopmentPlanGoalAction:(NSDictionary *)formDict {
    NSString *link = formDict[@"link"];
    NSMutableDictionary *mFormDict = [formDict mutableCopy];
    
    [mFormDict removeObjectForKey:@"link"];
    
    [self.client addDevelopmentPlanGoalActionWithParams:[mFormDict copy]
                                                   link:link
                                             completion:self.requestCompletionBlock];
}

- (void)processDeleteDevelopmentPlanGoalActionWithLink:(NSString *)link {    
    [self.client deleteDevelopmentPlanGoalActionWithLink:link completion:self.requestCompletionBlock];
}

- (void)processUpdateDevelopmentPlanGoalAction:(NSDictionary *)formDict {
    NSString *link = formDict[@"link"];
    NSMutableDictionary *mFormDict = [formDict mutableCopy];
    
    [mFormDict removeObjectForKey:@"link"];
    
    [self.client updateDevelopmentPlanGoalActionWithParams:[mFormDict copy]
                                                      link:link
                                                completion:self.requestCompletionBlock];
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
//        nameErrors = [REValidation validateObject:[formFieldGroup textValue]
//                                             name:@"Name"
//                                       validators:@[@"presence"]];

        nameErrors = [[formFieldGroup textValue] length] == 0 ? @[NSLocalizedString(@"kELNameValidationMessage", nil)] : nil;
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:nameErrors];
    }
    
    key = @"date";
    
    if (formDict[key]) {
        NSDate *date;
        
        formFieldGroup = formDict[key];
        date = [AppSingleton.apiDateFormatter dateFromString:[formFieldGroup textValue]];
        dateErrors = [date mt_isBefore:[NSDate date]] ? @[NSLocalizedString(@"kELGoalDueDateValidationMessage", nil)] : nil;
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:dateErrors];
    }
    
    key = @"category";
    
    if (formDict[key]) {
        NSString *validationString = NSLocalizedString(@"kELGoalCategoryValidationMessage", nil);
        
        formFieldGroup = formDict[key];
        categoryErrors = [[formFieldGroup textValue] isEqualToString:validationString] ? @[validationString] : nil;
        
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
//        nameErrors = [REValidation validateObject:[formFieldGroup textValue]
//                                             name:NSLocalizedString(@"kELNameField", nil)
//                                       validators:@[@"presence"]];
        
        nameErrors = [[formFieldGroup textValue] length] == 0 ? @[NSLocalizedString(@"kELNameValidationMessage", nil)] : nil;
        
        [formFieldGroup toggleValidationIndicatorsBasedOnErrors:nameErrors];
    }
    
    return nameErrors.count == 0;
}

@end
