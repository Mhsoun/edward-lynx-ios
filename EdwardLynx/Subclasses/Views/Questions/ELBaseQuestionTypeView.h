//
//  ELBaseQuestionTypeView.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELQuestion.h"

@interface ELBaseQuestionTypeView : UIView<ELQuestionTypeDelegate>

@property (nonatomic, strong) ELQuestion *question;
@property (nonatomic, strong) NSString *questionKey;

@end
