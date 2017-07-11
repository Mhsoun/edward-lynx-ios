//
//  ELAverage.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELModel.h"

@interface ELAverage : ELModel

@property (nonatomic) double value;
@property (nonatomic) NSString *name;

@end

@interface ELAverageIndex : ELModel

@property (nonatomic) double average;
@property (nonatomic) NSString *name;

@end
