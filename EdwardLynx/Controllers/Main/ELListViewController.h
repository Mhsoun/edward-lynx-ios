//
//  ELListViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 23/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"
#import "ELDataProvider.h"
#import "ELDevelopmentPlan.h"
#import "ELInstantFeedback.h"
#import "ELListViewManager.h"
#import "ELSurvey.h"
#import "ELSurveyDetailsViewController.h"
#import "ELTableDataSource.h"

typedef NS_ENUM(NSInteger, kELListType) {
    kELListTypeDevPlan,
    kELListTypeReports,
    kELListTypeSurveys
};

@interface ELListViewController : ELBaseViewController<UITableViewDelegate, ELAPIResponseDelegate>

@property (nonatomic) kELListType listType;

@property (strong, nonatomic) id<ELListViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIButton *allTabButton;
@property (weak, nonatomic) IBOutlet UIButton *filterTabButton;
@property (weak, nonatomic) IBOutlet UIButton *sortTabButton;
- (IBAction)onTabButtonClick:(id)sender;

@end
