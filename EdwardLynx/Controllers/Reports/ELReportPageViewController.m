//
//  ELReportPageViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELReportPageViewController.h"
#import "ELDetailViewManager.h"
#import "ELInstantFeedback.h"
#import "ELReportChildPageViewController.h"
#import "ELReportDetailsViewController.h"
#import "ELSurvey.h"

#pragma mark - Class Extension

@interface ELReportPageViewController ()

@property (nonatomic) NSInteger pageCount, pageIndex;
@property (nonatomic, strong) NSDictionary *responseDict;
@property (nonatomic, strong) NSArray *reportKeys;
@property (nonatomic, strong) NSMutableArray *mControllers;
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) ELDetailViewManager *viewManager;

@end

@implementation ELReportPageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Intialization
    self.pageCount = 0, self.pageIndex = 0;
    self.mControllers = [[NSMutableArray alloc] init];
    
    self.viewManager = [[ELDetailViewManager alloc] initWithDetailObject:self.selectedObject];
    self.viewManager.delegate = self;
    
    [self.viewManager processRetrievalOfReportDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DLog(@"%@", [self class]);
}

#pragma mark - Protocol Methods (UIPageViewController)

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    __kindof ELBasePageChildViewController *controller = (__kindof ELBasePageChildViewController *)[pendingViewControllers lastObject];
    
    self.pageIndex = [controller index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    BOOL isLastPage = self.pageIndex == self.pageCount - 1;
    
    self.pageControl.currentPage = self.pageIndex;
    self.prevButton.hidden = self.pageIndex == 0;
    self.nextButton.hidden = isLastPage;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    __kindof ELBasePageChildViewController *controller = (__kindof ELBasePageChildViewController *)viewController;
    NSInteger index = [controller index];
    
    index++;
    
    if (index == self.pageCount) {
        return nil;
    }
    
    self.pageIndex = index;
    
    return self.mControllers[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    __kindof ELBasePageChildViewController *controller = (__kindof ELBasePageChildViewController *)viewController;
    NSInteger index = [controller index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    self.pageIndex = index;
    
    return self.mControllers[index];
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    CGFloat iconSize = 15;
    
    // Buttons
    [self.prevButton setTintColor:ThemeColor(kELOrangeColor)];
    [self.prevButton setImage:[FontAwesome imageWithIcon:fa_chevron_left
                                               iconColor:ThemeColor(kELOrangeColor)
                                                iconSize:iconSize
                                               imageSize:CGSizeMake(iconSize, iconSize)]
                     forState:UIControlStateNormal];
    [self.nextButton setTintColor:ThemeColor(kELOrangeColor)];
    [self.nextButton setImage:[FontAwesome imageWithIcon:fa_chevron_right
                                               iconColor:ThemeColor(kELOrangeColor)
                                                iconSize:iconSize
                                               imageSize:CGSizeMake(iconSize, iconSize)]
                     forState:UIControlStateNormal];
    
    // Page Control
    self.pageControl.currentPageIndicatorTintColor = ThemeColor(kELOrangeColor);
}

#pragma mark - Protocol Methods (ELDetailViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    [self.indicatorView stopAnimating];
    
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELDetailsPageLoadError", nil)
                     completion:nil];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    ELSurvey *survey;
    NSMutableArray *mReportKeys = [[NSMutableArray alloc] init];
    
    self.responseDict = responseDict;
    self.navigatorView.hidden = NO;
    
    [self.indicatorView stopAnimating];
    
    if (self.selectedObject && [self.selectedObject isKindOfClass:[ELSurvey class]]) {
        survey = (ELSurvey *)self.selectedObject;
    }

    if (survey && survey.answered == 0) {
        self.noDataView.hidden = NO;
        
        [self setupContent];
        [self setupNavigators];
        
        return;
    }
    
    for (NSString *key in responseDict.allKeys) {
        if ([@[@"_links", @"frequencies", @"average", @"ioc", @"totalAnswers"] containsObject:key]) {
            continue;
        }
        
        if ([key isEqualToString:@"blindspot"]) {
            [mReportKeys addObject:@"blindspot.overestimated"];
            [mReportKeys addObject:@"blindspot.underestimated"];
            
            continue;
        }
        
        if ([key isEqualToString:@"highestLowestIndividual"]) {
            for (NSString *key in [[responseDict valueForKeyPath:@"highestLowestIndividual.highest"] allKeys]) {
                [mReportKeys addObject:Format(@"highestLowestIndividual.highest.%@", key)];
            }
            
            for (NSString *key in [[responseDict valueForKeyPath:@"highestLowestIndividual.lowest"] allKeys]) {
                [mReportKeys addObject:Format(@"highestLowestIndividual.lowest.%@", key)];
            }
            
            continue;
        }
        
        [mReportKeys addObject:key];
    }
    
    self.reportKeys = [ELUtils orderedReportKeysArray:mReportKeys];
    self.pageCount = self.reportKeys.count + 1;
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    self.pageController.delegate = self;
    
    [self addChildViewController:self.pageController];
    [self.pageView addSubview:self.pageController.view];
    [self setupPageController:self.pageController atView:self.pageView];
    
    [self setupContent];
    [self setupNavigators];
}

