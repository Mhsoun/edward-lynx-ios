//
//  ELListViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 23/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"
#import "ELDataProvider.h"
#import "ELListViewManager.h"
#import "ELSurvey.h"
#import "ELSurveyDetailsViewController.h"
#import "ELTableDataSource.h"

typedef NS_ENUM(NSInteger, kELListType) {
    kELListTypeReports,
    kELListTypeSurveys
};

typedef NS_ENUM(NSInteger, kELListFilter) {
    kELListFilterAll
};

@interface ELListViewController : ELBaseViewController<UITableViewDelegate, ELAPIResponseDelegate>

@property (nonatomic) kELListType listType;
@property (nonatomic) kELListFilter listFilter;

@property (strong, nonatomic) id<ELListViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end
