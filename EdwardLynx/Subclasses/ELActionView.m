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
    
    [self registerTapGesture];
    [self setupContent:detailsDict];
    
    return self;
}

#pragma mark - Private Methods

- (void)registerTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(onViewTap:)];
    
    [self addGestureRecognizer:tap];
}

- (void)setupContent:(NSDictionary *)contentDict {
    self.valueLabel.text = contentDict[@"value"];
    self.titleLabel.text = contentDict[@"title"];
}

#pragma mark - Selectors

- (void)onViewTap:(UIGestureRecognizer *)recognizer {
    NSLog(@"%@", [self class]);
}

@end
