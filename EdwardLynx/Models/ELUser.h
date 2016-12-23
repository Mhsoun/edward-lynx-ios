//
//  ELUser.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ELUser : JSONModel

@property (nonatomic) int64_t id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *info;
@property (nonatomic) NSString *lang;
@property (nonatomic) NSString *type;
@property (nonatomic) NSDate *registeredOn;

- (NSSet *)permissionsByRole;

@end
