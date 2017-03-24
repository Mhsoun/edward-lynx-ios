//
//  ELTabPagViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 23/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELTabPagViewController.h"
#import "ELDevelopmentPlansViewController.h"

#pragma mark - Class Extension

@interface ELTabPagViewController ()

@end

@implementation ELTabPagViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.isProgressiveIndicator = YES;
    self.changeCurrentIndexProgressiveBlock = ^void(XLButtonBarViewCell *oldCell,
                                                    XLButtonBarViewCell *newCell,
                                                    CGFloat progressPercentage,
                                                    BOOL changeCurrentIndex,
                                                    BOOL animated) {
        if (changeCurrentIndex) {
            UIFont *font = [UIFont fontWithName:@"Lato-Bold" size:13];
            
            [oldCell.label setFont:font];
            [newCell.label setFont:font];
            [oldCell.label setTextColor:[[RNThemeManager sharedManager] colorForKey:kELVioletColor]];
            [newCell.label setTextColor:[[RNThemeManager sharedManager] colorForKey:kELOrangeColor]];
        }
    };
    
    [self setupButtonBarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)setupButtonBarView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.buttonBarView removeFromSuperview];
    
    self.buttonBarView.frame = self.tabView.bounds;
    self.buttonBarView.backgroundColor = [UIColor clearColor];
    self.buttonBarView.collectionViewLayout = flowLayout;
    self.buttonBarView.selectedBarHeight = 0;
    self.buttonBarView.selectedBarAlignment = XLSelectedBarAlignmentCenter;
    self.buttonBarView.shouldCellsFillAvailableWidth = YES;
    
    [self.tabView addSubview:self.buttonBarView];
}

#pragma mark - Protocol Methods (XLButtonBarPagerTabStripViewController)

- (NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController {
    ELDevelopmentPlansViewController *child_1 = [[UIStoryboard storyboardWithName:@"DevelopmentPlan" bundle:nil]
                                                 instantiateViewControllerWithIdentifier:@"DevPlan"];
    
    return @[child_1, child_1, child_1, child_1];
}

@end
