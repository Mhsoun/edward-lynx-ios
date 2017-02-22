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

@property (nonatomic) BOOL isPaginated;
@property (nonatomic) NSInteger countPerPage,
                                page,
                                total;
@property (nonatomic, strong) NSArray *filterItems,
                                      *initialFilterItems,
                                      *sortItems,
                                      *initialSortItems,
                                      *defaultListItems;
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
    self.isPaginated = NO;
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
    
    if (self.total < self.countPerPage) {
        return;
    }
    
    // TODO Add UI indicator for loading of new entries
    
    self.isPaginated = YES;
    
    [scrollView setScrollEnabled:NO];
    [self.viewManager processRetrievalOfPaginatedSurveysAtPage:self.page + 1];
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
    
    for (NSDictionary *detailDict in responseDict[@"items"]) {
        switch (self.listType) {
            case kELListTypeSurveys:
                emptyMessage = NSLocalizedString(@"kELSurveyEmptyMessage", nil);
                
                self.tableView.rowHeight = kELSurveyRowHeight;
                self.initialFilterItems = @[[[ELFilterSortItem alloc] initWithDictionary:@{@"title": @"Completed",
                                                                                           @"key": [NSString stringWithFormat:@"SELF.status == %ld", kELSurveyStatusComplete],
                                                                                           @"selected": @NO}
                                                                                   error:nil],
                                            [[ELFilterSortItem alloc] initWithDictionary:@{@"title": @"Not Invited",
                                                                                           @"key": [NSString stringWithFormat:@"SELF.status == %ld", kELSurveyStatusNotInvited],
                                                                                           @"selected": @NO}
                                                                                   error:nil],
                                            [[ELFilterSortItem alloc] initWithDictionary:@{@"title": @"Unfinished",
                                                                                           @"key": [NSString stringWithFormat:@"SELF.status == %ld", kELSurveyStatusPartial],
                                                                                           @"selected": @NO}
                                                                                   error:nil]];
                self.initialSortItems = @[[[ELFilterSortItem alloc] initWithDictionary:@{@"title": @"Z-A/A-Z",
                                                                                         @"key": @"name",
                                                                                         @"selected": @NO}
                                                                                 error:nil]];
                
                [mItems addObject:[[ELSurvey alloc] initWithDictionary:detailDict error:nil]];
                
                break;
            case kELListTypeReports:
                emptyMessage = NSLocalizedString(@"kELReportEmptyMessage", nil);
                
                self.tableView.rowHeight = kELDefaultRowHeight;
                self.initialFilterItems = @[];  // TEMP Still needs to determine filter parameters
                self.initialSortItems = @[];  // TEMP Still needs to determine sort parameters
                
                [mItems addObject:[[ELInstantFeedback alloc] initWithDictionary:detailDict error:nil]];
                
                break;
            case kELListTypeDevPlan:
                emptyMessage = NSLocalizedString(@"kELDevelopmentPlanEmptyMessage", nil);
                devPlan = [[ELDevelopmentPlan alloc] initWithDictionary:detailDict error:nil];
                devPlan.urlLink = detailDict[@"_links"][@"self"][@"href"];
                
                self.tableView.rowHeight = kELDefaultRowHeight;
                self.initialFilterItems = @[[[ELFilterSortItem alloc] initWithDictionary:@{@"title": @"Completed",
                                                                                           @"key": @"SELF.completed == YES",
                                                                                           @"selected": @NO}
                                                                                   error:nil],
                                            [[ELFilterSortItem alloc] initWithDictionary:@{@"title": @"Not Completed",
                                                                                           @"key": @"SELF.completed == NO",
                                                                                           @"selected": @NO}
                                                                                   error:nil]];
                self.initialSortItems = @[[[ELFilterSortItem alloc] initWithDictionary:@{@"title": @"Z-A/A-Z",
                                                                                         @"key": @"name",
                                                                                         @"selected": @NO}
                                                                                 error:nil]];
                
                [mItems addObject:devPlan];
                
                break;
            default:
                break;
        }
        
    }
    
    self.defaultListItems = self.isPaginated ? [self.defaultListItems arrayByAddingObjectsFromArray:[mItems copy]] : [mItems copy];
    self.provider = [[ELDataProvider alloc] initWithDataArray:self.defaultListItems];
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
    BOOL isAllSelected, isFilterSelected;
    
    if (self.popupViewController) {
        return;
    }
    
    isAllSelected = [self toggleTabButton:self.allTabButton basedOnSelection:sender];
    isFilterSelected = [self toggleTabButton:self.filterTabButton basedOnSelection:sender];
    
    [self toggleTabButton:self.sortTabButton basedOnSelection:sender];
    
    if (isAllSelected) {
        // TODO
    } else if (isFilterSelected) {
        items = isFilterSelected ? (self.filterItems ? self.filterItems : self.initialFilterItems) :
                                   (self.sortItems ? self.sortItems : self.initialSortItems);
        
        self.allTabButton.enabled = NO;
        self.filterTabButton.enabled = NO;
        self.sortTabButton.enabled = NO;
        
        [ELUtils displayPopupForViewController:self
                                          type:kELPopupTypeList
                                       details:@{@"type": isFilterSelected ? @"filter" : @"sort",
                                                 @"items": items}];
    }
}

@end
