//
//  ELActionView.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 16/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELActionView.h"

@implementation ELActionView

- (instancetype)initWithDetails:(NSDictionary *)detailsDict {
    self = [super init];
    NSArray* elements = [[NSBundle mainBundle] loadNibNamed:@"ActionView"
                                                      owner:self
                                                    options:nil];
    
    for (id anObject in elements) {
        if ([anObject isKindOfClass:[self class]]) {
            self = anObject;
            
            break;
        }
    }
    
    [self setupContent:detailsDict];
    
    return self;
}

- (void)setupContent:(NSDictionary *)contentDict {
    self.valueLabel.text = contentDict[@"value"];
    self.titleLabel.text = contentDict[@"title"];
}

@end
