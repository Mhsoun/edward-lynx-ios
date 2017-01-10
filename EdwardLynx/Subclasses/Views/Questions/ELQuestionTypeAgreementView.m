//
//  ELQuestionTypeAgreementView.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 05/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELQuestionTypeAgreementView.h"

@implementation ELQuestionTypeAgreementView

@synthesize question = _question;

#pragma mark - Lifecycle

- (instancetype)init {
    return [super initWithNibName:@"QuestionTypeAgreementView"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - Private Methods

- (void)setupPickerView {
    // Initialization
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}

#pragma mark - Public Methods

- (NSDictionary *)formValues {
    ELAnswerOption *option = _question.answer.options[[self.pickerView selectedRowInComponent:0]];
    
    return @{@"question": @(_question.objectId),
             @"answer": _question.isNA ? @(-1) : @(option.value)};
}

#pragma mark - Getter/Setter Methods

- (ELQuestion *)question {
    return _question;
}

- (void)setQuestion:(ELQuestion *)question {
    _question = question;
    
    [self setupPickerView];
}

#pragma mark - Protocol Methods (UIPickerView)

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _question.answer.options.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    UILabel *label = (UILabel*)view;
    
    if (view == nil) {
        label = [[UILabel alloc] initWithFrame:self.pickerView.frame];
        label.backgroundColor = [UIColor clearColor];
        label.text = [_question.answer.options[row] shortDescription];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Lato-Bold" size:16];
    }
    
    return label;
}

@end
