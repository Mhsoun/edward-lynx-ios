//
//  ELListViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 23/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELListViewController.h"

#pragma mark - Private Constants

static NSString * const kELDevPlanCellIdentifier = @"DevelopmentPlanCell";
static NSString * const kELReportCellIdentifier = @"ReportCell";
static NSString * const kELSurveyCellIdentifier = @"SurveyCell";

#pragma mark - Class Extension

@interface ELListViewController ()

@property (nonatomic, strong) __kindof ELModel *selectedModelInstance;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) ELDataProvider *provider;
@property (nonatomic, strong) ELTableDataSource *dataSource;
@property (nonatomic, strong) ELListViewManager *viewManager;

@end

@implementation ELListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewManager = [[ELListViewManager alloc] init];
    self.viewManager.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Load list type's corresponding data set
    [self loadListByType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (UITableView)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate onRowSelection:[self.provider rowObjectAtIndexPath:indexPath]];
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
    
    for (NSDictionary *detailDict in responseDict[@"items"]) {
        switch (self.listType) {
            case kELListTypeSurveys:
                emptyMessage = NSLocalizedString(@"kELSurveyEmptyMessage", nil);
                
                [mData addObject:[[ELSurvey alloc] initWithDictionary:detailDict error:nil]];
                
                break;
            case kELListTypeReports:
                emptyMessage = NSLocalizedString(@"kELReportEmptyMessage", nil);
                
                [mData addObject:[[ELInstantFeedback alloc] initWithDictionary:detailDict error:nil]];
                
                break;
            case kELListTypeDevPlan:
                emptyMessage = NSLocalizedString(@"kELDevelopmentPlanEmptyMessage", nil);
                devPlan = [[ELDevelopmentPlan alloc] initWithDictionary:detailDict error:nil];
                devPlan.urlLink = detailDict[@"_links"][@"self"][@"href"];
                
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
    [self.tableView reloadData];
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

#pragma mark - Interface Builder Actions

- (IBAction)onTabButtonClick:(id)sender {
    // Toggle tab button status
    self.allTabButton.enabled = ![self.allTabButton isEqual:sender];
    self.filterTabButton.enabled = ![self.filterTabButton isEqual:sender];
    self.sortTabButton.enabled = ![self.sortTabButton isEqual:sender];
}

@end
