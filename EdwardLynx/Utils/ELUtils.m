//
//  ELUtils.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELUtils.h"

@implementation ELUtils

+ (void)fabricForceCrash {
    [ELUtils fabricLogUserInformation:@{kELFabricUsername: @"jason",
                                        kELFabricEmail: @"jason@ingenuity.ph",
                                        kELFabricIdentifier: @"jason123"}];
    [[Crashlytics sharedInstance] crash];
}

+ (void)fabricLogUserInformation:(NSDictionary *)infoDict {
    [[Crashlytics sharedInstance] setUserName:infoDict[kELFabricUsername]];
    [[Crashlytics sharedInstance] setUserEmail:infoDict[kELFabricEmail]];
    [[Crashlytics sharedInstance] setUserIdentifier:infoDict[kELFabricIdentifier]];
}

#pragma mark - Third-party Packages Setup

+ (void)setupFabric {
    [Fabric with:@[[Crashlytics class]]];
}

@end
