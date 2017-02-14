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

static CGFloat const kELDefaultRowHeight = 100;
static CGFloat const kELSurveyRowHeight = 105;
static CGFloat const kELIconSize = 12.5f;

static NSString * const kELDevPlanCellIdentifier = @"DevelopmentPlanCell";
static NSString * const kELReportCellIdentifier = @"ReportCell";
static NSString * const kELSurveyCellIdentifier = @"SurveyCell";

#pragma mark - Class Extension

@interface ELListViewController ()

@property (nonatomic) NSInteger countPerPage,
                                page,
                                total;
@property (nonatomic, strong) NSArray *filterItems, *sortItems;
@property (nonatomic, strong) NSString *cellIdentifier;
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
    self.viewManager = [[ELListViewManager alloc] init];
    self.viewManager.delegate = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    
    // TODO Add UI indicator for loading of new entries
    
//    [scrollView setScrollEnabled:NO];
//    [self.viewManager processRetrievalOfPaginatedSurveysAtPage:self.page + 1];
}

#pragma mark - Protocol Methods (UITableView)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate onRowSelection:[self.provider rowObjectAtIndexPath:indexPath]];
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    // Buttons
    [self.allTabButton setTitleColor:[[RNThemeManager sharedManager] colorForKey:kELOrangeColor]
                            forState:UIControlStateNormal];
    [self.filterTabButton setImage:[FontAwesome imageWithIcon:fa_filter
                                                    iconColor:nil
                                                     iconSize:kELIconSize
                                                    imageSize:CGSizeMake(kELIconSize, kELIconSize)]
                          forState:UIControlStateNormal];
    [self.sortTabButton setImage:[FontAwesome imageWithIcon:fa_sort
                                                  iconColor:nil
                                                   iconSize:kELIconSize
                                                  imageSize:CGSizeMake(kELIconSize, kELIconSize)]
                        forState:UIControlStateNormal];
    
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
    self.filterItems = items;
    
    // TODO Handle filtering
}

- (void)onSortSelections:(NSArray *)selections allSortItems:(NSArray *)items {
    self.sortItems = items;
    
    // TODO Handle sorting
}

#pragma mark - Protocol Methods (ELListViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    self.provider = [[ELDataProvider alloc] initWithDataArray:@[]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:self.cellIdentifier];
    
    [self.indicatorView stopAnimating];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    NSString *emptyMessage;
    ELDevelopmentPlan *devPlan;
    NSMutableArray *mData = [[NSMutableArray alloc] init];
    
    // Store values
    self.countPerPage = [responseDict[@"num"] integerValue];
    self.page = [responseDict[@"pages"] integerValue];
    self.total = [responseDict[@"total"] integerValue];
    
    for (NSDictionary *detailDict in responseDict[@"items"]) {
        switch (self.listType) {
            case kELListTypeSurveys:
                emptyMessage = NSLocalizedString(@"kELSurveyEmptyMessage", nil);
                
                self.tableView.rowHeight = kELSurveyRowHeight;
                
                [mData addObject:[[ELSurvey alloc] initWithDictionary:detailDict error:nil]];
                
                break;
            case kELListTypeReports:
                emptyMessage = NSLocalizedString(@"kELReportEmptyMessage", nil);
                
                self.tableView.rowHeight = kELDefaultRowHeight;
                
                [mData addObject:[[ELInstantFeedback alloc] initWithDictionary:detailDict error:nil]];
                
                break;
            case kELListTypeDevPlan:
                emptyMessage = NSLocalizedString(@"kELDevelopmentPlanEmptyMessage", nil);
                devPlan = [[ELDevelopmentPlan alloc] initWithDictionary:detailDict error:nil];
                devPlan.urlLink = detailDict[@"_links"][@"self"][@"href"];
                
                self.tableView.rowHeight = kELDefaultRowHeight;
                
                [mData addObject:devPlan];
                
                break;
            default:
                break;
        }
        
    }
    
    self.provider = [[ELDataProvider alloc] initWithDataArray:[self filterList:mData]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:self.cellIdentifier];
    
    [self.dataSource dataSetEmptyText:emptyMessage description:@""];
    [self.indicatorView stopAnimating];
    [self.tableView setDelegate:self];
    [self.tableView setHidden:NO];
    [self.tableView reloadData];
    
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Private Methods

- (NSArray *)filterList:(__kindof NSArray *)list {
    return [list copy];  // TEMP
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

- (NSArray *)sortList:(__kindof NSArray *)list {
    return [list copy];  // TEMP
}

- (BOOL)toggleTabButton:(UIButton *)button basedOnSelection:(id)sender {
    BOOL isEqual = [button isEqual:sender];
    
    [button setTintColor:[[RNThemeManager sharedManager] colorForKey:isEqual ? kELOrangeColor : kELTextFieldBGColor]];
    [button setTitleColor:[[RNThemeManager sharedManager] colorForKey:isEqual ? kELOrangeColor : kELTextFieldBGColor]
                 forState:UIControlStateNormal];
    
    return isEqual;
}

#pragma mark - Interface Builder Actions

- (IBAction)onTabButtonClick:(id)sender {
    NSArray *items;
    
    // Toggle tab button status
    BOOL isAllSelected = [self toggleTabButton:self.allTabButton basedOnSelection:sender];
    BOOL isFilterSelected = [self toggleTabButton:self.filterTabButton basedOnSelection:sender];
    BOOL isSortSelected = [self toggleTabButton:self.sortTabButton basedOnSelection:sender];
        
    if (isAllSelected) {
        // TODO
    } else if (isFilterSelected) {
        items = self.filterItems ? self.filterItems : @[[[ELFilterSortItem alloc] initWithDictionary:@{@"title": @"Completed",
                                                                                                       @"selected": @NO}
                                                                                               error:nil],
                                                        [[ELFilterSortItem alloc] initWithDictionary:@{@"title": @"Unfinished",
                                                                                                       @"selected": @NO}
                                                                                               error:nil],
                                                        [[ELFilterSortItem alloc] initWithDictionary:@{@"title": @"Expired",
                                                                                                       @"selected": @NO}
                                                                                               error:nil]];
        
        [ELUtils displayPopupForViewController:self
                                          type:kELPopupTypeList
                                       details:@{@"type": @"filter", @"items": items}];
    } else if (isSortSelected) {
        items = self.sortItems ? self.sortItems : @[[[ELFilterSortItem alloc] initWithDictionary:@{@"title": @"A-Z/Z-A",
                                                                                                   @"selected": @NO}
                                                                                           error:nil]];
        
        [ELUtils displayPopupForViewController:self
                                          type:kELPopupTypeList
                                       details:@{@"type": @"sort", @"items": items}];
    }
}

@end
