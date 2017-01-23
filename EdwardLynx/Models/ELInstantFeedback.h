//
//  ELInstantFeedback.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELModel.h"
#import "ELQuestion.h"

@interface ELInstantFeedback : ELModel

@property (nonatomic) BOOL anonymous;
@property (nonatomic) BOOL closed;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSString<Optional> *key;
@property (nonatomic) NSString *lang;
@property (nonatomic) ELQuestion *question;
@property (nonatomic) NSArray<Optional> *shares;

@end
