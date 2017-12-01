//
//  ELParticipant.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 09/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ELModel.h"

@interface ELParticipant : ELModel

@property (nonatomic) BOOL isSelected;
@property (nonatomic) BOOL isAddedByEmail;
@property (nonatomic) BOOL isAlreadyInvited;
@property (nonatomic) BOOL managed;
@property (nonatomic) kELUserRole role;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;

/**
 Used for returning participant details added thru email.

 @return A dictionary formatted based on requirements.
 */
- (NSDictionary *)addedByEmailDictionary;
/**
 Used for submitting goal action to a POST request.

 @return A dictionary formatted based on its POST request.
 */
- (NSDictionary *)apiPostDictionary;
/**
 Used for submitting a user for Survey Invitation

 @return A dictionary formatted based on its request.
 */
- (NSDictionary *)othersRateDictionary;

@end
