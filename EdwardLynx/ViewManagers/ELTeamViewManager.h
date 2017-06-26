//
//  ELTeamViewManager.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 22/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

@interface ELTeamViewManager : NSObject

@property (nonatomic, weak) id<ELAPIResponseDelegate> delegate;
@property (nonatomic, weak) id<ELAPIPostResponseDelegate> postDelegate;

- (void)processEnableUsersForManagerDashboard:(NSDictionary *)params;
- (void)processRetrieveSharedUserDevPlans;
- (void)processRetrieveUsersWithSharedDevPlans;

@end
