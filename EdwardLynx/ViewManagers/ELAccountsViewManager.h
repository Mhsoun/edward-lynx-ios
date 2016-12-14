//
//  ELAccountsViewManager.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 13/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <REValidation/REValidation.h>

#import "ELUsersAPIClient.h"

@interface ELAccountsViewManager : NSObject

- (instancetype)initWithView:(UIView *)view;

- (void)processAuthentication;
- (void)processPasswordRecovery;
- (BOOL)validateLoginFormValues:(NSDictionary *)formDict;
- (BOOL)validateRecoverFormValues:(NSDictionary *)formDict;

@end
