//
//  ELSectionView.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELSectionView : UIView

@property (nonatomic, strong) id<ELDashboardViewDelegate> delegate;

- (instancetype)initWithDetails:(NSDictionary *)detailsDict frame:(CGRect)frame;

@end
