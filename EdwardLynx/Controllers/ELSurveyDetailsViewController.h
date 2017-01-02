//
//  ELSurveyDetailsViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"
#import "ELDataProvider.h"
#import "ELQuestion.h"
#import "ELSurvey.h"
#import "ELTableDataSource.h"

@interface ELSurveyDetailsViewController : ELBaseViewController

@property (strong, nonatomic) ELSurvey *survey;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
