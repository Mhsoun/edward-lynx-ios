//
//  ELStatusView.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 16/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELStatusView.h"

#pragma mark - Class Extension

@interface ELStatusView ()

@property (nonatomic, strong) NSString *segueIdentifier;

@end

@implementation ELStatusView

#pragma mark - Lifecycle

- (instancetype)initWithDetails:(NSDictionary *)detailsDict {
    NSArray *elements;
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    elements = [[NSBundle mainBundle] loadNibNamed:@"StatusView"
                                             owner:self
                                           options:nil];
    
    for (id anObject in elements) {
        if ([anObject isKindOfClass:[self class]]) {
            self = anObject;
            
            break;
        }
    }
    
    [self registerTapGesture];
    [self setupWithDetails:detailsDict];
    
    return self;
}

#pragma mark - Private Methods

- (void)registerTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(onViewTap:)];
    
    [self addGestureRecognizer:tap];
}

- (void)setupWithDetails:(NSDictionary *)contentDict {
    // Labels
    self.titleLabel.text = contentDict[@"title"];
    self.detailsLabel.text = [contentDict[@"details"] uppercaseString];
    
    // Progress
    self.progressView.layer.cornerRadius = 2.5f;
    
    [self toggleAccessiblityByUserPermissions:[NSSet setWithArray:contentDict[@"permissions"]]];
}

- (void)toggleAccessiblityByUserPermissions:(NSSet *)permissions {
    ELUser *user = [ELAppSingleton sharedInstance].user;
    
    if (![permissions intersectsSet:[user permissionsByRole]]) {
        [self setAlpha:0.5];
    }
}

#pragma mark - Selectors

- (void)onViewTap:(UIGestureRecognizer *)recognizer {
    [self.delegate viewTapToPerformSegueWithIdentifier:self.segueIdentifier];
}

@end
