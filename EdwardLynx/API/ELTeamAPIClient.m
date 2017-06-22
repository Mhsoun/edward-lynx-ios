//
//  ELTeamAPIClient.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 22/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELTeamAPIClient.h"

@implementation ELTeamAPIClient

- (void)linkedUsersDevPlans:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = Format(kELAPITeamUsersEndpoint, kELAPIVersionNamespace);
    NSMutableURLRequest *request = [self requestFor:endpoint method:kELAPIGetHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

@end
