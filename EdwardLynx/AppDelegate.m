//
//  AppDelegate.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 29/11/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <Firebase/Firebase.h>
#import <FirebaseMessaging/FirebaseMessaging.h>
#import <KDNotification/KDNotification.h>
#import <KDNotification/KDToastNotification.h>

#import "AppDelegate.h"
#import "ELBaseDetailViewController.h"
#import "ELUsersAPIClient.h"

#pragma mark - Private Methods

static NSString * const kELNotificationTypeDevPlan = @"dev-plan";
static NSString * const kELNotificationTypeInstantFeedbackRequest = @"instant-feedback-request";
static NSString * const kELNotificationTypeSurvey = @"survey";

#pragma mark - Class Extension

@interface AppDelegate ()

@property (nonatomic, strong) NSString *firebaseToken;

@end

@implementation AppDelegate

#pragma mark - Delegate Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.notification = nil;
    
    // Setup Fabric
    [ELUtils setupFabric];
    
    // Setup Firebase and Push Notifications
    [self setupFirebase];
    
    // Setup IQKeyboardManager
    [ELUtils setupIQKeyboardManager];
    
    // Setup global UI additions
    [ELUtils setupGlobalUIChanges];
    
    // Check if user is already authenticated to the app
    if ([ELUtils getUserDefaultsCustomObjectForKey:kELAuthInstanceUserDefaultsKey]) {
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Authentication" bundle:nil]
                                          instantiateViewControllerWithIdentifier:@"Configuration"];
    }
    
    // Check if app is launched due to user tapping to a notification while app is closed
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        self.notification = [[ELNotification alloc] initWithDictionary:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]
                                                                 error:nil];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[FIRMessaging messaging] disconnect];
    
    DLog(@"Disconnected from FCM.");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self connectToFCM];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    const char *data = [deviceToken bytes];
    NSMutableString *token = [NSMutableString string];
    
    for (NSUInteger i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    
    // Store Device token to User Defaults
    [ELUtils setUserDefaultsValue:[token copy] key:kELDeviceTokenUserDefaultsKey];
    
    // Register Device token to Firebase
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeUnknown];
    
    [self registerDeviceToFirebaseAndAPI];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DLog(@"%@: %@", [self class], error.localizedDescription);
}

#pragma mark - Deep Linking

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    DLog(@"URL: %@", url.absoluteString);
    
    NSArray *urlParts = [url.absoluteString componentsSeparatedByString:@"/"];
    
    DLog(@"%@", urlParts);
    
    [self displayViewControllerByData:@{@"id": @81, @"type": @"instant-feedback-request"}];
    
    return YES;
}

#pragma mark - Notification Received Methods (iOS 9)

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    if (userInfo && [userInfo objectForKey:@"collapse_key"]) {
        return;
    }
    
    [self processReceivedNotification:userInfo
                       forApplication:application];
    
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (userInfo && [userInfo objectForKey:@"collapse_key"]) {
        return;
    }
    
    [self processReceivedNotification:userInfo
                       forApplication:application];
}

#pragma mark - Notification Received Methods (iOS 10)

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    // Called when a notification is delivered to a foreground app.
    [self processReceivedNotification:notification.request.content.userInfo
                       forApplication:[UIApplication sharedApplication]];
    
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    // Called to let your app know which action was selected by the user for a given notification.
    [self processReceivedNotification:response.notification.request.content.userInfo
                       forApplication:[UIApplication sharedApplication]];
    
    completionHandler();
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"EdwardLynx"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    DLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        DLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark - Public Methods

- (void)assignNewRootViewController:(__kindof UIViewController *)controller {
    self.notificationRootViewController = controller;
}

- (void)registerDeviceToFirebaseAndAPI {
    NSString *deviceToken = [ELUtils getUserDefaultsValueForKey:kELDeviceTokenUserDefaultsKey];
    NSString *deviceId = [NSString stringWithFormat:@"%@-%@-%@-%@-%lld-%@",
                          [UIDevice currentDevice].name,
                          [UIDevice currentDevice].model,
                          [UIDevice currentDevice].systemName,
                          [UIDevice currentDevice].systemVersion,
                          [ELAppSingleton sharedInstance].user.objectId,
                          deviceToken];
    
    if (!self.firebaseToken) {
        // Renew Firebase token
        [[FIRInstanceID instanceID] deleteIDWithHandler:^(NSError * _Nullable error) {
            self.firebaseToken = [FIRInstanceID instanceID].token;
            
            if (!self.firebaseToken) {
                // Call method again to retry refreshing of Firebase token
                [self registerDeviceToFirebaseAndAPI];
            } else {
                [[[ELUsersAPIClient alloc] init] registerFirebaseToken:self.firebaseToken
                                                              deviceId:deviceId
                                                        withCompletion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!error) {
                            DLog(@"Device registered for notifications.");
                        }
                    });
                }];
            }
        }];
    } else {
        [[[ELUsersAPIClient alloc] init] registerFirebaseToken:self.firebaseToken
                                                      deviceId:deviceId
                                                withCompletion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    DLog(@"Device registered for notifications.");
                }
            });
        }];
    }
}

