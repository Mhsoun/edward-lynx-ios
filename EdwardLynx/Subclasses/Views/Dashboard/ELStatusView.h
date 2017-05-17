//
//  ELStatusView.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 16/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

@interface ELStatusView : UIView

@property (weak, nonatomic) id<ELDashboardViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

- (instancetype)initWithDetails:(NSDictionary *)detailsDict;

@end
