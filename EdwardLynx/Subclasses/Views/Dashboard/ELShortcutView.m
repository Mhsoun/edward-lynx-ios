//
//  ELShortcutView.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 16/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELShortcutView.h"

#pragma mark - Class Extension

@interface ELShortcutView ()

@property (nonatomic, strong) NSString *segueIdentifier;

@end

@implementation ELShortcutView

#pragma mark - Lifecycle

- (instancetype)initWithDetails:(NSDictionary *)detailsDict {
    NSArray *elements;
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    elements = [[NSBundle mainBundle] loadNibNamed:@"ShortcutView"
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
    CGFloat iconHeight = 100;
    
    self.icon.image = [FontAwesome imageWithIcon:contentDict[@"icon"]
                                       iconColor:[UIColor whiteColor]
                                        iconSize:iconHeight
                                       imageSize:CGSizeMake(iconHeight, iconHeight)];
    self.titleLabel.text = contentDict[@"title"];
    self.backgroundColor = ThemeColor(contentDict[@"color"]);
    
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
    [self.delegate viewTapToPerformControllerPushWithIdentifier:self.segueIdentifier];
}

@end
