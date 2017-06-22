//
//  ELCircleChart.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <PNChart/PNChart.h>
#import <UIKit/UIKit.h>

@interface ELCircleChart : UIView

@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)setupContent:(NSDictionary *)detailsDict;

@end
