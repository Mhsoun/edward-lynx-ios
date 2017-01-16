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
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ELAppSingleton sharedInstance].instantFeedbacks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELInstantFeedback *feedback;
    ELQuestion *question;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier];
    
    feedback = [ELAppSingleton sharedInstance].instantFeedbacks[indexPath.row];
    question = feedback.questions[0];
    cell.textLabel.text = question.text;
    cell.detailTextLabel.text = [ELUtils labelByAnswerType:question.answer.type];
    
    return cell;
}

@end
