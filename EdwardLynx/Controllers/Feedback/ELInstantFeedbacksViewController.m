//
//  ELInstantFeedbacksViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELInstantFeedbacksViewController.h"

#pragma mark - Private Constants

static NSString * const kELCellIdentifier = @"InstantFeedbackCell";

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
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Retrieve Instant Feedbacks
    [self.viewManager processRetrievalOfInstantFeedbacks];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Refresh Instant Feedback items
    self.provider = [[ELDataProvider alloc] initWithDataArray:[ELAppSingleton sharedInstance].instantFeedbacks];
    
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AnswerInstantFeedback"]) {
        ELAnswerInstantFeedbackViewController *controller = (ELAnswerInstantFeedbackViewController *)[segue destinationViewController];
        controller.instantFeedback = self.selectedInstantFeedback;
    }
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.provider numberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELInstantFeedback *feedback;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier];
    
    feedback = [ELAppSingleton sharedInstance].instantFeedbacks[indexPath.row];
    cell.textLabel.text = feedback.question.text;
    cell.detailTextLabel.text = [ELUtils labelByAnswerType:feedback.question.answer.type];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedInstantFeedback = (ELInstantFeedback *)[self.provider rowObjectAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"AnswerInstantFeedback" sender:self];
}

#pragma mark - Protocol Methods (ELListViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    self.provider = [[ELDataProvider alloc] initWithDataArray:@[]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    
    [self.indicatorView stopAnimating];
    [self.dataSource dataSetEmptyText:@"Failed to retrieve Instant Feedbacks"
                          description:@"Please try again later."];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    NSMutableArray *mInstantFeedbacks = [[NSMutableArray alloc] init];
    
    for (NSDictionary *instantFeedbackDict in responseDict[@"items"]) {
        [mInstantFeedbacks addObject:[[ELInstantFeedback alloc] initWithDictionary:instantFeedbackDict error:nil]];
    }
    
    [ELAppSingleton sharedInstance].instantFeedbacks = [mInstantFeedbacks copy];
    
    self.provider = [[ELDataProvider alloc] initWithDataArray:[ELAppSingleton sharedInstance].instantFeedbacks];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    
    [self.indicatorView stopAnimating];
    [self.dataSource dataSetEmptyText:@"No Instant Feedbacks" description:@""];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView reloadData];
}

@end
