//
//  ELStatusView.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 16/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELStatusView.h"

@implementation ELStatusView

- (instancetype)initWithDetails:(NSDictionary *)detailsDict {
    self = [super init];
    NSArray* elements = [[NSBundle mainBundle] loadNibNamed:@"StatusView"
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

#pragma mark - Private Methods

- (void)setupContent:(NSDictionary *)contentDict {
    self.titleLabel.text = contentDict[@"title"];
    self.detailsLabel.text = contentDict[@"details"];
}

@end
