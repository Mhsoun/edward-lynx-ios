//
//  ELTeamAPIClient.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 22/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAPIClient.h"

@interface ELTeamAPIClient : ELAPIClient

- (void)linkedUsersDevPlansWithParams:(NSDictionary *)params
                           completion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;

@end
