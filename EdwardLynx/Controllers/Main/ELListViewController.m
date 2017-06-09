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

@property (nonatomic) BOOL isPaginated, isUpdated;
@property (nonatomic) NSInteger countPerPage,
                                page,
                                pages,
                                total;
@property (nonatomic, strong) NSArray *defaultListItems;
@property (nonatomic, strong) NSString *cellIdentifier, *paginationLink;
@property (nonatomic, strong) UIActivityIndicatorView *tableIndicatorView;
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
    self.page = 1;
    self.isPaginated = NO;
    self.isUpdated = NO;
    
    self.viewManager = [[ELListViewManager alloc] init];
    self.viewManager.delegate = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                        CGRectGetWidth(self.tableView.frame),
                                                                                        50)];
    self.tableIndicatorView.hidesWhenStopped = YES;
    
    if (self.listType == kELListTypeReports) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    [self reloadPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if (AppSingleton.needsPageReload) {
        self.isUpdated = AppSingleton.needsPageReload;
        
        [self reloadPage];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Search Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onSearchTextUpdate:)
                                                 name:kELTabPageSearchNotification
                                               object:nil];
    
    if (self.listType == kELListTypeSurveys) {
        // Toggle Add Button Notification
        [[NSNotificationCenter defaultCenter] postNotificationName:kELInstantFeedbackTabNotification
                                                            object:nil
                                                          userInfo:@{@"hidden": @(self.listFilter != kELListFilterInstantFeedback)}];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // To handle updating of Dashboard
    AppSingleton.needsPageReload = self.isUpdated;
    
    // Remove Search Notification
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kELTabPageSearchNotification
                                                  object:nil];
}

- (void)dealloc {
    DLog(@"%@", [self class]);
    
    AppSingleton.searchText = @"";
}

#pragma mark - Protocol Methods (UIScrollView)

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    BOOL atBottom, isContentLarger;
    CGFloat scrollHeight, viewableHeight;
    
    if (self.listType != kELListTypeSurveys) {
        return;
    }
    
    scrollHeight = CGRectGetHeight(scrollView.frame);
    isContentLarger = scrollView.contentSize.height > scrollHeight;
    viewableHeight = isContentLarger ? scrollHeight : scrollView.contentSize.height;
    atBottom = (scrollView.contentOffset.y >= scrollView.contentSize.height - viewableHeight + CGRectGetHeight(self.tableIndicatorView.frame));
    
    if (atBottom && ![self.tableView.tableFooterView isEqual:self.tableIndicatorView] && !(self.page > self.pages)) {
        self.page++;
        
        self.isPaginated = YES;
        self.tableView.tableFooterView = self.tableIndicatorView;
        
        [scrollView setScrollEnabled:NO];
        [self.tableIndicatorView startAnimating];
        [self.viewManager processRetrievalOfPaginatedListAtLink:self.paginationLink page:self.page];
    }
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.provider numberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id value;
    ELDevelopmentPlanTableViewCell *devPlanCell;
    __kindof UITableViewCell<ELConfigurableCellDelegate> *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    value = [self.provider rowObjectAtIndexPath:indexPath];
    
    if ([self.cellIdentifier isEqualToString:kELDevPlanCellIdentifier]) {
        devPlanCell = (ELDevelopmentPlanTableViewCell *)cell;
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
    NSDictionary *surveyDict;
    ELDevelopmentPlan *devPlan;
    NSMutableArray *mItems = [[NSMutableArray alloc] init];
    
    self.tableView.separatorColor = ThemeColor(kELSurveySeparatorColor);
    
    switch (self.listType) {
        case kELListTypeSurveys:
            surveyDict = responseDict[@"surveys"];
            emptyMessage = NSLocalizedString(@"kELSurveyEmptyMessage", nil);
            
            self.tableView.rowHeight = 105;
            
            if (!surveyDict) {
                for (NSDictionary *detailDict in responseDict[@"items"]) {
                    if (self.listFilter == kELListFilterInstantFeedback) {
                        [mItems addObject:[[ELInstantFeedback alloc] initWithDictionary:detailDict error:nil]];
                    } else {
                        [mItems addObject:[[ELSurvey alloc] initWithDictionary:detailDict error:nil]];
                    }
                }
                
                // Store values
                self.countPerPage = [responseDict[@"num"] integerValue];
                self.pages = [responseDict[@"pages"] integerValue];
                self.total = [responseDict[@"total"] integerValue];
                self.paginationLink = responseDict[@"_links"][@"self"][@"href"];
                
                break;
            }
            
            for (NSDictionary *detailDict in surveyDict[@"items"]) {
                [mItems addObject:[[ELSurvey alloc] initWithDictionary:detailDict error:nil]];
            }
            
            for (NSDictionary *detailDict in responseDict[@"feedbacks"][@"items"]) {
                [mItems addObject:[[ELInstantFeedback alloc] initWithDictionary:detailDict error:nil]];
            }
            
            // Store values
            self.countPerPage = [surveyDict[@"num"] integerValue];
            self.pages = [surveyDict[@"pages"] integerValue];
            self.total = [surveyDict[@"total"] integerValue];
            self.paginationLink = surveyDict[@"_links"][@"self"][@"href"];
            
            break;
        case kELListTypeReports:
            surveyDict = responseDict[@"surveys"];
            emptyMessage = NSLocalizedString(@"kELReportEmptyMessage", nil);
            
            self.tableView.rowHeight = 125;
            
            if (!surveyDict) {
                for (NSDictionary *detailDict in responseDict[@"items"]) {
                    [mItems addObject:[[ELSurvey alloc] initWithDictionary:detailDict error:nil]];
                }
                
                // Store values
                self.countPerPage = [responseDict[@"num"] integerValue];
                self.pages = [responseDict[@"pages"] integerValue];
                self.total = [responseDict[@"total"] integerValue];
                self.paginationLink = responseDict[@"_links"][@"self"][@"href"];
                
                break;
            }
            
            for (NSDictionary *detailDict in responseDict[@"surveys"][@"items"]) {
                [mItems addObject:[[ELSurvey alloc] initWithDictionary:detailDict error:nil]];
            }
            
            for (NSDictionary *detailDict in responseDict[@"feedbacks"][@"items"]) {
                [mItems addObject:[[ELInstantFeedback alloc] initWithDictionary:detailDict error:nil]];
            }
            
            // Store values
            self.countPerPage = [surveyDict[@"num"] integerValue];
            self.pages = [surveyDict[@"pages"] integerValue];
            self.total = [surveyDict[@"total"] integerValue];
            self.paginationLink = responseDict[@"surveys"][@"_links"][@"self"][@"href"];
            
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
    
    if (self.isPaginated) {
        self.tableView.tableFooterView = nil;
        self.isPaginated = NO;
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
                case kELListFilterLynxMeasurement:
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
            
            switch (self.listFilter) {
                case kELListFilterAll:
                    [self.viewManager processRetrievalOfInstantFeedbacksAndSurveys];
                    
                    break;
                case kELListFilterInstantFeedback:
                    [self.viewManager processRetrievalOfInstantFeedbacks];
                    
                    break;
                case kELListFilterLynxMeasurement:
                    [self.viewManager processRetrievalOfSurveys];
                    
                    break;
                default:
                    break;
            }
            
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

- (void)reloadPage {
    // Prepare for loading
    [self.tableView setHidden:YES];
    [self.indicatorView startAnimating];
    
    // Load list type's corresponding data set
    [self loadListByType];
    
    AppSingleton.needsPageReload = NO;
}

@end
