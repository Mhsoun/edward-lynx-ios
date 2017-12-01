//
//  ELOAuthInstance.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 22/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ELOAuthInstance : JSONModel

@property (nonatomic) int64_t expiresIn;
@property (nonatomic) NSString *tokenType;
@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSString *refreshToken;

/**
 Formats the Authorization header value based on stored tokenType and accessToken.
 */
@property (nonatomic) NSString<Ignore> *authHeader;

@end
