//
//  ELInstantFeedback.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELModel.h"
#import "ELParticipant.h"
#import "ELQuestion.h"

@protocol ELParticipant;

@interface ELInstantFeedback : ELModel

@property (nonatomic) BOOL anonymous;
@property (nonatomic) BOOL closed;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSString *lang;
@property (nonatomic) NSString<Optional> *key;
@property (nonatomic) NSArray<Optional> *shares;
@property (nonatomic) NSArray<Optional, ELParticipant> *participants;
@property (nonatomic) ELQuestion *question;

@end
