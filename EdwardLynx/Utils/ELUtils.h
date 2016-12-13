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


@interface ELUtils : NSObject

+ (void)fabricForceCrash;
+ (void)fabricLogUserInformation:(NSDictionary *)infoDict;
+ (id)getUserDefaultValueForKey:(NSString *)key;

+ (void)setupFabric;
+ (void)setupIQKeyboardManager;

@end
