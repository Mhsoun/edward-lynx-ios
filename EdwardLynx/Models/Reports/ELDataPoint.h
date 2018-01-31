//
//  ELDataPoint.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 30/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ELDataPointBreakdown : JSONModel

@property (nonatomic) double percentage;
@property (nonatomic) NSString *colorKey;
@property (nonatomic) NSString *title;

@end

@interface ELDataPointSummary : JSONModel

@property (nonatomic) double percentage;
@property (nonatomic) double percentage1;
@property (nonatomic) NSString *question;

@end
