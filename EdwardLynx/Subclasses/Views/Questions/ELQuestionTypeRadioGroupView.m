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
    NSMutableArray *mRadioButtons;
    TNRadioButtonGroup *group;
    
    mRadioButtons = [[NSMutableArray alloc] init];
    
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
    
    group = [[TNRadioButtonGroup alloc] initWithRadioButtonData:[mRadioButtons copy] layout:TNRadioButtonGroupLayoutVertical];
    group.frame = self.radioGroupView.bounds;
    group.identifier = @"Choices";
    group.marginBetweenItems = 10;
    
    [group create];
    [self.radioGroupView addSubview:group];
}

#pragma mark - Public Methods

- (NSDictionary *)formValues {
    return @{};
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
