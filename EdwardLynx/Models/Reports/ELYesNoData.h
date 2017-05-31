//
//  ELYesNoData.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 31/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELModel.h"

@interface ELYesNoData : ELModel

@property (nonatomic) double yesPercentage;
@property (nonatomic) double noPercentage;
@property (nonatomic) NSString *category;
@property (nonatomic) NSString *question;

@end
