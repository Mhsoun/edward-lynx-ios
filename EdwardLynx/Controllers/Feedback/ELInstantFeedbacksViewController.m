//
//  ELInstantFeedbacksViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELInstantFeedbacksViewController.h"
#import "ELAnswerInstantFeedbackViewController.h"
#import "ELDataProvider.h"
#import "ELInstantFeedback.h"
#import "ELListViewManager.h"
#import "ELQuestion.h"
#import "ELSurveyTableViewCell.h"
#import "ELTableDataSource.h"

#pragma mark - Private Constants

static NSString * const kELCellIdentifier = @"SurveyCell";
static NSString * const kELSegueIdentifier = @"AnswerInstantFeedback";

#pragma mark - Class Extension

@interface ELInstantFeedbacksViewController ()

@property (nonatomic, strong) ELInstantFeedback *selectedInstantFeedback;
@property (nonatomic, strong) ELListViewManager *viewManager;
@property (nonatomic, strong) ELTableDataSource *dataSource;
@property (nonatomic, strong) ELDataProvider<ELInstantFeedback *> *provider;

@end

@implementation ELInstantFeedbacksViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.viewManager = [[ELListViewManager alloc] init];
    self.viewManager.delegate = self;
    
    self.tableView.rowHeight = 105;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:kELCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Refresh Instant Feedback items
    [self.tableView setHidden:YES];
    [self.indicatorView startAnimating];
    [self.viewManager processRetrievalOfInstantFeedbacks];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kELSegueIdentifier]) {
        ELAnswerInstantFeedbackViewController *controller = (ELAnswerInstantFeedbackViewController *)[segue destinationViewController];
        
        controller.instantFeedback = self.selectedInstantFeedback;
    }
}

#pragma mark - Protocol Methods (UITableView)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedInstantFeedback = (ELInstantFeedback *)[self.provider rowObjectAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:kELSegueIdentifier sender:self];
}

#pragma mark - Protocol Methods (ELListViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    self.provider = [[ELDataProvider alloc] initWithDataArray:@[]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    
    [self.tableView setHidden:NO];
    [self.indicatorView stopAnimating];
    [self.dataSource dataSetEmptyText:NSLocalizedString(@"kELFeedbacksRetrievalError", nil)
                          description:NSLocalizedString(@"kELErrorDetailsMessage", nil)];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    NSMutableArray *mInstantFeedbacks = [[NSMutableArray alloc] init];
    
    for (NSDictionary *instantFeedbackDict in responseDict[@"items"]) {
        [mInstantFeedbacks addObject:[[ELInstantFeedback alloc] initWithDictionary:instantFeedbackDict
                                                                             error:nil]];
    }
    
    self.provider = [[ELDataProvider alloc] initWithDataArray:[mInstantFeedbacks copy]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    
    [self.indicatorView stopAnimating];
    [self.dataSource dataSetEmptyText:NSLocalizedString(@"kELFeedbacksRetrievalEmpty", nil) description:@""];
    [self.tableView setHidden:NO];
    [self.tableView setDelegate:self];
    [self.tableView reloadData];
}

@end
