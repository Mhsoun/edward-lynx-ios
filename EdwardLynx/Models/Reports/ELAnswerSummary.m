//
//  ELAnswerSummary.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELAnswerSummary.h"

@implementation ELAnswerSummary

- (NSArray *)pointKeys {
    NSMutableArray *mKeys = [[NSMutableArray alloc] init];
    
    for (ELDataPointSummary *dataPoint in self.dataPoints) {
        [mKeys addObject:dataPoint.question];
    }
    
    return [mKeys copy];
}

@end
