//
//  ELSectionView.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSectionView.h"

@interface ELSectionView ()

@property (strong, nonatomic) NSString *segueIdentifier;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
- (IBAction)onButtonClick:(id)sender;

@end

@implementation ELSectionView

- (instancetype)initWithDetails:(NSDictionary *)detailsDict frame:(CGRect)frame {
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
    
    self.frame = frame;
    self.titleLabel.text = [detailsDict[@"title"] uppercaseString];
    self.segueIdentifier = detailsDict[@"segue"];
    self.button.hidden = !self.segueIdentifier;
    
    // UI
    self.button.tintColor = ThemeColor(kELOrangeColor);
    
    return self;
}

- (IBAction)onButtonClick:(id)sender {
    [self.delegate viewTapToPerformControllerPushWithIdentifier:self.segueIdentifier];
}

@end
