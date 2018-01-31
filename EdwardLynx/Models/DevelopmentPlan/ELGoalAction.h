//
//  ELGoalAction.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELModel.h"

@interface ELGoalAction : ELModel

@property (nonatomic) int64_t position;
@property (nonatomic) BOOL checked;
@property (nonatomic) NSString *title;

/**
 Determines if current goal action is already added to the goal's actions.
 */
@property (nonatomic) BOOL isAlreadyAdded;
/**
 Provides the API endpoint link for current goal action (e.g. updating current goal action).
 */
@property (nonatomic) NSString<Ignore> *urlLink;

/**
 Used for returning goal action details same with its GET request payload.
 
 @return A dictionary formatted based on its GET request.
 */
- (NSDictionary *)apiGetDictionary;
/**
 Used for submitting goal action to a PATCH request.

 @return A dictionary containing details required for PATCH request.
 */
- (NSDictionary *)apiPatchDictionary;

@end
