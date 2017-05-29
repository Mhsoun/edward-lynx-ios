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
@property (nonatomic, strong) NSMutableArray *mControllers, *mReportKeys;
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
    self.mReportKeys = [[NSMutableArray alloc] init];
    
    self.viewManager = [[ELDetailViewManager alloc] initWithDetailObject:self.selectedObject];
    self.viewManager.delegate = self;
    
    [self.viewManager processRetrievalOfReportDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if ([self.selectedObject isKindOfClass:[ELInstantFeedback class]]) {
        ELInstantFeedback *instantFeedback = (ELInstantFeedback *)self.selectedObject;
        
        self.title = [NSLocalizedString(@"kELReportTitleFeedback", nil) uppercaseString];
        self.dateLabel.text = instantFeedback.dateString;
        self.infoLabel.text = [NSString stringWithFormat:NSLocalizedString(@"kELReportInfoLabel", nil),
                               @(instantFeedback.invited),
                               @(instantFeedback.answered)];
    } else {
        ELSurvey *survey = (ELSurvey *)self.selectedObject;
        
        self.title = [survey.name uppercaseString];
        self.dateLabel.text = survey.endDateString;
        self.infoLabel.text = [NSString stringWithFormat:NSLocalizedString(@"kELReportInfoLabel", nil),
                               @(survey.invited),
                               @(survey.answered)];
    }
}

#pragma mark - Protocol Methods (ELDetailViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    [self.indicatorView stopAnimating];
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELDetailsPageLoadError", nil)
                     completion:nil];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    [self.indicatorView stopAnimating];
    
    DLog(@"%@", responseDict);
    
    self.responseDict = responseDict;
    
    for (NSString *key in responseDict.allKeys) {
        if ([@[@"_links", @"comments", @"frequencies", @"average", @"ioc", @"totalAnswers"] containsObject:key]) {
            continue;
        }
        
        if ([key isEqualToString:@"blindspot"]) {
            [self.mReportKeys addObject:@"blindspot.overestimated"];
            [self.mReportKeys addObject:@"blindspot.underestimated"];
            
            continue;
        }
        
        [self.mReportKeys addObject:key];
    }
    
    self.pageCount = self.mReportKeys.count + 1;
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    self.pageController.delegate = self;
    
    [self addChildViewController:self.pageController];
    [self.pageView addSubview:self.pageController.view];
    [self setupPageController:self.pageController atView:self.pageView];
}

#pragma mark - Private Methods

- (void)setupPageController:(UIPageViewController *)pageController {
    [self setupPageController:pageController atView:self.view];
}

- (void)setupPageController:(UIPageViewController *)pageController atView:(UIView *)view {
    ELReportChildPageViewController *controller;
    ELReportDetailsViewController *detailController;
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:@{@"frequencies": self.responseDict[@"frequencies"]}];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Report" bundle:nil];
    
    for (int i = 0; i < self.pageCount; i++) {
        NSString *key;
        
        if (i == 0) {
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
        
        key = self.mReportKeys[i - 1];
        
        controller = [storyboard instantiateViewControllerWithIdentifier:@"ReportChildPage"];
        controller.index = i;
        controller.items = [key containsString:@"blindspot"] ? [self.responseDict valueForKeyPath:key] : self.responseDict[key];
        controller.key = self.mReportKeys[i - 1];
        
        [self.mControllers addObject:controller];
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

@end
