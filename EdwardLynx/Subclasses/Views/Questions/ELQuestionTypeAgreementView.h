//
//  ELQuestionTypeAgreementView.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 05/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseQuestionTypeView.h"

@interface ELQuestionTypeAgreementView : ELBaseQuestionTypeView<UIPickerViewDataSource, UIPickerViewDelegate, ELQuestionTypeDelegate>

@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end
