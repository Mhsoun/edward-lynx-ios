//
//  ELIndexOverCompetenciesData.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 11/07/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELModel.h"
#import "ELAverage.h"

@protocol ELAverageIndex;

@interface ELIndexOverCompetenciesData : ELModel

@property (nonatomic) NSString *name;
@property (nonatomic) NSArray<ELAverageIndex> *roles;

@end
