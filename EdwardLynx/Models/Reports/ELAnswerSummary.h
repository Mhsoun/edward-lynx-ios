//
//  ELAnswerSummary.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ELDataPoint.h"

@protocol ELDataPointSummary;

@interface ELAnswerSummary : JSONModel

@property (nonatomic) NSString *category;
@property (nonatomic) NSArray<ELDataPointSummary> *dataPoints;

/**
 Returns a list of questions to be used for rendering chart.

 @return A list of questions.
 */
- (NSArray *)pointKeys;

@end
