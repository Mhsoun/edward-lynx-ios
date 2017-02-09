//
//  AppDelegate.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 29/11/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Firebase/Firebase.h>
#import <FirebaseMessaging/FirebaseMessaging.h>
#import <UserNotifications/UserNotifications.h>

#import "ELUsersAPIClient.h"

@class ELBaseDetailViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary *userInfo;
@property (strong, nonatomic) __kindof UIViewController *notificationRootViewController;
@property (strong, readonly) NSPersistentContainer *persistentContainer;

- (void)assignNewRootViewController:(__kindof UIViewController *)controller;
- (void)displayViewControllerByNotification:(NSDictionary *)userInfo;
- (void)registerDeviceToFirebaseAndAPI;
- (void)registerForRemoteNotifications;
- (void)saveContext;
- (__kindof UIViewController *)visibleViewController:(UIViewController *)rootViewController;

@end

