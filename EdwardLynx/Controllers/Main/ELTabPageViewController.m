//
//  ELTabPageViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 23/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELTabPageViewController.h"
#import "ELBasePageChildViewController.h"
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onInstantFeedbackTab:)
                                                 name:kELInstantFeedbackTabNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kELInstantFeedbackTabNotification
                                                  object:nil];
}

- (void)dealloc {
    DLog(@"%@", [self class]);
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

- (void)sendSearchTextToNotification:(NSString *)searchText {
    AppSingleton.searchText = searchText;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kELTabPageSearchNotification
                                                        object:self
                                                      userInfo:@{@"search": searchText}];
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
            identifier = NSLocalizedString(@"kELTabTitleDevPlan", nil);
            
            self.addButton.hidden = NO;
            
            break;
        case kELListTypeReports:
            identifier = NSLocalizedString(@"kELTabTitleReports", nil);
            
            self.addButton.hidden = YES;
            
            break;
        case kELListTypeSurveys:
            identifier = NSLocalizedString(@"kELTabTitleSurveys", nil);
            
            self.addButton.hidden = YES;
            
            break;
        default:
            break;
    }
    
    self.title = [identifier uppercaseString];
    self.searchBar.placeholder = Format(format, identifier);
}

#pragma mark - Protocol Methods (UISearchBar)

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self sendSearchTextToNotification:searchText];
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    [self sendSearchTextToNotification:searchBar.text];
}

#pragma mark - Protocol Methods (XLButtonBarPagerTabStripViewController)

- (NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController {
    __kindof ELBasePageChildViewController *controller;
    NSString *identifier = [self identifierByType:self.type];
    NSMutableArray *mControllers = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.tabs.count; i++) {
        controller = StoryboardController(identifier, identifier);
        controller.index = i;
        controller.tabs = self.tabs;
        
        [mControllers addObject:controller];
    }
    
    return [mControllers copy];
}

#pragma mark - Interface Builder Actions

- (IBAction)onAddButtonClick:(id)sender {
    NSString *storyboard;
    __kindof ELBaseViewController *controller;
    
    switch (self.type) {
        case kELListTypeDevPlan:
            storyboard = @"CreateDevelopmentPlan";
            
            break;
        case kELListTypeSurveys:
            storyboard = @"CreateInstantFeedback";
            
            break;
        default:
            return;
            break;
    }
    
    controller = StoryboardController(storyboard, nil);
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Selectors

- (void)onInstantFeedbackTab:(NSNotification *)notification {
    BOOL hidden = [notification.userInfo[@"hidden"] boolValue];
    __weak typeof(self) weakSelf = self;
    
    self.addButton.hidden = NO;
    
    [UIView animateWithDuration:0.15 animations:^{
        weakSelf.addButton.transform = hidden ? CGAffineTransformMakeScale(0, 0) : CGAffineTransformIdentity;
    }];
}

@end
