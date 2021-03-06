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
@property (nonatomic) NSInteger pageCount,
                                pageIndex,
                                nextPageIndex;
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
    self.pageCount = 0, self.pageIndex = 0, self.nextPageIndex = 0;
    self.isSurveyFinal = NO, self.saved = NO;
    self.mControllers = [[NSMutableArray alloc] init];
    self.title = [NSLocalizedString(@"kELAnswerSurveyTitle", nil) uppercaseString];
    self.stackView.hidden = YES;
    
    if (!self.survey) {
        self.responseType = kELSurveyResponseTypeDetails;
        self.detailViewManager = [[ELDetailViewManager alloc] initWithObjectId:self.objectId];
        
        // Retrieve survey details
        [self.detailViewManager processRetrievalOfSurveyDetailsForKey:self.key];
    } else {
        self.responseType = kELSurveyResponseTypeQuestions;
        self.detailViewManager = [[ELDetailViewManager alloc] initWithDetailObject:self.survey];
        self.surveyViewManager = [[ELSurveyViewManager alloc] initWithSurvey:self.survey];
        
        // Retrieve surveys questions
        [self.detailViewManager processRetrievalOfSurveyQuestionsForKey:self.key];
    }
    
    self.detailViewManager.delegate = self;
    
    // Register observer for notification
    [NotificationCenter addObserver:self
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
    
    // NOTE Save to draft on back
//    if ((self.survey && self.survey.key) &&
//        (!self.saved && self.survey.status != kELSurveyStatusCompleted)) {
//        [self.surveyViewManager processSurveyAnswerSubmissionWithFormData:@{@"key": self.survey.key,
//                                                                            @"final": @(NO),
//                                                                            @"answers": [self formItems]}];
//    }
    
    // Clear answers
    AppSingleton.mSurveyFormDict = [[NSMutableDictionary alloc] init];
    
    // Remove observer
    [NotificationCenter removeObserver:self
                                  name:kELPopupCloseNotification
                                object:nil];
}

- (void)dealloc {
    DLog(@"%@", [self class]);
}

#pragma mark - Protocol Methods (UIPageViewController)

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    __kindof ELBaseDetailViewController *controller = (__kindof ELBaseDetailViewController *)[pendingViewControllers lastObject];
    
    self.nextPageIndex = [controller index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    BOOL isLastPage;
    BOOL isCompleted = self.survey.status == kELSurveyStatusCompleted;
    
    if (completed) {
        self.pageIndex = self.nextPageIndex;
    }
    
    isLastPage = self.pageIndex == self.pageCount - 1;
    
    self.pageControl.currentPage = self.pageIndex;
    self.prevButton.hidden = self.pageIndex == 0;
    self.nextButton.hidden = isLastPage;
    self.draftsButton.hidden = self.pageIndex == 0 || isCompleted;
    self.submitButton.hidden = !isLastPage || isCompleted;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    __kindof ELBaseDetailViewController *controller = (__kindof ELBaseDetailViewController *)viewController;
    NSInteger index = [controller index];
    
    index++;
    
    if (index == self.pageCount) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    __kindof ELBaseDetailViewController *controller = (__kindof ELBaseDetailViewController *)viewController;
    NSInteger index = [controller index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    CGFloat iconSize = 15;
    UIColor *color = ThemeColor(kELOrangeColor);
    
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
    
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELDetailsPageLoadError", nil)
                     completion:nil];
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
            [self.detailViewManager processRetrievalOfSurveyQuestionsForKey:self.key];
            
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
                                                              @"type": @(question.answer.type),
                                                              @"value": question.value,
                                                              @"explanation": !question.explanation ? @"" : question.explanation}
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
            
            // Decrement badge count
            Application.applicationIconBadgeNumber--;
            
            break;
        default:
            break;
    }
}

#pragma mark - Protocol Methods (ELSurveyViewManager)

- (void)onAPIPostResponseError:(NSDictionary *)errorDict {
    NSString *message = NSLocalizedString(@"kELSurveyPostRequiredError", nil);
    
    if ([[errorDict allKeys] containsObject:@"validation_errors"] &&
        [[errorDict[@"validation_errors"] allKeys] containsObject:@"answers"]) {
        
        message = errorDict[@"validation_errors"][@"answers"][0];
    } else if (errorDict[@"message"]) {
        message = errorDict[@"message"];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        [ELUtils presentToastAtView:self.view
                            message:message
                         completion:nil];
    }];
}

- (void)onAPIPostResponseSuccess:(NSDictionary *)responseDict {
    __weak typeof(self) weakSelf = self;
    NSString *successMessage;
    
    if (self.isSurveyFinal) {
        successMessage = NSLocalizedString(@"kELSurveySubmissionSuccess", nil);
    } else {
        successMessage = NSLocalizedString(@"kELSurveySaveToDraftSuccess", nil);
    }
    
    self.saved = YES;
    
    AppSingleton.needsPageReload = YES;
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
    self.nextButton.hidden = self.mControllers.count <= 1;
    
    self.draftsButton.hidden = YES;
    self.submitButton.hidden = YES;
}

- (void)setupPageController:(UIPageViewController *)pageController {
    [self setupPageController:pageController atView:self.view];
}

- (void)setupPageController:(UIPageViewController *)pageController atView:(UIView *)view {
    ELSurveyDetailsViewController *controller;
    ELSurveyInfoViewController *infoController;
    
    for (int i = 0; i < self.pageCount; i++) {
        if (i == 0) {
            infoController = StoryboardController(@"Survey", @"SurveyInfo");
            infoController.index = i;
            infoController.infoDict = @{@"title": Format(@"%@: %@",
                                                         [ELUtils labelBySurveyType:self.survey.type],
                                                         self.survey.name),
                                        @"description": self.survey.shortDescription,
                                        @"evaluation": self.survey.evaluationText};
            infoController.pageViewController = pageController;
            
            [self.mControllers addObject:infoController];
            
            continue;
        }
        
        controller = StoryboardController(@"Survey", @"SurveyPage");
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
