//
//  ELQuestionTypeRadioGroupView.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 23/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELQuestionTypeRadioGroupView.h"

#pragma mark - Class Extension

@interface ELQuestionTypeRadioGroupView ()

@property (nonatomic, strong) NSMutableArray *mOptions;
@property (nonatomic, strong) TNRadioButtonGroup *group;

@end

@implementation ELQuestionTypeRadioGroupView

@synthesize question = _question;

#pragma mark - Lifecycle

- (instancetype)init {
    return [super initWithNibName:@"QuestionTypeRadioGroupView"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.mOptions = [[NSMutableArray alloc] init];
}

#pragma mark - Private Methods

- (void)setupRadioGroup {
    NSMutableArray *mRadioButtons = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.mOptions.count; i++) {
        ELAnswerOption *option = self.mOptions[i];
        TNCircularRadioButtonData *data = [TNCircularRadioButtonData new];
        
        data.identifier = [NSString stringWithFormat:@"%@", @(option.value)];
        
        if (!_question.optional) {
            data.selected = i == 0;
        }
        
        data.labelText = option.shortDescription;
        data.labelFont = [UIFont fontWithName:@"Lato-Regular" size:14];
        data.labelColor = [UIColor whiteColor];
        
        data.borderColor = [UIColor whiteColor];
        data.circleColor = [[RNThemeManager sharedManager] colorForKey:kELOrangeColor];
        data.borderRadius = 20;
        data.circleRadius = 15;
        
        [mRadioButtons addObject:data];
    }
    
    self.group = [[TNRadioButtonGroup alloc] initWithRadioButtonData:[mRadioButtons copy] layout:TNRadioButtonGroupLayoutVertical];
    self.group.frame = self.radioGroupView.bounds;
    self.group.identifier = @"Choices";
    self.group.marginBetweenItems = 10;
    
    [self.group create];
    [self.radioGroupView addSubview:self.group];
}

#pragma mark - Public Methods

- (NSDictionary *)formValues {
    if (!_question.optional && !self.group.selectedRadioButton) {
        return nil;
    }
    
    return @{@"question": @(_question.objectId),
             @"answer": @([self.group.selectedRadioButton.data.identifier integerValue])};
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
    
    [self setupRadioGroup];
}

@end
