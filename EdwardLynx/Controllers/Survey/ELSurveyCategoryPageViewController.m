//
//  ELSurveyCategoryPageViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 27/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurveyCategoryPageViewController.h"
#import "ELDetailViewManager.h"
#import "ELQuestionCategory.h"
#import "ELSurvey.h"
#import "ELSurveyDetailsViewController.h"
#import "ELSurveyInfoViewController.h"
#import "ELSurveyViewManager.h"

#pragma mark - Class Extension

@interface ELSurveyCategoryPageViewController ()

@property (nonatomic) BOOL isSurveyFinal, saved;
@property (nonatomic) NSInteger pageCount, pageIndex;
@property (nonatomic) kELSurveyResponseType responseType;
@property (nonatomic, strong) NSIndexPath *prevIndexPath;
@property (nonatomic, strong) NSArray<ELQuestionCategory *> *items;
@property (nonatomic, strong) NSMutableArray<__kindof ELBaseDetailViewController *> *mControllers;
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) ELDetailViewManager *detailViewManager;
@property (nonatomic, strong) ELSurveyViewManager *surveyViewManager;

@end

@implementation ELSurveyCategoryPageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.pageCount = 0, self.pageIndex = 0;
    self.isSurveyFinal = NO, self.saved = NO;
    self.mControllers = [[NSMutableArray alloc] init];
    self.title = [NSLocalizedString(@"kELAnswerSurveyTitle", nil) uppercaseString];
    self.stackView.hidden = YES;
    
    if (!self.survey) {
        self.responseType = kELSurveyResponseTypeDetails;
        self.detailViewManager = [[ELDetailViewManager alloc] initWithObjectId:self.objectId];
        
        // Retrieve survey details
        [self.detailViewManager processRetrievalOfSurveyDetails];
    } else {
        self.responseType = kELSurveyResponseTypeQuestions;
        self.detailViewManager = [[ELDetailViewManager alloc] initWithDetailObject:self.survey];
        self.surveyViewManager = [[ELSurveyViewManager alloc] initWithSurvey:self.survey];
        
        // Retrieve surveys questions
        [self.detailViewManager processRetrievalOfSurveyQuestions];
    }
    
    self.detailViewManager.delegate = self;
    
    // Register observer for notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onClosePopup:)
                                                 name:kELPopupCloseNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ((self.survey && self.survey.key) &&
        (!self.saved && self.survey.status != kELSurveyStatusCompleted)) {
        [self.surveyViewManager processSurveyAnswerSubmissionWithFormData:@{@"key": self.survey.key,
                                                                            @"final": @(NO),
                                                                            @"answers": [self formItems]}];
    }
    
    AppSingleton.mSurveyFormDict = [[NSMutableDictionary alloc] init];
    
    // Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kELPopupCloseNotification
                                                  object:nil];
}

- (void)dealloc {
    DLog(@"%@", [self class]);
}

#pragma mark - Protocol Methods (UIPageViewController)

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    __kindof ELBaseDetailViewController *controller = (__kindof ELBaseDetailViewController *)[pendingViewControllers lastObject];
    
    self.pageIndex = [controller index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    BOOL isLastPage = self.pageIndex == self.pageCount - 1;
    BOOL isCompleted = self.survey.status == kELSurveyStatusCompleted;
    
    self.pageControl.currentPage = self.pageIndex;
    self.prevButton.hidden = self.pageIndex == 0;
    self.nextButton.hidden = isLastPage;
    self.draftsButton.hidden = self.pageIndex == 0 || isCompleted;
    self.submitButton.hidden = !isLastPage || isCompleted;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    __kindof ELBaseDetailViewController *controller = (__kindof ELBaseDetailViewController *)viewController;
    NSInteger index = [controller index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    self.pageIndex = index;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    __kindof ELBaseDetailViewController *controller = (__kindof ELBaseDetailViewController *)viewController;
    NSInteger index = [controller index];
    
    index++;
    
    if (index == self.pageCount) {
        return nil;
    }
    
    self.pageIndex = index;
    
    return [self viewControllerAtIndex:index];
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    CGFloat iconSize = 15;
    UIColor *color = [[RNThemeManager sharedManager] colorForKey:kELOrangeColor];
    
    // Buttons
    self.draftsButton.hidden = YES;
    self.submitButton.hidden = YES;
    
    [self.prevButton setTintColor:color];
    [self.prevButton setImage:[FontAwesome imageWithIcon:fa_chevron_left
                                               iconColor:color
                                                iconSize:iconSize
                                               imageSize:CGSizeMake(iconSize, iconSize)]
                     forState:UIControlStateNormal];
    [self.nextButton setTintColor:color];
    [self.nextButton setImage:[FontAwesome imageWithIcon:fa_chevron_right
                                               iconColor:color
                                                iconSize:iconSize
                                               imageSize:CGSizeMake(iconSize, iconSize)]
                     forState:UIControlStateNormal];
    
    // Page Control
    self.pageControl.currentPageIndicatorTintColor = color;
}

#pragma mark - Protocol Methods (ELDetailViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    [self.indicatorView stopAnimating];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    NSMutableArray *mCategories = [[NSMutableArray alloc] init];
    
    switch (self.responseType) {
        case kELSurveyResponseTypeDetails:
            self.responseType = kELSurveyResponseTypeQuestions;
            self.survey = [[ELSurvey alloc] initWithDictionary:responseDict error:nil];
            self.surveyViewManager = [[ELSurveyViewManager alloc] initWithSurvey:self.survey];
            self.surveyViewManager.delegate = self;
            
            // Retrieve surveys questions
            [self.detailViewManager processRetrievalOfSurveyQuestions];
            
            break;
        case kELSurveyResponseTypeQuestions:
            self.stackView.hidden = NO;
            
            for (NSDictionary *categoryDict in (NSArray *)responseDict[@"items"]) {
                ELQuestionCategory *category = [[ELQuestionCategory alloc] initWithDictionary:categoryDict error:nil];
                
                [mCategories addObject:category];
                
                for (ELQuestion *question in category.questions) {
                    if (!question.value) {
                        continue;
                    }
                    
                    [AppSingleton.mSurveyFormDict setObject:@{@"question": @(question.objectId),
                                                              @"value": question.value,
                                                              @"type": @(question.answer.type)}
                                                     forKey:@(question.objectId)];
                }
            }
            
            self.items = [mCategories copy];
            self.pageCount = self.items.count + 1;
            self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                  navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                options:nil];
            self.pageController.delegate = self;
            
            [self addChildViewController:self.pageController];
            [self.pageView addSubview:self.pageController.view];
            [self setupPageController:self.pageController atView:self.pageView];
            
            [self setupNavigators];
            [self.indicatorView stopAnimating];
            
            break;
        default:
            break;
    }
}

