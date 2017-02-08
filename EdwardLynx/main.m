//
//  main.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 29/11/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

static bool isRunningTests() {
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *testEnabled = environment[@"TEST_ENABLED"];
    
    return [testEnabled isEqualToString:@"YES"];
}

int main(int argc, char * argv[]) {
    @autoreleasepool {
        if (isRunningTests()) {
            return UIApplicationMain(argc, argv, nil, nil);
        }
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
