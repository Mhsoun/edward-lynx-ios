//
//  AppDelegate.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 29/11/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSString *firebaseToken;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Setup Fabric
    [ELUtils setupFabric];
    
    // Setup Firebase and Push Notifications
    [self setupFirebase];
    [self registerForRemoteNotifications];
    
    // Setup IQKeyboardManager
    [ELUtils setupIQKeyboardManager];
    
    // Setup global UI additions
    [ELUtils setupGlobalUIChanges];
    
    // Check if user is already authenticated to the app
    if ([ELUtils getUserDefaultsCustomObjectForKey:kELAuthInstanceUserDefaultsKey]) {
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"LeftMenu" bundle:nil]
                                          instantiateInitialViewController];
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    if (userInfo && [userInfo objectForKey:@"collapse_key"]) {
        return;
    }
    
    // TODO Process notification
    
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (userInfo && [userInfo objectForKey:@"collapse_key"]) {
        return;
    }
    
    // TODO Process notification
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    const char *data = [deviceToken bytes];
    NSMutableString *token = [NSMutableString string];
    
    for (NSUInteger i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    
    // Store Device token to singleton
    [ELAppSingleton sharedInstance].deviceToken = [token copy];
    
    // Register Device token to Firebase
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken
                                        type:FIRInstanceIDAPNSTokenTypeUnknown];
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
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
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
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark - Public Methods

- (UIViewController *)visibleViewController:(UIViewController *)rootViewController {
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
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"AppDelegate: Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"AppDelegate: Connected to FCM.");
        }
    }];
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
            if (!error) {
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
