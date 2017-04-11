//
//  ELSurveyCategoryPageViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 27/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseDetailViewController.h"

@class ELSurvey;

typedef NS_ENUM(NSInteger, kELSurveyResponseType) {
    kELSurveyResponseTypeDetails,
    kELSurveyResponseTypeQuestions
};

@interface ELSurveyCategoryPageViewController : ELBaseDetailViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate, ELAPIPostResponseDelegate, ELAPIResponseDelegate>

@property (strong, nonatomic) ELSurvey *survey;

@property (weak, nonatomic) IBOutlet UIView *pageView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIView *navigatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *draftsButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)onPrevButtonClick:(id)sender;
- (IBAction)onNextButtonClick:(id)sender;
- (IBAction)onSubmitButtonClick:(UIButton *)sender;

@end
