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

@property (nonatomic, strong) ELInstantFeedback *selectedFeedback;
@property (nonatomic, strong) ELTableDataSource *dataSource;
@property (nonatomic, strong) ELDataProvider<ELInstantFeedback *> *provider;

@end

@implementation ELInstantFeedbacksViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.provider = [[ELDataProvider alloc] initWithDataArray:[ELAppSingleton sharedInstance].instantFeedbacks];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.dataSource dataSetEmptyText:@"No Instant Feedbacks"
                          description:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AnswerInstantFeedback"]) {
        ELAnswerInstantFeedbackViewController *controller = (ELAnswerInstantFeedbackViewController *)[segue destinationViewController];
        controller.feedback = self.selectedFeedback;
    }
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
    self.selectedFeedback = (ELInstantFeedback *)[self.provider objectAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"AnswerInstantFeedback" sender:self];
}

@end
