//
//  ELSurveyDetailsViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurveyDetailsViewController.h"
#import "ELBaseQuestionTypeView.h"
#import "ELDataProvider.h"
#import "ELDetailViewManager.h"
#import "ELQuestionCategory.h"
#import "ELQuestionTableViewCell.h"
#import "ELSurvey.h"
#import "ELSurveyViewManager.h"
#import "ELTableDataSource.h"

#pragma mark - Private Constants

static NSString * const kELCellIdentifier = @"QuestionCell";

#pragma mark - Class Extension

@interface ELSurveyDetailsViewController ()

@property (nonatomic) BOOL isSurveyFinal;
@property (nonatomic, strong) NSIndexPath *prevIndexPath;
@property (nonatomic, strong) ELTableDataSource *dataSource;
@property (nonatomic, strong) ELDetailViewManager *detailViewManager;
@property (nonatomic, strong) ELSurveyViewManager *surveyViewManager;
@property (nonatomic, strong) ELDataProvider<ELQuestion *> *provider;

@end

@implementation ELSurveyDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
//    self.provider = [[ELDataProvider alloc] initWithDataArray:self.category.questions];
//    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
//                                                      dataProvider:self.provider
//                                                    cellIdentifier:kELCellIdentifier];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:kELCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.category.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier];
    ELQuestion *question = self.category.questions[indexPath.row];
    
    [cell configure:question atIndexPath:indexPath];
    [cell setUserInteractionEnabled:self.survey.status != kELSurveyStatusCompleted];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELQuestion *question = self.category.questions[indexPath.row];
    
    return question.heightForQuestionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 25)];
    
    label.font = [UIFont fontWithName:@"Lato-Bold" size:18];
    label.text = self.category.title;
    label.textColor = [UIColor whiteColor];
    label.lineBreakMode = NSLineBreakByClipping;
    label.numberOfLines = 1;
    label.minimumScaleFactor = 0.5;
    
    [view addSubview:label];
    [view setBackgroundColor:[UIColor clearColor]];
    
    return view;
}

#pragma mark - Protocol Methods (ELSurveyViewManager)

- (void)onAPIPostResponseError:(NSDictionary *)errorDict {
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELSurveyPostError", nil)
                     completion:^{}];
}

- (void)onAPIPostResponseSuccess:(NSDictionary *)responseDict {
    NSString *successMessage = NSLocalizedString(self.isSurveyFinal ? @"kELSurveySubmissionSuccess" :
                                                                      @"kELSurveySaveToDraftSuccess", nil);
    
    // Back to the Surveys list
    [ELUtils presentToastAtView:self.view
                        message:successMessage
                     completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Interface Builder Actions

- (IBAction)onSubmitButtonClick:(id)sender {
    NSMutableArray *mAnswers = [[NSMutableArray alloc] init];
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"kELSurveySubmitHeaderMessage", nil)
                                                                        message:NSLocalizedString(@"kELSurveySubmitDetailsMessage", nil)
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    void (^actionBlock)(UIAlertAction *) = ^(UIAlertAction *action) {
        NSDictionary *formDict;
        
        self.isSurveyFinal = [action.title isEqualToString:NSLocalizedString(@"kELSubmitButton", nil)];
        
        // Retrieve answer from question views
        for (int i = 0; i < [self.tableView numberOfRowsInSection:0]; i++) {
            NSDictionary *formValues;
            ELQuestionTableViewCell *cell;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            [self.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:NO];
            
            cell = (ELQuestionTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            formValues = [[ELUtils questionViewFromSuperview:cell.questionContainerView] formValues];
            
            if (!formValues) {
                [ELUtils animateCell:cell];
                
                continue;
            }
            
            [mAnswers addObject:formValues];
        }
        
        formDict = @{@"key": self.survey.key,
                     @"final": @(self.isSurveyFinal),
                     @"answers": [mAnswers copy]};
        
        if (!self.isSurveyFinal) {
            [self.surveyViewManager processSurveyAnswerSubmissionWithFormData:formDict];
        } else {
            // Validate first before submission
            if (mAnswers.count == [self.tableView numberOfRowsInSection:0] && self.survey.key) {
                [self.surveyViewManager processSurveyAnswerSubmissionWithFormData:formDict];
            }
        }
    };
    
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELSaveToDraftButton", nil)
                                                   style:UIAlertActionStyleDefault
                                                 handler:actionBlock]];
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELSubmitButton", nil)
                                                   style:UIAlertActionStyleDefault
                                                 handler:actionBlock]];
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELCancelButton", nil)
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
    
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
}

@end
