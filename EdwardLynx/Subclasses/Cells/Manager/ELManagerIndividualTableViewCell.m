//
//  ELManagerIndividualTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELManagerIndividualTableViewCell.h"
#import "ELCircleChartCollectionViewCell.h"
#import "ELDevelopmentPlan.h"

#pragma mark - Private Constants

static CGFloat const kELColumnCount = 3;
static CGFloat const kELSpacing = 5;
static NSString * const kELCellIdentifier = @"CircleChartCell";

#pragma mark - Class Extension

@interface ELManagerIndividualTableViewCell ()

@property (nonatomic, strong) NSDictionary *detailsDict;
@property (nonatomic, strong) NSMutableArray<ELDevelopmentPlan *> *mDevPlans;

@end

@implementation ELManagerIndividualTableViewCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization
    self.mDevPlans = [[NSMutableArray alloc] init];
    
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
    self.detailsDict = (NSDictionary *)object;
    self.nameLabel.text = self.detailsDict[@"name"];
    
    for (NSDictionary *dict in self.detailsDict[@"devPlans"]) {
        [self.mDevPlans addObject:[[ELDevelopmentPlan alloc] initWithDictionary:dict error:nil]];
    }
    
    [self.collectionView reloadData];
}

#pragma mark - Protocol Methods (UICollectionView)

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mDevPlans.count > kELColumnCount ? kELColumnCount : self.mDevPlans.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ELCircleChartCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kELCellIdentifier
                                                                                      forIndexPath:indexPath];
    
    [cell configure:self.mDevPlans[indexPath.row] atIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((CGRectGetWidth(collectionView.frame) / kELColumnCount) - kELSpacing, 110);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [NotificationCenter postNotificationName:kELTeamChartSelectionNotification
                                      object:nil
                                    userInfo:@{@"id": @([self.mDevPlans[indexPath.row] objectId])}];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kELSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kELSpacing;
}

#pragma mark - Interface Builder Actions

- (IBAction)onSeeMoreButtonClick:(id)sender {
    [NotificationCenter postNotificationName:kELTeamSeeMoreNotification
                                      object:nil
                                    userInfo:@{@"id": self.detailsDict[@"id"]}];
}

@end
