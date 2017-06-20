//
//  ELTeamTabPageViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELTeamTabPageViewController.h"
#import "ELBasePageChildViewController.h"
#import "ELManagerIndividualViewController.h"

#pragma mark - Class Extension

@interface ELTeamTabPageViewController ()

@property (weak, nonatomic) IBOutlet UIView *tabView;

@end

@implementation ELTeamTabPageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    [self setupButtonBarView];
    [self moveToViewControllerAtIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (XLButtonBarPagerTabStripViewController)

- (NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController {
    ELManagerIndividualViewController *controller;
    NSMutableArray *mControllers = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.tabs.count; i++) {
        controller = StoryboardController(@"TeamTabPage", @"ManagerIndividual");
        
        [mControllers addObject:controller];
    }
    
    return [mControllers copy];
}

#pragma mark - Private Methods

- (void)setupButtonBarView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.isProgressiveIndicator = YES;
    self.changeCurrentIndexProgressiveBlock = ^void(XLButtonBarViewCell *oldCell,
                                                    XLButtonBarViewCell *newCell,
                                                    CGFloat progressPercentage,
                                                    BOOL changeCurrentIndex,
                                                    BOOL animated) {
        if (changeCurrentIndex) {
            UIFont *font = Font(@"Lato-Bold", 13.0f);
            
            [oldCell.label setFont:font];
            [newCell.label setFont:font];
            [oldCell.label setTextColor:ThemeColor(kELInactiveColor)];
            [newCell.label setTextColor:ThemeColor(kELOrangeColor)];
        }
    };
    
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

@end
