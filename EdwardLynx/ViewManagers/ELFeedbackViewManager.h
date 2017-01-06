//
//  ELFeedbackViewManager.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <REValidation/REValidation.h>

@interface ELFeedbackViewManager : NSObject

- (BOOL)validateCreateInstantFeedbackFormValues:(NSDictionary *)formDict;
- (BOOL)validateInstantFeedbackInviteUsersFormValues:(NSDictionary *)formDict;

@end
