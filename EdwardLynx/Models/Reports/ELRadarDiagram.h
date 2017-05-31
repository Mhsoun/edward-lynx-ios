//
//  ELRadarDiagram.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELModel.h"
#import "ELAverage.h"

@protocol ELAverage;

@interface ELRadarDiagram : ELModel

@property (nonatomic) NSString *name;
@property (nonatomic) NSArray<ELAverage> *roles;

@end
