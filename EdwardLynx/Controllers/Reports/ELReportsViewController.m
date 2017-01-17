//
//  ELReportsViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELReportsViewController.h"

#pragma mark - Private Constants

static NSString * const kELCellIdentifier = @"ReportCell";

#pragma mark - Class Extension

@interface ELReportsViewController ()

@property (nonatomic, strong) ELTableDataSource *dataSource;
@property (nonatomic, strong) ELListViewManager *viewManager;
@property (nonatomic, strong) ELDataProvider<NSString *> *provider;

@end

@implementation ELReportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.viewManager = [[ELListViewManager alloc] init];
    self.viewManager.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // Retrieve surveys
    [self.viewManager processRetrievalOfReports];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.provider numberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELInstantFeedback *feedback;
    ELQuestion *question;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier];
    
    feedback = [ELAppSingleton sharedInstance].instantFeedbacks[indexPath.row];
    question = feedback.question;
    cell.textLabel.text = question.text;
    cell.detailTextLabel.text = [ELUtils labelByAnswerType:question.answer.type];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    self.selectedFeedback = (ELInstantFeedback *)[self.provider objectAtIndexPath:indexPath];
    
//    [self performSegueWithIdentifier:@"AnswerInstantFeedback" sender:self];
}

#pragma mark - Protocol Methods (ELListViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    self.provider = [[ELDataProvider alloc] initWithDataArray:@[]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    
    [self.indicatorView stopAnimating];
    [self.dataSource dataSetEmptyText:@"Failed to retrieve Reports"
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
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView reloadData];
    [self.dataSource dataSetEmptyText:@"No Reports"
                          description:@""];
}

@end
