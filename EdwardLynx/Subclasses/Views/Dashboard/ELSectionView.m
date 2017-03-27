//
//  ELSectionView.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSectionView.h"

@interface ELSectionView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
- (IBAction)onButtonClick:(id)sender;

@end

@implementation ELSectionView

- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame accessSeeMore:(BOOL)seeMore {
    NSArray *elements;
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    elements = [[NSBundle mainBundle] loadNibNamed:@"SectionView"
                                             owner:self
                                           options:nil];
    
    for (id anObject in elements) {
        if ([anObject isKindOfClass:[self class]]) {
            self = anObject;
            
            break;
        }
    }
    
    self.titleLabel.text = title;
    self.frame = frame;
    self.button.hidden = !seeMore;
    
    // UI
    self.button.tintColor = [[RNThemeManager sharedManager] colorForKey:kELOrangeColor];
    
    return self;
}

- (IBAction)onButtonClick:(id)sender {

}

@end
