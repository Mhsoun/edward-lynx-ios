//
//  ELSurveyDetailsViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseDetailViewController.h"
#import "ELDataProvider.h"
#import "ELDetailViewManager.h"
#import "ELQuestionCategory.h"
#import "ELQuestionTableViewCell.h"
#import "ELSurvey.h"
#import "ELSurveyViewManager.h"
#import "ELTableDataSource.h"

typedef NS_ENUM(NSInteger, kELSurveyResponseType) {
    kELSurveyResponseTypeDetails,
    kELSurveyResponseTypeQuestions
};

@interface ELSurveyDetailsViewController : ELBaseDetailViewController<UITableViewDataSource, UITableViewDelegate, ELAPIResponseDelegate, ELAPIPostResponseDelegate>

@property (strong, nonatomic) ELSurvey *survey;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
- (IBAction)onSubmitButtonClick:(id)sender;

@end
