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
@property (strong, nonatomic) NSDictionary *emailInfoDict;
@property (strong, nonatomic) ELNotification *notification;
@property (strong, readonly) NSPersistentContainer *persistentContainer;

- (void)saveContext;
/**
 Assigns the passed controller as the root for notification controllers.

 @param controller A UINavigationController instance preferably the current controller's UINavigationController.
 */
- (void)assignRootNavController:(__kindof UINavigationController *)controller;
/**
 Check the data passed and determine the corresponding page to display.

 @param object Refers to either a ELNotification (Push Notification) or NSDictionary (Email) instance containing the necessary properties to determine type of data extracting to perform.
 */
- (void)displayViewControllerByData:(id)object;
/**
 Performs renewal of Firebase token when expired, and sends Firebase token to API for reference when sending notifications.
 */
- (void)registerDeviceToFirebaseAndAPI;
/**
 Performs prompting user to enable Push Notifications for current device. Handles both iOS 9 and later.
 */
- (void)registerForRemoteNotifications;
/**
 Retrieves the top-most controller (currently displayed) from the view hierarchy.

 @param rootViewController Refers to the current root view controller.
 @return Current controller on top of view hierarchy
 */
- (__kindof UIViewController *)visibleViewController:(UIViewController *)rootViewController;

@end
