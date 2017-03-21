//
//  ELNotificationView.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//
//  Pattern largely based to KDNotification (https://cocoapods.org/pods/KDNotification)

#import "ELNotificationView.h"

#pragma mark - Private Constants

static ELNotificationView *currentNotificationView = nil;

#pragma mark - Class Extension

@interface ELNotificationView ()

@property (strong, nonatomic) NSLayoutConstraint *animateConstraint;
@property (copy, nonatomic, nullable) ELNotificationTapped tapped;

@end

@implementation ELNotificationView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // UI
    self.layoutMargins = UIEdgeInsetsZero;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
}

#pragma mark - Public Methods

+ (instancetype)showWithNotification:(ELNotification *)notification tapped:(ELNotificationTapped)tapped {
    ELNotificationView *notificationView;
    
    if (currentNotificationView) {
        [currentNotificationView dismiss];
    }
    
    notificationView = [self notificationView];
    notificationView.tapped = tapped;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:notificationView];
    [notificationView addConstraints];
    [notificationView addTapGesture];
    [notificationView setupContent:notification];
    [notificationView showNotificationAnimation];
    
    currentNotificationView = notificationView;
    
    return notificationView;
}

+ (instancetype)showWithNotification:(ELNotification *)notification
                            duration:(NSTimeInterval)duration
                              tapped:(ELNotificationTapped)tapped {
    ELNotificationView *notificationView = [self showWithNotification:notification tapped:tapped];
    
    [notificationView dismissNotificationAfter:duration];
    
    return notificationView;
}

#pragma mark - Private Methods

- (void)addConstraints {
    NSArray *vertical;
    NSMutableArray *allConstraints = [NSMutableArray array];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"[notification(500)]"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:@{@"notification": self}];
        NSLayoutConstraint *horizontalCenter = [NSLayoutConstraint constraintWithItem:self
                                                                            attribute:NSLayoutAttributeCenterX
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.superview
                                                                            attribute:NSLayoutAttributeCenterX
                                                                           multiplier:1.0
                                                                             constant:0.0];
        
        [allConstraints addObjectsFromArray:horizontal];
        [allConstraints addObject:horizontalCenter];
    } else {
        NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[notification]-10-|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:@{@"notification": self}];
        
        [allConstraints addObjectsFromArray:horizontal];
    }
    
    vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[notification(==90)]"
                                                       options:kNilOptions
                                                       metrics:nil
                                                         views:@{@"notification": self}];
    
    self.animateConstraint = vertical.firstObject;
    
    [allConstraints addObjectsFromArray:vertical];
    [NSLayoutConstraint activateConstraints:allConstraints];
}

- (void)addTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(tappedNotification)];
    
    [self addGestureRecognizer:tapGesture];
}

- (void)dismiss {
    self.animateConstraint.constant = [self startPosition];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (currentNotificationView == self) {
            currentNotificationView = nil;
        }
        
        [self removeFromSuperview];
    }];
}

- (void)dismissNotificationAfter:(NSTimeInterval)interval {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

- (void)setupContent:(ELNotification *)notification {
    NSString *imageName;
    
    if ([notification.type isEqualToString:kELNotificationTypeDevPlan]) {
        imageName = @"DevelopmentPlan";
    } else if ([notification.type isEqualToString:kELNotificationTypeInstantFeedbackRequest]) {
        imageName = @"InstantFeedback";
    } else {
        imageName = @"Survey";
    }
    
    self.iconImageView.image = nil;  // TODO Image based on type
    self.titleLabel.text = notification.title;
    self.detailLabel.text = notification.body;
}
     
- (void)showNotificationAnimation {
    self.animateConstraint.constant = [self startPosition];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.animateConstraint.constant = 20;
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            [self.superview layoutIfNeeded];
        } completion:nil];
    });
}

- (CGFloat)startPosition {
    return -CGRectGetHeight(self.frame);
}

- (void)tappedNotification {
    if (self.tapped) {
        self.tapped();
    }
    
    [self dismiss];
}

+ (instancetype)notificationView {
    ELNotificationView *notificationView = [[[NSBundle mainBundle] loadNibNamed:@"NotificationView"
                                                                          owner:nil
                                                                        options:nil] firstObject];
    
    return notificationView;
}

@end
