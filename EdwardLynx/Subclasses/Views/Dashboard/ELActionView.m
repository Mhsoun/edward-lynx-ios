//
//  ELActionView.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 16/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELActionView.h"

#pragma mark - Class Extension

@interface ELActionView ()

@property (nonatomic, strong) NSString *segueIdentifier;

@end

@implementation ELActionView

#pragma mark - Lifecycle

- (instancetype)initWithDetails:(NSDictionary *)detailsDict {
    NSArray *elements;
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    elements = [[NSBundle mainBundle] loadNibNamed:@"ActionView"
                                             owner:self
                                           options:nil];
    
    for (id anObject in elements) {
        if ([anObject isKindOfClass:[self class]]) {
            self = anObject;
            
            break;
        }
    }
    
    self.segueIdentifier = detailsDict[@"segue"];
    
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
    NSNumber *count = contentDict[@"count"];
    
    // Content
    self.titleLabel.text = [contentDict[@"title"] uppercaseString];
    self.countLabel.text = [count integerValue] > 99 ? @"99+" : [count stringValue];
    
    // UI
    self.bgView.layer.cornerRadius = 5.0f;
    self.countLabel.layer.cornerRadius = 10.0f;
    self.countLabel.backgroundColor = [[RNThemeManager sharedManager] colorForKey:kELRedColor];
    self.countLabel.hidden = [contentDict[@"count"] intValue] == 0;
    
//    [self toggleAccessiblityByUserPermissions:[NSSet setWithArray:contentDict[@"permissions"]]];
}

- (void)toggleAccessiblityByUserPermissions:(NSSet *)permissions {
    ELUser *user = AppSingleton.user;
    
    if (![permissions intersectsSet:[user permissionsByRole]]) {
        [self setAlpha:0.5];
    }
}

#pragma mark - Selectors

- (void)onViewTap:(UIGestureRecognizer *)recognizer {
    [self.delegate viewTapToPerformSegueWithIdentifier:self.segueIdentifier];
}


@end
