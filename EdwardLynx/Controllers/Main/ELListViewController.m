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
#import "ELFilterSortItem.h"
#import "ELInstantFeedback.h"
#import "ELListViewManager.h"
#import "ELSurvey.h"
#import "ELSurveyDetailsViewController.h"
#import "ELTableDataSource.h"

#pragma mark - Private Constants

static CGFloat const kELDefaultRowHeight = 105;
static CGFloat const kELDevPlanRowHeight = 225;

static NSString * const kELDevPlanCellIdentifier = @"DevelopmentPlanCell";
static NSString * const kELReportCellIdentifier = @"ReportCell";
static NSString * const kELSurveyCellIdentifier = @"SurveyCell";

#pragma mark - Class Extension

@interface ELListViewController ()

@property (nonatomic) BOOL isPaginated;
@property (nonatomic) NSInteger countPerPage,
                                page,
                                total;
@property (nonatomic, strong) NSArray *filterItems,
                                      *initialFilterItems,
                                      *sortItems,
                                      *initialSortItems,
                                      *defaultListItems;
@property (nonatomic, strong) NSString *cellIdentifier, *paginationLink;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) ELDataProvider *provider;
@property (nonatomic, strong) __kindof ELModel *selectedModelInstance;
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

#pragma mark - Protocol Methods (ELListPopup)

- (void)onFilterSelections:(NSArray *)selections allFilterItems:(NSArray *)items {
    NSPredicate *predicate;
    NSString *filterString = @"";
    
    self.filterItems = items;
    
    for (int i = 0; i < selections.count; i++) {
        ELFilterSortItem *item = selections[i];
        
        filterString = [filterString stringByAppendingString:item.key];
        
        if (i < selections.count - 1) {
            filterString = [filterString stringByAppendingString:@"||"];
        }
    }
    
    if (selections.count == 0) {
        [self.dataSource updateTableViewData:self.defaultListItems];
        
        return;
    }
    
    predicate = [NSPredicate predicateWithFormat:filterString];
    
    [self.dataSource updateTableViewData:[self.defaultListItems filteredArrayUsingPredicate:predicate]];
}

- (void)onSortSelections:(NSArray *)selections allSortItems:(NSArray *)items {
    NSMutableArray *mDescriptors = [[NSMutableArray alloc] init];
    
    self.sortItems = items;
    
    for (int i = 0; i < selections.count; i++) {
        ELFilterSortItem *item = selections[i];
        
        [mDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:item.key ascending:item.selected]];
    }
    
    [self.dataSource updateTableViewData:[self.defaultListItems sortedArrayUsingDescriptors:[mDescriptors copy]]];
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
    
    switch (self.listType) {
        case kELListTypeSurveys:
            emptyMessage = NSLocalizedString(@"kELSurveyEmptyMessage", nil);
            
            self.tableView.rowHeight = kELDefaultRowHeight;
            
            for (NSDictionary *detailDict in responseDict[@"items"]) {
                [mItems addObject:[[ELSurvey alloc] initWithDictionary:detailDict error:nil]];
            }
            
            break;
        case kELListTypeReports:
            emptyMessage = NSLocalizedString(@"kELReportEmptyMessage", nil);
            
            self.tableView.rowHeight = kELDefaultRowHeight;
            
            for (NSDictionary *detailDict in responseDict[@"items"]) {
                [mItems addObject:[[ELInstantFeedback alloc] initWithDictionary:detailDict error:nil]];
            }
            
            break;
        case kELListTypeDevPlan:
            emptyMessage = NSLocalizedString(@"kELDevelopmentPlanEmptyMessage", nil);
            
            self.tableView.rowHeight = kELDevPlanRowHeight;
            
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
    self.provider = [[ELDataProvider alloc] initWithDataArray:[self filteredDataSet:self.defaultListItems
                                                                           listType:self.listType
                                                                         filterType:self.listFilter]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:self.cellIdentifier];
    
    [self.dataSource dataSetEmptyText:emptyMessage description:@""];
    [self.indicatorView stopAnimating];
    [self.tableView setScrollEnabled:YES];
    [self.tableView setDelegate:self];
    [self.tableView setHidden:NO];
    [self.tableView reloadData];
    
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Private Methods

- (NSArray *)filteredDataSet:(NSArray *)items
                    listType:(kELListType)listType
                  filterType:(kELListFilter)filterType {
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
                default:
                    return items;
                    
                    break;
            }
            
            break;
        case kELListTypeReports:  // TODO
            return items;
            
            break;
        case kELListTypeSurveys:
            switch (filterType) {  // TODO
                case kELListFilterAll:
                    return items;
                    
                    break;
                case kELListFilterInstantFeedback:
                    return items;
                    
                    break;
                case kELListFilterLynxManagement:
                    return items;
                    
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
    
    return [items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicateString]];
}

- (void)loadListByType {
    switch (self.listType) {
        case kELListTypeSurveys:
            [self setCellIdentifier:kELSurveyCellIdentifier];
            [self.tableView registerNib:[UINib nibWithNibName:self.cellIdentifier bundle:nil]
                 forCellReuseIdentifier:self.cellIdentifier];
            
            [self.viewManager processRetrievalOfSurveys];
            
            break;
        case kELListTypeReports:
            [self setCellIdentifier:kELReportCellIdentifier];
            [self.tableView registerNib:[UINib nibWithNibName:self.cellIdentifier bundle:nil]
                 forCellReuseIdentifier:self.cellIdentifier];
            
            [self.viewManager processRetrievalOfReports];
            
            break;
        case kELListTypeDevPlan:
            [self setCellIdentifier:kELDevPlanCellIdentifier];
            [self.tableView registerNib:[UINib nibWithNibName:self.cellIdentifier bundle:nil]
                 forCellReuseIdentifier:self.cellIdentifier];
            
            [self.viewManager processRetrievalOfDevelopmentPlans];
            
            break;
        default:
            break;
    }
}

@end
