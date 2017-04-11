//
//  ELListViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 23/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELListViewController.h"
#import "ELDataProvider.h"
#import "ELDevelopmentPlan.h"
#import "ELDevelopmentPlanTableViewCell.h"
#import "ELFilterSortItem.h"
#import "ELInstantFeedback.h"
#import "ELListViewManager.h"
#import "ELSurvey.h"
#import "ELSurveyDetailsViewController.h"
#import "ELTableDataSource.h"

#pragma mark - Private Constants

static NSString * const kELDevPlanCellIdentifier = @"DevelopmentPlanCell";
static NSString * const kELReportCellIdentifier = @"ReportCell";
static NSString * const kELSurveyCellIdentifier = @"SurveyCell";

#pragma mark - Class Extension

@interface ELListViewController ()

@property (nonatomic) BOOL isPaginated;
@property (nonatomic) NSInteger countPerPage,
                                page,
                                total;

@property (nonatomic, strong) NSArray *defaultListItems;
@property (nonatomic, strong) NSString *cellIdentifier, *paginationLink;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) ELDataProvider *provider;
@property (nonatomic, strong) ELTableDataSource *dataSource;
@property (nonatomic, strong) ELListViewManager *viewManager;

@end

@implementation ELListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.isPaginated = NO;
    self.viewManager = [[ELListViewManager alloc] init];
    self.viewManager.delegate = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (self.listType == kELListTypeReports) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    // Search Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onSearchTextUpdate:)
                                                 name:kELTabPageSearchNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView setHidden:YES];
    [self.indicatorView startAnimating];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Load list type's corresponding data set
    [self loadListByType];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Remove Search Notification
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kELTabPageSearchNotification
                                                  object:nil];
}

#pragma mark - Protocol Methods (UIScrollView)

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    
    if (endScrolling < scrollView.contentSize.height) {
        return;
    }
    
    if (self.total < self.countPerPage) {
        return;
    }
    
    // TODO Add UI indicator for loading of new entries
    // TODO Disabled first since not all list types have pagination support yet
    
