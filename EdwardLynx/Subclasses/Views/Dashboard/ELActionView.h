//
//  ELActionView.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 16/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

@interface ELActionView : UIView

@property (strong, nonatomic) id<ELDashboardViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

- (instancetype)initWithDetails:(NSDictionary *)detailsDict;

@end
