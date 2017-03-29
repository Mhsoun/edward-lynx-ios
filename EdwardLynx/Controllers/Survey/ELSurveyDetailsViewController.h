//
//  ELSurveyDetailsViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseDetailViewController.h"

@class ELQuestionCategory;
@class ELSurvey;

@interface ELSurveyDetailsViewController : ELBaseDetailViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSInteger index;

@property (strong, nonatomic) ELQuestionCategory *category;
@property (strong, nonatomic) ELSurvey *survey;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
- (IBAction)onSubmitButtonClick:(id)sender;

- (NSArray *)formValues;

@end
