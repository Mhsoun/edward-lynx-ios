//
//  ELSurveyDetailsViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"
#import "ELDataProvider.h"
#import "ELDetailViewManager.h"
#import "ELQuestionCategory.h"
#import "ELQuestionTableViewCell.h"
#import "ELSurvey.h"
#import "ELTableDataSource.h"

@interface ELSurveyDetailsViewController : ELBaseViewController<UITableViewDelegate, ELAPIResponseDelegate>

@property (strong, nonatomic) ELSurvey *survey;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
- (IBAction)onDoneButtonClick:(id)sender;

@end
