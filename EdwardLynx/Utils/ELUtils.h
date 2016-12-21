//
//  ELUtils.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <Crashlytics/Crashlytics.h>
#import <Fabric/Fabric.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

#import "ELUsersAPIClient.h"

@interface ELTextFieldGroup : NSObject

- (instancetype)initWithField:(__kindof UITextField *)textField
                         icon:(UIImageView *)icon
                   errorLabel:(UILabel *)errorLabel;

- (NSString *)textValue;
- (void)toggleValidationIndicatorsBasedOnErrors:(NSArray *)errors;

@end

@interface ELUtils : NSObject

+ (id)getUserDefaultValueForKey:(NSString *)key;
+ (void)processReauthenticationWithCompletion:(void (^)())completion;
+ (void)setUserDefaultValue:(id)value forKey:(NSString *)key;
+ (void)storeAuthenticationDetails:(NSDictionary *)authDict;

+ (void)fabricForceCrash;
+ (void)fabricLogUserInformation:(NSDictionary *)infoDict;

+ (void)setupFabric;
+ (void)setupGlobalUIChanges;
+ (void)setupIQKeyboardManager;

@end
