//
//  ELBaseQuestionTypeView.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELQuestion.h"

static CGFloat const kELCustomScaleItemHeight = 35;

@interface ELBaseQuestionTypeView : UIView<ELQuestionTypeDelegate>

@property (nonatomic, strong) ELQuestion *question;

@end
