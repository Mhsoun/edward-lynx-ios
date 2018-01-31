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
    NSDictionary *formValues = [AppSingleton.mSurveyFormDict objectForKey:@(_question.objectId)];
    NSMutableArray *mRadioButtons = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.mOptions.count; i++) {
        ELAnswerOption *option = self.mOptions[i];
        TNCircularRadioButtonData *data = [TNCircularRadioButtonData new];
        
        data.identifier = Format(@"%@", (NSNumber *)option.value);
        
        if (!_question.optional) {
            data.selected = formValues ? [formValues[@"value"] isEqualToString:data.identifier] : NO;
        } else {
            data.selected = NO;
        }
        
        data.labelText = option.shortDescription;
        data.labelFont = Font(@"Lato-Regular", 14.0f);
        data.labelColor = [UIColor whiteColor];
        
        data.borderColor = [UIColor whiteColor];
        data.circleColor = ThemeColor(kELOrangeColor);
        data.borderRadius = 20;
        data.circleRadius = 15;
        
        [mRadioButtons addObject:data];
    }
    
    self.group = [[TNRadioButtonGroup alloc] initWithRadioButtonData:[mRadioButtons copy]
                                                              layout:TNRadioButtonGroupLayoutVertical];
    self.group.frame = self.radioGroupView.bounds;
    self.group.identifier = @"Choices";
    self.group.marginBetweenItems = 10;
    
    [self.group create];
    [self.radioGroupView addSubview:self.group];
        
    // Notification to handle selection changes
    [NotificationCenter addObserver:self
                           selector:@selector(onSelectionUpdate:)
                               name:SELECTED_RADIO_BUTTON_CHANGED
                             object:self.group];
}

#pragma mark - Public Methods

- (NSDictionary *)formValues {
    if (!_question.optional && !self.group.selectedRadioButton) {
        return nil;
    }
    
    return @{@"question": @(_question.objectId),
             @"type": @(_question.answer.type),
             @"value": self.group.selectedRadioButton.data.identifier};
}

#pragma mark - Getter/Setter Methods

- (ELQuestion *)question {
    return _question;
}

- (void)setQuestion:(ELQuestion *)question {
    _question = question;
    self.mOptions = [NSMutableArray arrayWithArray:_question.answer.options];
    
    if (_question.isNA) {
        [self.mOptions addObject:[[ELAnswerOption alloc] initWithDictionary:@{@"description": NSLocalizedString(@"kELNALabel", nil),
                                                                              @"value": @(-1)}
                                                                      error:nil]];
    }
    
    [self setupRadioGroup];
}

#pragma mark - Notifications

- (void)onSelectionUpdate:(NSNotification *)notification {
    [AppSingleton.mSurveyFormDict setObject:[self formValues] forKey:@(_question.objectId)];
}

@end
