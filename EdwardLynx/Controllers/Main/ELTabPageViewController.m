//
//  ELTabPageViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 23/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELTabPageViewController.h"
#import "ELDevelopmentPlansViewController.h"

#pragma mark - Class Extension

@interface ELTabPageViewController ()

@end

@implementation ELTabPageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    [self setupButtonBarView];
    [self setupPageByType:self.type];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            UIFont *font = [UIFont fontWithName:@"Lato-Bold" size:13];
            
            [oldCell.label setFont:font];
            [newCell.label setFont:font];
            [oldCell.label setTextColor:[[RNThemeManager sharedManager] colorForKey:kELVioletColor]];
            [newCell.label setTextColor:[[RNThemeManager sharedManager] colorForKey:kELOrangeColor]];
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

- (void)setupPageByType:(kELListType)type {
    switch (type) {
        case kELListTypeDevPlan:
            self.title = @"DEVELOPMENT PLANS";
            
            break;
        case kELListTypeReports:
            self.title = @"REPORTS";
            
            break;
        case kELListTypeSurveys:
            self.title = @"SURVEYS";
            
            break;
        default:
            break;
    }
}

#pragma mark - Protocol Methods (XLButtonBarPagerTabStripViewController)

- (NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController {
    ELDevelopmentPlansViewController *controller;
    NSMutableArray *mControllers = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.tabs.count; i++) {  // TODO Temp condition;
        controller = [[UIStoryboard storyboardWithName:@"DevelopmentPlan" bundle:nil]
                      instantiateViewControllerWithIdentifier:@"DevPlan"];
        
        controller.index = i;
        controller.tabs = self.tabs;
        
        [mControllers addObject:controller];
    }
    
    return [mControllers copy];
}

@end
