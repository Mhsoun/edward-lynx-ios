//
//  ELQuestionTypeAgreementView.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 05/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELQuestionTypeAgreementView.h"

#pragma mark - Class Extension

@interface ELQuestionTypeAgreementView ()

@property (nonatomic, strong) NSMutableArray *mOptions;

@end

@implementation ELQuestionTypeAgreementView

@synthesize question = _question;

#pragma mark - Lifecycle

- (instancetype)init {
    return [super initWithNibName:@"QuestionTypeAgreementView"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.mOptions = [[NSMutableArray alloc] init];
}

#pragma mark - Private Methods

- (void)setupPickerView {
    // Initialization
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    // Populate question answer
    if ([_question.value integerValue] > -1) {
        [self.pickerView selectRow:[_question.value integerValue]
                       inComponent:0
                          animated:YES];
    }
}

#pragma mark - Public Methods

- (NSDictionary *)formValues {
    ELAnswerOption *option = _question.answer.options[[self.pickerView selectedRowInComponent:0]];
    
    return @{@"question": @(_question.objectId),
             @"answer": (NSNumber *)option.value};
}

#pragma mark - Getter/Setter Methods

- (ELQuestion *)question {
    return _question;
}

- (void)setQuestion:(ELQuestion *)question {
    _question = question;
    self.mOptions = [NSMutableArray arrayWithArray:_question.answer.options];
    
    if (_question.isNA) {
        [self.mOptions addObject:[[ELAnswerOption alloc] initWithDictionary:@{@"description": @"N/A", @"value": @(-1)}
                                                                      error:nil]];
    }
    
    [self setupPickerView];
}

#pragma mark - Protocol Methods (UIPickerView)

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.mOptions.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    
    if (view == nil) {
        label = [[UILabel alloc] initWithFrame:self.pickerView.frame];
        
        // Appearance
        label.backgroundColor = [UIColor clearColor];
        label.font = Font(@"HelveticaNeue", 18.0f);
        label.text = [self.mOptions[row] shortDescription];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        
        // Autoshrink
        label.lineBreakMode = NSLineBreakByClipping;
        label.minimumScaleFactor = 0.5;
        label.numberOfLines = 2;
    }
    
    return label;
}

@end
