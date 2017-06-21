//
//  ELManagerTeamViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELManagerTeamViewController.h"
#import "ELManagerTeamCollectionViewCell.h"

#pragma mark - Private Constants

static CGFloat const kELSpacing = 5;
static NSString * const kELCellIdentifier = @"ManagerTeamCell";

#pragma mark - Class Extension

@interface ELManagerTeamViewController ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation ELManagerTeamViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.items = @[@{@"name": @"Public Speaking", @"percentage": @0.5},
                   @{@"name": @"Leadership", @"percentage": @0.8},
                   @{@"name": @"Excellence", @"percentage": @0.3},
                   @{@"name": @"Faith", @"percentage": @0.4}];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (UICollectionView)

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ELManagerTeamCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kELCellIdentifier
                                                                                      forIndexPath:indexPath];
    
    [cell configure:self.items[indexPath.row] atIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((CGRectGetWidth(collectionView.frame) / 3) - kELSpacing, 110);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kELSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kELSpacing;
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    CGFloat iconHeight = 15;
    
    // Button
    [self.addCategoryButton setImage:[FontAwesome imageWithIcon:fa_plus
                                                      iconColor:[UIColor blackColor]
                                                       iconSize:iconHeight
                                                      imageSize:CGSizeMake(iconHeight, iconHeight)]
                            forState:UIControlStateNormal];
}

#pragma mark - Protocol Methods (XLPagerTabStrip)

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController {
    return [NSLocalizedString(@"kELTabTitleTeam", nil) uppercaseString];
}

#pragma mark - Interface Builder Actions

- (IBAction)onAddCategoryButtonClick:(id)sender {
    
}

@end
