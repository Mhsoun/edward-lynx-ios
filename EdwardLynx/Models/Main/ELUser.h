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

- (BOOL)isAdmin;
- (NSSet *)permissionsByRole;

@end