//    self.isPaginated = YES;
//    
//    [scrollView setScrollEnabled:NO];
//    [self.viewManager processRetrievalOfPaginatedListAtLink:self.paginationLink
//                                                       page:self.page + 1];
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.provider numberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id value;
    __kindof UITableViewCell<ELConfigurableCellDelegate> *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    value = [self.provider rowObjectAtIndexPath:indexPath];
    
    if ([self.cellIdentifier isEqualToString:kELDevPlanCellIdentifier]) {
        ELDevelopmentPlanTableViewCell *devPlanCell = (ELDevelopmentPlanTableViewCell *)cell;
        
        devPlanCell.tableView = self.tableView;
        
        [devPlanCell configure:value atIndexPath:indexPath];
        
        return devPlanCell;
    }
    
    [cell configure:value atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate onRowSelection:[self.provider rowObjectAtIndexPath:indexPath]];
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    // Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    
    [self.refreshControl addTarget:self
                            action:@selector(loadListByType)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

#pragma mark - Protocol Methods (ELListViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    self.provider = [[ELDataProvider alloc] initWithDataArray:@[]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:self.cellIdentifier];
    
    [self.tableView setScrollEnabled:YES];
    [self.indicatorView stopAnimating];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    NSString *emptyMessage;
    ELDevelopmentPlan *devPlan;
    NSMutableArray *mItems = [[NSMutableArray alloc] init];
    
    // Store values
    self.countPerPage = [responseDict[@"num"] integerValue];
    self.page = [responseDict[@"pages"] integerValue];
    self.total = [responseDict[@"total"] integerValue];
    self.paginationLink = responseDict[@"_links"][@"self"][@"href"];
    
    self.tableView.separatorColor = [[RNThemeManager sharedManager] colorForKey:kELSurveySeparatorColor];
    
    switch (self.listType) {
        case kELListTypeSurveys:
            emptyMessage = NSLocalizedString(@"kELSurveyEmptyMessage", nil);
            
            self.tableView.rowHeight = 105;
            
            for (NSDictionary *detailDict in responseDict[@"surveys"][@"items"]) {
                [mItems addObject:[[ELSurvey alloc] initWithDictionary:detailDict error:nil]];
            }
            
            for (NSDictionary *detailDict in responseDict[@"feedbacks"][@"items"]) {
                [mItems addObject:[[ELInstantFeedback alloc] initWithDictionary:detailDict error:nil]];
            }
            
            break;
        case kELListTypeReports:
            emptyMessage = NSLocalizedString(@"kELReportEmptyMessage", nil);
            
            self.tableView.rowHeight = 115;
            
            for (NSDictionary *detailDict in responseDict[@"surveys"][@"items"]) {
                [mItems addObject:[[ELSurvey alloc] initWithDictionary:detailDict error:nil]];
            }
            
            for (NSDictionary *detailDict in responseDict[@"feedbacks"][@"items"]) {
                [mItems addObject:[[ELInstantFeedback alloc] initWithDictionary:detailDict error:nil]];
            }
            
            break;
        case kELListTypeDevPlan:
            emptyMessage = NSLocalizedString(@"kELDevelopmentPlanEmptyMessage", nil);
            
            self.tableView.rowHeight = 225;
            self.tableView.separatorColor = [UIColor clearColor];
            
            for (NSDictionary *detailDict in responseDict[@"items"]) {
                devPlan = [[ELDevelopmentPlan alloc] initWithDictionary:detailDict error:nil];
                devPlan.urlLink = detailDict[@"_links"][@"self"][@"href"];
                
                [mItems addObject:devPlan];
            }
            
            break;
        default:
            break;
    }
    
    self.defaultListItems = self.isPaginated ? [self.defaultListItems arrayByAddingObjectsFromArray:[mItems copy]] : [mItems copy];
    self.provider = [[ELDataProvider alloc] initWithDataArray:[self filterBySearchText:AppSingleton.searchText]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:self.cellIdentifier];
    
    [self.dataSource dataSetEmptyText:emptyMessage description:@""];
    [self.indicatorView stopAnimating];
    
    self.tableView.hidden = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = YES;
    
    [self.tableView reloadData];
    
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Notifications

- (void)onSearchTextUpdate:(NSNotification *)notification {
    self.provider = [[ELDataProvider alloc] initWithDataArray:[self filterBySearchText:AppSingleton.searchText]];
    
    [self.tableView reloadData];
}

#pragma mark - Private Methods

- (NSArray *)filterDataSet:(NSArray *)items
                  listType:(kELListType)listType
                filterType:(kELListFilter)filterType {
    NSPredicate *predicate;
    NSString *predicateString;
    
    switch (listType) {
        case kELListTypeDevPlan:
            switch (filterType) {
                case kELListFilterInProgress:
                    predicateString = @"SELF.progress > 0 && SELF.progress < 1";
                    
                    break;
                case kELListFilterCompleted:
                    predicateString = @"SELF.progress == 1";
                    
                    break;
                case kELListFilterExpired:  // TODO
                    return @[];
                    
                    break;
                default:
                    return items;
                    
                    break;
            }
            
            break;
        case kELListTypeReports:
        case kELListTypeSurveys:
            switch (filterType) {
                case kELListFilterAll:
                    return items;
                    
                    break;
                case kELListFilterInstantFeedback:
                    predicate = [NSPredicate predicateWithFormat:@"SELF isKindOfClass: %@", [ELInstantFeedback class]];
                    
                    return [items filteredArrayUsingPredicate:predicate];
                    
                    break;
                case kELListFilterLynxManagement:
                    predicate = [NSPredicate predicateWithFormat:@"SELF isKindOfClass: %@", [ELSurvey class]];
                    
                    return [items filteredArrayUsingPredicate:predicate];
                    
                    break;
                default:
                    return items;
                    
                    break;
            }
            
            break;
        default:
            return nil;
            
            break;
    }
    
    return [items filteredArrayUsingPredicate:!predicate ? [NSPredicate predicateWithFormat:predicateString] :
                                                           predicate];
}

- (NSArray *)filterBySearchText:(NSString *)searchText {
    NSPredicate *predicate;
    NSArray *filteredArray = [self filterDataSet:self.defaultListItems
                                        listType:self.listType
                                      filterType:self.listFilter];
    
    if (searchText.length == 0) {
        return filteredArray;
    }
    
    predicate = [NSPredicate predicateWithFormat:@"SELF.searchTitle CONTAINS [cd]%@", searchText];
    
    return [filteredArray filteredArrayUsingPredicate:predicate];
}

- (void)loadListByType {
    switch (self.listType) {
        case kELListTypeSurveys:
            self.cellIdentifier = kELSurveyCellIdentifier;
            [self.tableView registerNib:[UINib nibWithNibName:self.cellIdentifier bundle:nil]
                 forCellReuseIdentifier:self.cellIdentifier];
            
            [self.viewManager processRetrievalOfInstantFeedbacksAndSurveys];
            
            break;
        case kELListTypeReports:
            self.cellIdentifier = kELReportCellIdentifier;
            
            [self.tableView registerNib:[UINib nibWithNibName:self.cellIdentifier bundle:nil]
                 forCellReuseIdentifier:self.cellIdentifier];
            [self.viewManager processRetrievalOfReports];
            
            break;
        case kELListTypeDevPlan:
            self.cellIdentifier = kELDevPlanCellIdentifier;
            
            [self.tableView registerNib:[UINib nibWithNibName:self.cellIdentifier bundle:nil]
                 forCellReuseIdentifier:self.cellIdentifier];
            [self.viewManager processRetrievalOfDevelopmentPlans];
            
            break;
        default:
            break;
    }
}

@end
