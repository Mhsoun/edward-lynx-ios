//
//  ELSurveysViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurveysViewController.h"

#pragma mark - Private Constants

static NSString * const kELSurveySegueIdentifier = @"SurveyDetails";

#pragma mark - Class Extension

@interface ELSurveysViewController ()

@property (nonatomic, strong) NSArray *tabs;

@end

@implementation ELSurveysViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.tabs = @[@(kELListFilterAll),
                  @(kELListFilterUnfinished),
                  @(kELListFilterComplete)];
    
    [self setupSlideView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kELSurveySegueIdentifier]) {
        ELSurveyDetailsViewController *controller = [segue destinationViewController];
        
        controller.survey = self.selectedSurvey;
    }
}

#pragma mark - Protocol Methods (ELListViewController)

- (void)onRowSelection:(__kindof ELModel *)object {
    self.selectedSurvey = (ELSurvey *)object;
    
    [self performSegueWithIdentifier:kELSurveySegueIdentifier sender:self];
}

#pragma mark - Protocol Methods (DYSlideView)

- (NSInteger)DY_numberOfViewControllersInSlideView {
    return self.tabs.count;
}

- (NSString *)DY_titleForViewControllerAtIndex:(NSInteger)index {
    return [[ELUtils labelByListFilter:[self.tabs[index] integerValue]] uppercaseString];
}

- (UIViewController *)DY_viewControllerAtIndex:(NSInteger)index {
    ELListViewController *controller = [[UIStoryboard storyboardWithName:@"List" bundle:nil]
                                        instantiateInitialViewController];
    
    controller.delegate = self;
    controller.listType = kELListTypeSurveys;
    controller.listFilter = [self.tabs[index] integerValue];
    
    return controller;
}

#pragma mark - Private Methods

- (void)setupSlideView {
    self.slideView.delegate = self;
    self.slideView.slideBarColor = [UIColor clearColor];
    self.slideView.slideBarHeight = 40;
    
    self.slideView.sliderColor = [UIColor clearColor];
    self.slideView.sliderHeight = 0;
    self.slideView.sliderScale = 0;
    
    self.slideView.buttonNormalColor = [UIColor whiteColor];
    self.slideView.buttonSelectedColor = [UIColor orangeColor];
    self.slideView.buttonTitleFont = [UIFont fontWithName:@"Lato-Bold" size:13];
    
    self.slideView.scrollEnabled = YES;
    self.slideView.scrollViewBounces = YES;
    self.slideView.indexForDefaultItem = @0;
}

@end
