//
//  ELManagerTeamCollectionViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ELCircleChart.h"

@interface ELManagerTeamCollectionViewCell : UICollectionViewCell<ELConfigurableCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath;

@end