#pragma mark - Private Methods

- (void)changePage:(UIPageViewControllerNavigationDirection)direction {
    __kindof ELReportChildPageViewController *controller;
    
    if (self.pageIndex < 0 || self.pageIndex == self.self.pageCount) {
        return;
    }
    
    controller = self.mControllers[self.pageIndex];
    
    self.pageControl.currentPage = self.pageIndex;
    
    [self.pageController setViewControllers:@[controller]
                                  direction:direction
                                   animated:YES
                                 completion:nil];
}

- (void)setupContent {
    if ([self.selectedObject isKindOfClass:[ELInstantFeedback class]]) {
        ELInstantFeedback *instantFeedback = (ELInstantFeedback *)self.selectedObject;
        
        self.title = [NSLocalizedString(@"kELReportTitleFeedback", nil) uppercaseString];
        self.dateLabel.text = instantFeedback.dateString;
        self.infoLabel.text = Format(NSLocalizedString(@"kELReportInfoLabel", nil),
                                     @(instantFeedback.invited),
                                     @(instantFeedback.answered));
    } else {
        ELSurvey *survey = (ELSurvey *)self.selectedObject;
        
        self.title = [survey.name uppercaseString];
        self.dateLabel.text = survey.endDateString;
        self.infoLabel.text = Format(NSLocalizedString(@"kELReportInfoLabel", nil),
                                     @(survey.invited),
                                     @(survey.answered));
    }
}

- (void)setupNavigators {
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.pageCount;
    
    self.prevButton.hidden = YES;
    self.nextButton.hidden = self.pageCount == 0;
}

- (void)setupPageController:(UIPageViewController *)pageController {
    [self setupPageController:pageController atView:self.view];
}

- (void)setupPageController:(UIPageViewController *)pageController atView:(UIView *)view {
    ELReportChildPageViewController *controller;
    ELReportDetailsViewController *detailController;
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:@{@"frequencies": self.responseDict[@"frequencies"]}];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Report" bundle:nil];
    
    for (int i = 0; i < self.pageCount; i++) {
        int index;
        BOOL isValueForKeypath;
        NSString *key;
        NSArray *items;
        
        index = i == 0 ? 0 : i - 1;
        
        if (i == 1) {
            detailController = [storyboard instantiateViewControllerWithIdentifier:@"ReportDetails"];
            detailController.index = i;
            
            if ([self.selectedObject isKindOfClass:[ELSurvey class]]) {
                [mDict setObject:self.responseDict[@"average"] forKey:@"average"];
                [mDict setObject:self.responseDict[@"ioc"] forKey:@"ioc"];
            }
            
            detailController.infoDict = [mDict copy];
            detailController.selectedObject = self.selectedObject;
            
            [self.mControllers addObject:detailController];
            
            continue;
        }
        
        key = self.reportKeys[index];
        isValueForKeypath = [key containsString:@"blindspot"] || [key containsString:@"highestLowestIndividual"];
        items = isValueForKeypath ? [self.responseDict valueForKeyPath:key] : self.responseDict[key];
        
        if (items.count == 0) {
            continue;
        }
        
        controller = [storyboard instantiateViewControllerWithIdentifier:@"ReportChildPage"];
        controller.items = items;
        controller.key = self.reportKeys[index];
        
        [self.mControllers addObject:controller];
    }
    
    // Only consider report pages with actual data
    self.pageCount = self.mControllers.count;
    
    // Second loop for assigning each controller's index
    for (int i = 0; i < self.pageCount; i++) {
        __kindof ELBasePageChildViewController *controller = self.mControllers[i];
        
        controller.index = i;
    }
    
    pageController.dataSource = self;
    pageController.view.frame = view.bounds;
    pageController.view.backgroundColor = [UIColor clearColor];
    
    [pageController setViewControllers:@[self.mControllers[0]]
                             direction:UIPageViewControllerNavigationDirectionForward
                              animated:NO
                            completion:nil];
    [pageController didMoveToParentViewController:self];
}

#pragma mark - Interface Builder Actions

- (IBAction)onPrevButtonClick:(id)sender {
    self.pageIndex--;
    
    self.prevButton.hidden = self.pageIndex == 0;
    self.nextButton.hidden = NO;
    
    [self changePage:UIPageViewControllerNavigationDirectionReverse];
}

- (IBAction)onNextButtonClick:(id)sender {
    self.pageIndex++;
    
    self.prevButton.hidden = NO;
    self.nextButton.hidden = self.pageIndex == self.pageCount - 1;
    
    [self changePage:UIPageViewControllerNavigationDirectionForward];
}

@end
