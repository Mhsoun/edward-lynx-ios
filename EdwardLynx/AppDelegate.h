//
//  AppDelegate.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 29/11/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UserNotifications/UserNotifications.h>

#import "ELNotification.h"

@class ELBaseDetailViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ELNotification *notification;
@property (strong, nonatomic) __kindof UIViewController *notificationRootViewController;
@property (strong, readonly) NSPersistentContainer *persistentContainer;

- (void)assignNewRootViewController:(__kindof UIViewController *)controller;
- (void)displayViewControllerByData:(id)object;
- (void)registerDeviceToFirebaseAndAPI;
- (void)registerForRemoteNotifications;
- (void)saveContext;
- (__kindof UIViewController *)visibleViewController:(UIViewController *)rootViewController;

@end
