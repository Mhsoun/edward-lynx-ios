//
//  ELTabPageViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 23/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELTabPageViewController.h"
#import "ELDevelopmentPlansViewController.h"
#import "ELSearchBar.h"

#pragma mark - Class Extension

@interface ELTabPageViewController ()

@property (weak, nonatomic) IBOutlet UIView *tabView;
@property (weak, nonatomic) IBOutlet ELSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
- (IBAction)onAddButtonClick:(id)sender;

@end

@implementation ELTabPageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.searchBar.delegate = self;
    
    [self setupButtonBarView];
    [self setupPageByType:self.type];
    [self moveToViewControllerAtIndex:self.initialIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (NSString *)identifierByType:(kELListType)type {
    switch (type) {
        case kELListTypeDevPlan:
            return @"DevelopmentPlan";
            
            break;
        case kELListTypeReports:
            return @"Report";
            
            break;
        case kELListTypeSurveys:
            return @"Survey";
            
            break;
        default:
            return nil;
            
            break;
    }
}

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
    NSString *identifier;
    CGFloat iconHeight = 15;
    NSString *format = @"Search %@";
    
    // Button
    [self.addButton setImage:[FontAwesome imageWithIcon:fa_plus
                                              iconColor:[UIColor blackColor]
                                               iconSize:iconHeight
                                              imageSize:CGSizeMake(iconHeight, iconHeight)]
                    forState:UIControlStateNormal];
    
    switch (type) {
        case kELListTypeDevPlan:
            identifier = @"Development Plans";
            
            self.title = [identifier uppercaseString];
            self.searchBar.placeholder = [NSString stringWithFormat:format, identifier];
            self.addButton.hidden = NO;
            
            break;
        case kELListTypeReports:
            identifier = @"Reports";
            
            self.title = [identifier uppercaseString];
            self.searchBar.placeholder = [NSString stringWithFormat:format, identifier];
            self.addButton.hidden = YES;
            
            break;
        case kELListTypeSurveys:
            identifier = @"Surveys";
            
            self.title = [identifier uppercaseString];
            self.searchBar.placeholder = [NSString stringWithFormat:format, identifier];
            self.addButton.hidden = NO;
            
            break;
        default:
            break;
    }
}

#pragma mark - Protocol Methods (UISearchBar)

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // TODO Filtering implementation
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [[searchBar delegate] searchBar:searchBar textDidChange:@""];
    
    [searchBar setText:@""];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar endEditing:YES];
}

#pragma mark - Protocol Methods (XLButtonBarPagerTabStripViewController)

- (NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController {
    __kindof ELBasePageChildViewController *controller;
    NSString *identifier = [self identifierByType:self.type];
    NSMutableArray *mControllers = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.tabs.count; i++) {
        controller = [[UIStoryboard storyboardWithName:identifier bundle:nil]
                      instantiateViewControllerWithIdentifier:identifier];
        
        controller.index = i;
        controller.tabs = self.tabs;
        
        [mControllers addObject:controller];
    }
    
    return [mControllers copy];
}

#pragma mark - Interface Builder Actions

- (IBAction)onAddButtonClick:(id)sender {
    
}

@end
