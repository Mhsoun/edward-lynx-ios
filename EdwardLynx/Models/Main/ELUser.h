//
//  ELUser.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ELModel.h"

@interface ELUser : ELModel

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *info;
@property (nonatomic) NSString *role;
@property (nonatomic) NSString *department;
@property (nonatomic) NSString *gender;
@property (nonatomic) NSString *country;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *lang;
@property (nonatomic) NSString *type;
@property (nonatomic) NSDate *registeredOn;

/**
 Determines if user is an administrator.

 @return BOOL value regarding if user is an administrator.
 */
- (BOOL)isAdmin;
/**
 Determines if user is eligible to do actions on a development plan.

 @return BOOL value regarding its eligibility.
 */
- (BOOL)isNotAdminDevPlan;
/**
 List the permissions the user currently has.

 @return A set of kELRolePermission instances based on role.
 */
- (NSSet *)permissionsByRole;

@end
