//
//  ELUser.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ELUser : JSONModel

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *info;
@property (nonatomic) NSString *language;
@property (nonatomic) NSDate *registeredOn;

@end
