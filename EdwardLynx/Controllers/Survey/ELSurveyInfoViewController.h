//
//  ELSurveyInfoViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 18/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseDetailViewController.h"

@interface ELSurveyInfoViewController : ELBaseDetailViewController<UITextViewDelegate>

@property (strong, nonatomic) NSDictionary *infoDict;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *evaluationLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end
