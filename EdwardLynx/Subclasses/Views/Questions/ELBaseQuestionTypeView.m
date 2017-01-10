//
//  ELBaseQuestionTypeView.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseQuestionTypeView.h"

@implementation ELBaseQuestionTypeView

#pragma mark - Protocol Methods (ELQuestionType)

- (instancetype)initWithNibName:(NSString *)nib {
    NSArray *elements;
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    elements = [[NSBundle mainBundle] loadNibNamed:nib
                                             owner:self
                                           options:nil];
    
    for (id anObject in elements) {
        if ([anObject isKindOfClass:[self class]]) {
            self = anObject;
            
            break;
        }
    }
        
    return self;
}

- (NSDictionary *)formValues {
    // NOTE Implementation is per subclass
    
    return nil;
}

@end
