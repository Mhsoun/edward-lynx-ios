//
//  ELShortcutView.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 16/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <RNThemeView.h>

@interface ELShortcutView : RNThemeView

@property (strong, nonatomic) id<ELDashboardViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (instancetype)initWithDetails:(NSDictionary *)detailsDict;

@end
