//
//  ELAccountsViewManager.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 13/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

@interface ELAccountsViewManager : NSObject

@property (nonatomic, weak) id<ELAPIResponseDelegate> delegate;

- (void)processProfileUpdate;
- (void)processAuthentication;
- (void)processChangePassword;
- (void)processPasswordRecovery;
- (BOOL)validateLoginFormValues:(NSDictionary *)formDict;
- (BOOL)validateRecoverFormValues:(NSDictionary *)formDict;
- (BOOL)validateProfileUpdateFormValues:(NSDictionary *)formDict;
- (BOOL)validateChangePasswordFormValues:(NSDictionary *)formDict;

@end
