//
//  ELManagerIndividualTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELManagerIndividualTableViewCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate, ELConfigurableCellDelegate>

@property (weak, nonatomic) id<ELManagerItemsDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)onSeeMoreButtonClick:(id)sender;

@end
