//
//  ELManagerIndividualTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELManagerIndividualTableViewCell.h"
#import "ELCircleChartCollectionViewCell.h"

#pragma mark - Private Constants

static CGFloat const kELSpacing = 5;
static NSString * const kELCellIdentifier = @"CircleChartCell";

#pragma mark - Class Extension

@interface ELManagerIndividualTableViewCell ()

@property (nonatomic, strong) NSArray *devPlans;

@end

@implementation ELManagerIndividualTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // Initialization
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:kELCellIdentifier bundle:nil]
          forCellWithReuseIdentifier:kELCellIdentifier];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *individualDict = (NSDictionary *)object;
    
    self.nameLabel.text = individualDict[@"name"];
    self.devPlans = individualDict[@"data"];
    
    [self.collectionView reloadData];
}

#pragma mark - Protocol Methods (UICollectionView)

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.devPlans.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ELCircleChartCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kELCellIdentifier
                                                                                      forIndexPath:indexPath];
    
    [cell configure:self.devPlans[indexPath.row] atIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((CGRectGetWidth(collectionView.frame) / 3) - kELSpacing, 110);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // NOTE Disable for now
//    [self.delegate onChartSelection:nil];  // TODO Should be instance of dev plan
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kELSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kELSpacing;
}

#pragma mark - Interface Builder Actions

- (IBAction)onSeeMoreButtonClick:(id)sender {
    // NOTE Disable for now
//    [self.delegate onSeeMore:nil];  // TODO Should be id of dev plan selected
}

@end
