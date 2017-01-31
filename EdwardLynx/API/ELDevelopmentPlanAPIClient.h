//
//  ELDevelopmentPlanAPIClient.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAPIClient.h"

@interface ELDevelopmentPlanAPIClient : ELAPIClient

- (void)currentUserDevelopmentPlansWithCompletion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;

@end
