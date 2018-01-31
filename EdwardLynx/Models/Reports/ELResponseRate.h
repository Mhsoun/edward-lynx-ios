//
//  ELResponseRate.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ELDataPoint.h"

@protocol ELDataPointBreakdown;

@interface ELResponseRate : JSONModel

@property (nonatomic) NSArray<ELDataPointBreakdown> *dataPoints;

/**
 Returns the maximum value from the set of percentages.
 */
@property (nonatomic) double maxValue;
/**
 Returns the set of percentages.
 */
@property (nonatomic) NSArray<Ignore> *values;

@end