- (void)registerForRemoteNotifications {
    if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNAuthorizationOptions authorizationOptions = (UNAuthorizationOptionSound |
                                                       UNAuthorizationOptionAlert |
                                                       UNAuthorizationOptionBadge);
        
        center.delegate = self;
        
        [center requestAuthorizationWithOptions:authorizationOptions
                              completionHandler:^(BOOL granted, NSError * _Nullable error){
            if (error) {
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    } else {  // For iOS 9 and earlier
        UIUserNotificationType allNotificationTypes = (UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert |
                                                       UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:allNotificationTypes
                                                                                 categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (void)triggerRegisterForNotifications {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        [delegate registerDeviceToFirebaseAndAPI];
    } else {
        [delegate registerForRemoteNotifications];
    }
}

- (__kindof UIViewController *)visibleViewController:(UIViewController *)rootViewController {
    UIViewController *presentedViewController;
    
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        
        return [self visibleViewController:lastViewController];
    }
    
    if ([rootViewController.presentedViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController.presentedViewController;
        UIViewController *selectedViewController = tabBarController.selectedViewController;
        
        return [self visibleViewController:selectedViewController];
    }
    
    presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    
    return [self visibleViewController:presentedViewController];
}

#pragma mark - Private Methods

- (void)connectToFCM {
    if (!self.firebaseToken && ![[FIRInstanceID instanceID] token]) {
        return;
    }
    
    // Disconnect previous FCM connection if it exists.
    [[FIRMessaging messaging] disconnect];
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            DLog(@"AppDelegate: Unable to connect to FCM. %@", error);
        } else {
            DLog(@"AppDelegate: Connected to FCM.");
        }
    }];
}

- (void)displayViewControllerByData:(id)object {
    int64_t objectId;
    NSString *identifier,
             *storyboardName,
             *type;
    __kindof ELBaseDetailViewController *controller;
    
    if ([object isKindOfClass:[ELNotification class]]) {
        objectId = [(ELNotification *)object objectId];
        type = [(ELNotification *)object type];
    } else {
        NSDictionary *objectDict = (NSDictionary *)object;
        
        objectId = [objectDict[@"id"] integerValue];
        type = objectDict[@"type"];
    }
    
    if ([type isEqualToString:kELNotificationTypeDevPlan]) {
        storyboardName = @"DevelopmentPlan";
    } else if ([type isEqualToString:kELNotificationTypeInstantFeedbackRequest]) {
        storyboardName = @"InstantFeedback";
    } else {
        storyboardName = @"Survey";
    }
    
    identifier = [NSString stringWithFormat:@"%@Details", storyboardName];
    controller = [[UIStoryboard storyboardWithName:storyboardName bundle:nil]
                  instantiateViewControllerWithIdentifier:identifier];
    controller.objectId = objectId;
    
    [self.notificationRootViewController.navigationController pushViewController:controller
                                                                        animated:YES];
}

- (void)processReceivedNotification:(NSDictionary *)userInfo forApplication:(UIApplication *)application {
    ELNotification *notification = [[ELNotification alloc] initWithDictionary:userInfo error:nil];
    
    if (application.applicationState == UIApplicationStateActive ||
        application.applicationState == UIApplicationStateInactive) {
        if (self.notification) {
            return;
        }
        
        [KDToastNotification setNotificionStyle:UIBlurEffectStyleLight];
        [KDNotification showWithText:notification.body
                            duration:3.5
                              tapped:^{
            if ([ELAppSingleton sharedInstance].hasLoadedApplication) {
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                    [self displayViewControllerByData:notification];
                });
            }
        }];
    }
}

- (void)setupFirebase {
    [FIRApp configure];
    
    if ([FIRInstanceID instanceID].token) {
        self.firebaseToken = [FIRInstanceID instanceID].token;
    }
    
    // Observer for Token refresh
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification
                                               object:nil];
}

- (void)tokenRefreshNotification:(NSNotification *)notification {
    if ([FIRInstanceID instanceID].token && !self.firebaseToken) {
        self.firebaseToken = [FIRInstanceID instanceID].token;
    }
    
    [self connectToFCM];
}

@end
