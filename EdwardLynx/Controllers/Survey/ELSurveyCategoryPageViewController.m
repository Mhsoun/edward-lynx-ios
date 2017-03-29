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
#import "ELSurveyViewManager.h"

@interface ELSurveyCategoryPageViewController ()

@property (nonatomic) BOOL isSurveyFinal;
@property (nonatomic) kELSurveyResponseType responseType;
@property (nonatomic, strong) NSArray<ELQuestionCategory *> *items;
@property (nonatomic, strong) NSIndexPath *prevIndexPath;
@property (nonatomic, strong) NSMutableArray<ELSurveyDetailsViewController *> *mControllers;
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) ELDetailViewManager *detailViewManager;
@property (nonatomic, strong) ELSurveyViewManager *surveyViewManager;

@end

@implementation ELSurveyCategoryPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.mControllers = [[NSMutableArray alloc] init];
    
    if (!self.survey) {
        self.responseType = kELSurveyResponseTypeDetails;
        self.detailViewManager = [[ELDetailViewManager alloc] initWithObjectId:self.objectId];
        
        // Retrieve survey details
        [self.detailViewManager processRetrievalOfSurveyDetails];
    } else {
        self.title = [self.survey.name uppercaseString];
        self.responseType = kELSurveyResponseTypeQuestions;
        self.detailViewManager = [[ELDetailViewManager alloc] initWithDetailObject:self.survey];
        self.surveyViewManager = [[ELSurveyViewManager alloc] initWithSurvey:self.survey];
        
        // Retrieve surveys questions
        [self.detailViewManager processRetrievalOfSurveyQuestions];
    }
    
    self.detailViewManager.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (UIPageControl)

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [(ELSurveyDetailsViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [(ELSurveyDetailsViewController *)viewController index];
    
    index++;
    
    if (index == self.items.count) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    CGFloat iconSize = 15;
    UIColor *color = [[RNThemeManager sharedManager] colorForKey:kELOrangeColor];
    
    // Buttons
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
}

#pragma mark - Protocol Methods (ELDetailViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    [self.indicatorView stopAnimating];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    NSMutableArray *mCategories = [[NSMutableArray alloc] init];
    
    switch (self.responseType) {
        case kELSurveyResponseTypeDetails:
            self.survey = [[ELSurvey alloc] initWithDictionary:responseDict error:nil];
            self.surveyViewManager = [[ELSurveyViewManager alloc] initWithSurvey:self.survey];
            self.responseType = kELSurveyResponseTypeQuestions;
            
            // Retrieve surveys questions
            [self.detailViewManager processRetrievalOfSurveyQuestions];
            
            break;
        case kELSurveyResponseTypeQuestions:
            self.title = [self.survey.name uppercaseString];
            
            for (NSDictionary *categoryDict in (NSArray *)responseDict[@"items"]) {
                [mCategories addObject:[[ELQuestionCategory alloc] initWithDictionary:categoryDict error:nil]];
            }
            
            self.items = [mCategories copy];
            self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                  navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                options:nil];
            
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
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELSurveyPostError", nil)
                     completion:^{}];
}

- (void)onAPIPostResponseSuccess:(NSDictionary *)responseDict {
    NSString *successMessage = NSLocalizedString(self.isSurveyFinal ? @"kELSurveySubmissionSuccess" :
                                                                      @"kELSurveySaveToDraftSuccess", nil);
    
    // Back to the Surveys list
    [ELUtils presentToastAtView:self.view
                        message:successMessage
                     completion:^{
                         [self.navigationController popViewControllerAnimated:YES];
                     }];
}

#pragma mark - Public Methods

- (void)setupPageController:(UIPageViewController *)pageController {
    [self setupPageController:pageController atView:self.view];
}

- (void)setupPageController:(UIPageViewController *)pageController atView:(UIView *)view {
    ELSurveyDetailsViewController *controller;
    
    for (int i = 0; i < self.items.count; i++) {
        controller = [[UIStoryboard storyboardWithName:@"Survey" bundle:nil]
                      instantiateViewControllerWithIdentifier:@"SurveyDetails"];
        controller.index = i;
        controller.survey = self.survey;
        controller.category = self.items[i];
        
        [self.mControllers addObject:controller];
    }
    
    pageController.dataSource = self;
    pageController.view.frame = view.bounds;
    pageController.view.backgroundColor = [UIColor clearColor];
    
    [pageController setViewControllers:[self.mControllers copy]
                             direction:UIPageViewControllerNavigationDirectionForward
                              animated:NO
                            completion:nil];
    [pageController didMoveToParentViewController:self];
}

- (ELSurveyDetailsViewController *)viewControllerAtIndex:(NSInteger)index {
    return self.mControllers[index];
}

#pragma mark - Private Methods

- (void)setupNavigators {
    if (self.items.count > 1) {
        self.pageControl.numberOfPages = self.items.count;
        self.pageControl.currentPage = 0;
        
    }
    
    self.prevButton.hidden = self.items.count <= 1;
    self.pageControl.hidden = self.items.count <= 1;
    self.nextButton.hidden = self.items.count <= 1;
}

#pragma mark - Interface Builder Actions

- (IBAction)onPrevButtonClick:(id)sender {
    
}

- (IBAction)onNextButtonClick:(id)sender {
    
}

- (IBAction)onSubmitButtonClick:(id)sender {
    NSDictionary *formDict;
    NSMutableArray *mItems = [[NSMutableArray alloc] init];
    
    for (ELSurveyDetailsViewController *controller in self.mControllers) {
        [mItems addObject:[controller formValues]];
    }
    
    formDict = @{@"key": self.survey.key,
                 @"final": @(self.isSurveyFinal),
                 @"answers": [mItems copy]};
    
    if (!self.isSurveyFinal) {
        [self.surveyViewManager processSurveyAnswerSubmissionWithFormData:formDict];
    } else {
        // TODO Validate first before submission
//        if (mAnswers.count == [self.tableView numberOfRowsInSection:0] && self.survey.key) {
//            [self.surveyViewManager processSurveyAnswerSubmissionWithFormData:formDict];
//        }
    }
}

@end
