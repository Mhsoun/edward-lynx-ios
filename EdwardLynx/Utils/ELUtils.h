//
//  ELUtils.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <Crashlytics/Crashlytics.h>
#import <Fabric/Fabric.h>
#import <Firebase/Firebase.h>
#import <FirebaseMessaging/FirebaseMessaging.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

#import "AppDelegate.h"
#import "ELUsersAPIClient.h"

@interface ELTextFieldGroup : NSObject

- (instancetype)initWithField:(__kindof UITextField *)textField
                         icon:(UIImageView *)icon
                   errorLabel:(UILabel *)errorLabel;

- (NSString *)textValue;
- (void)toggleValidationIndicatorsBasedOnErrors:(NSArray *)errors;

@end

@interface ELUtils : NSObject

+ (id)getUserDefaultsCustomObjectForKey:(NSString *)key;
+ (id)getUserDefaultsObjectForKey:(NSString *)key;
+ (id)getUserDefaultsValueForKey:(NSString *)key;
+ (void)setUserDefaultsCustomObject:(__kindof NSObject *)object key:(NSString *)key;
+ (void)setUserDefaultsObject:(__kindof NSObject *)object key:(NSString *)key;
+ (void)setUserDefaultsValue:(id)value forKey:(NSString *)key;

+ (void)processReauthenticationWithCompletion:(void (^)())completion;

+ (void)fabricForceCrash;
+ (void)fabricLogUserInformation:(NSDictionary *)infoDict;

+ (void)setupFabric;
+ (void)setupGlobalUIChanges;
+ (void)setupIQKeyboardManager;

@end
