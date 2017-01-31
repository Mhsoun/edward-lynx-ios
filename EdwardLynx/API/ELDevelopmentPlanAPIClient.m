//
//  ELDevelopmentPlanAPIClient.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDevelopmentPlanAPIClient.h"

@implementation ELDevelopmentPlanAPIClient

- (void)currentUserDevelopmentPlansWithCompletion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion {
    NSString *endpoint = [NSString stringWithFormat:kELAPIDevelopmentPlansEndpoint, kELAPIVersionNamespace];
    NSMutableURLRequest *request = [self requestFor:endpoint method:kELAPIGetHTTPMethod];
    
    [self performAuthenticatedTask:YES
                       withRequest:request
                        completion:completion];
}

@end
