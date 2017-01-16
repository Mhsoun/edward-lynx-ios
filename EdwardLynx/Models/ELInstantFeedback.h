//
//  ELInstantFeedback.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELModel.h"

@protocol ELQuestion;

@interface ELInstantFeedback : ELModel

@property (nonatomic) BOOL anonymous;
@property (nonatomic) BOOL closed;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSString *key;
@property (nonatomic) NSString *lang;
@property (nonatomic) NSArray<ELQuestion> *questions;

@end
