//
//  ELInstantFeedback.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELQuestion.h"
#import "ELSearcheableModel.h"

@class ELParticipant;

@protocol ELParticipant;

@interface ELInstantFeedback : ELSearcheableModel

@property (nonatomic) BOOL anonymous;
@property (nonatomic) BOOL closed;
@property (nonatomic) NSInteger invited;
@property (nonatomic) NSInteger answered;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSString *lang;
@property (nonatomic) ELQuestion *question;
@property (nonatomic) NSString<Optional> *key;
@property (nonatomic) NSArray<Optional> *shares;
@property (nonatomic) NSArray<Optional, ELParticipant> *participants;

@property (nonatomic) NSString<Ignore> *dateString;

@end
