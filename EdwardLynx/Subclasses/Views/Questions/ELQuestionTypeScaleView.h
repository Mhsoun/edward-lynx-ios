//
//  ELQuestionTypeScaleView.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 05/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseQuestionTypeView.h"

@interface ELQuestionTypeScaleView : ELBaseQuestionTypeView<ELQuestionTypeDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scaleChoices;
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)onScaleChoicesValueChange:(id)sender;

@end