#pragma mark - Protocol Methods (ELSurveyViewManager)

- (void)onAPIPostResponseError:(NSDictionary *)errorDict {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELSurveyPostError", nil)
                     completion:^{}];
}

- (void)onAPIPostResponseSuccess:(NSDictionary *)responseDict {
    __weak typeof(self) weakSelf = self;
    NSString *successMessage = NSLocalizedString(self.isSurveyFinal ? @"kELSurveySubmissionSuccess" :
                                                                      @"kELSurveySaveToDraftSuccess", nil);
    
    self.saved = YES;
    AppSingleton.mSurveyFormDict = [[NSMutableDictionary alloc] init];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.isSurveyFinal) {
        NSDictionary *detailsDict = @{@"title": [self.survey.name uppercaseString],
                                      @"header": NSLocalizedString(@"kELSurveyCompleteHeader", nil),
                                      @"details": NSLocalizedString(@"kELDevelopmentPlanGoalCompleteDetail", nil),
                                      @"image": @"Complete"};
        
        // Display popup
        [ELUtils displayPopupForViewController:self
                                          type:kELPopupTypeMessage
                                       details:detailsDict];
        
        return;
    }
    
    // Back to the Surveys list
    [ELUtils presentToastAtView:self.view
                        message:successMessage
                     completion:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Public Methods

- (void)setupPageController:(UIPageViewController *)pageController {
    [self setupPageController:pageController atView:self.view];
}

- (void)setupPageController:(UIPageViewController *)pageController atView:(UIView *)view {
    ELSurveyDetailsViewController *controller;
    ELSurveyInfoViewController *infoController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Survey" bundle:nil];
    
    for (int i = 0; i < self.pageCount; i++) {
        if (i == 0) {
            infoController = [storyboard instantiateViewControllerWithIdentifier:@"SurveyInfo"];
            infoController.index = i;
            infoController.infoDict = @{@"title": [NSString stringWithFormat:@"%@: %@",
                                                   [ELUtils labelBySurveyType:self.survey.type],
                                                   self.survey.name],
                                        @"description": self.survey.shortDescription,
                                        @"evaluation": self.survey.evaluationText};
            
            [self.mControllers addObject:infoController];
            
            continue;
        }
        
        controller = [storyboard instantiateViewControllerWithIdentifier:@"SurveyPage"];
        controller.index = i;
        controller.survey = self.survey;
        controller.category = self.items[i - 1];
        
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

- (__kindof ELBaseDetailViewController *)viewControllerAtIndex:(NSInteger)index {
    return self.mControllers[index];
}

#pragma mark - Private Methods

- (void)changePage:(UIPageViewControllerNavigationDirection)direction {
    BOOL isCompleted;
    __kindof ELBaseDetailViewController *controller;
    
    if (self.pageIndex < 0 || self.pageIndex == self.self.pageCount) {
        return;
    }
    
    isCompleted = self.survey.status == kELSurveyStatusCompleted;
    controller = [self viewControllerAtIndex:self.pageIndex];
    
    self.pageControl.currentPage = self.pageIndex;
    self.draftsButton.hidden = self.pageIndex == 0 || isCompleted;
    self.submitButton.hidden = !(self.pageIndex == self.pageCount - 1) || isCompleted;
    
    [self.pageController setViewControllers:@[controller]
                                  direction:direction
                                   animated:YES
                                 completion:nil];
}

- (NSArray *)formItems {
    NSMutableArray *mItems = [[NSMutableArray alloc] init];
    
    for (NSString *key in [AppSingleton.mSurveyFormDict allKeys]) {
        [mItems addObject:AppSingleton.mSurveyFormDict[key]];
    }
    
    return [mItems copy];
}

- (void)setupNavigators {
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.pageCount;
    
    self.prevButton.hidden = YES;
    self.nextButton.hidden = NO;
    
    self.draftsButton.hidden = YES;
    self.submitButton.hidden = YES;
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

- (IBAction)onSubmitButtonClick:(id)sender {
    self.isSurveyFinal = [sender isEqual:self.submitButton];
    
    // Loading alert
    [self presentViewController:[ELUtils loadingAlert]
                       animated:YES
                     completion:nil];
    
    [self.surveyViewManager processSurveyAnswerSubmissionWithFormData:@{@"key": self.survey.key,
                                                                        @"final": @(self.isSurveyFinal),
                                                                        @"answers": [self formItems]}];
}

#pragma mark - Notification

- (void)onClosePopup:(NSNotification *)notification {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
