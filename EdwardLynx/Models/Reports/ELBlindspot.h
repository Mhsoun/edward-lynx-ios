//
//  ELBlindspot.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELModel.h"
#import "ELAnswer.h"

@protocol ELAnswer;

@interface ELBlindspot : ELModel

@property (nonatomic) double gap;
@property (nonatomic) double selfPercentage;
@property (nonatomic) double othersPercentage;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *category;
@property (nonatomic) ELAnswer *answerType;

@end
