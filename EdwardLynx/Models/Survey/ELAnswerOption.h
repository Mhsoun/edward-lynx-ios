//
//  ELAnswerOption.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 04/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ELAnswerOptionRespondent;

@interface ELAnswerOption : JSONModel

@property (nonatomic) int64_t count;
@property (nonatomic) NSObject *value;
@property (nonatomic) NSString<Optional> *shortDescription;
@property (nonatomic) NSArray<ELAnswerOptionRespondent, Optional> *submissions;

@end

@interface ELAnswerOptionRespondent : ELModel

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;

@end
