//
//  ELSurvey.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ELSurvey : JSONModel

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *timestamp;
@property (nonatomic) NSString *status;

@end
