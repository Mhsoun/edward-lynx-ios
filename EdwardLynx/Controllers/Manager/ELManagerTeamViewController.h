//
//  ELManagerTeamViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <XLPagerTabStrip-AnthonyMDev/XLBarPagerTabStripViewController.h>

#import "ELBaseViewController.h"

@interface ELManagerTeamViewController : ELBaseViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ELAPIResponseDelegate, DZNEmptyDataSetSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIButton *addCategoryButton;
- (IBAction)onAddCategoryButtonClick:(id)sender;

@end
