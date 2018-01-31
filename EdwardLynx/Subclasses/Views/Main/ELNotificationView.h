//
//  ELNotificationView.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ELNotification.h"

typedef void (^ELNotificationTapped)(void);

@interface ELNotificationView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

+ (instancetype)showWithNotification:(ELNotification *)notification tapped:(ELNotificationTapped)tapped;
+ (instancetype)showWithNotification:(ELNotification *)notification
                            duration:(NSTimeInterval)duration
                              tapped:(ELNotificationTapped)tapped;

@end
