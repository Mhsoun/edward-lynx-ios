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

@property (nonatomic) double maxValue;
@property (nonatomic) NSArray<ELDataPointBreakdown> *dataPoints;

@end
