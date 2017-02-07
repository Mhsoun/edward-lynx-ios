//
//  ELSurveyDetailsViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurveyDetailsViewController.h"

#pragma mark - Private Constants

static NSString * const kELCellIdentifier = @"QuestionCell";
static NSString * const kELActionSaveToDraft = @"Save to draft";
static NSString * const kELActionSubmit = @"Submit";
static NSString * const kELSurveyAnswerSuccessMessage = @"Survey successfully %@";

#pragma mark - Class Extension

@interface ELSurveyDetailsViewController ()

@property (nonatomic) kELSurveyResponseType responseType;
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
    if (!self.survey) {
        self.responseType = kELSurveyResponseTypeDetails;
        self.detailViewManager = [[ELDetailViewManager alloc] initWithObjectId:self.objectId];
        
        // Retrieve survey details
        [self.detailViewManager processRetrievalOfSurveyDetails];
    } else {
        self.title = [self.survey.name uppercaseString];
        self.responseType = kELSurveyResponseTypeQuestions;
        self.detailViewManager = [[ELDetailViewManager alloc] initWithDetailObject:self.survey];
        self.surveyViewManager = [[ELSurveyViewManager alloc] initWithSurvey:self.survey];
        self.surveyViewManager.delegate = self;
        
        // Retrieve surveys questions
        [self.detailViewManager processRetrievalOfSurveyQuestions];
    }
    
    self.detailViewManager.delegate = self;
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
    return [self.provider numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ELQuestionCategory *category = (ELQuestionCategory *)[self.provider sectionObjectAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                                                    inSection:section]];
    
    return category.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier];
    ELQuestion *question = [(ELQuestionCategory *)[self.provider sectionObjectAtIndexPath:indexPath] questions][indexPath.row];
    
    [cell configure:question atIndexPath:indexPath];
    [cell setUserInteractionEnabled:self.survey.status != kELSurveyStatusComplete];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELQuestion *question = [(ELQuestionCategory *)[self.provider sectionObjectAtIndexPath:indexPath] questions][indexPath.row];
    CGFloat toExpandHeight = question.answer.type == kELAnswerTypeOneToTenWithExplanation ? 180 : 150;
    
    return [ELUtils toggleQuestionTypeViewExpansionByType:question.answer.type] ? toExpandHeight : 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, -15, tableView.frame.size.width, 25)];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    ELQuestionCategory *category = (ELQuestionCategory *)[self.provider sectionObjectAtIndexPath:indexPath];
    
    label.font = [UIFont fontWithName:@"Lato-Bold" size:18];
    label.text = category.title;
    label.textColor = [UIColor whiteColor];
    label.lineBreakMode = NSLineBreakByClipping;
    label.numberOfLines = 1;
    label.minimumScaleFactor = 0.5;
    
    [view addSubview:label];
    [view setBackgroundColor:[UIColor clearColor]];
    
    return view;
}

#pragma mark - Protocol Methods (ELDetailViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    NSString *emptyMessage = [NSString stringWithFormat:@"Failed to retrieve %@",
                              self.responseType == kELSurveyResponseTypeDetails ? @"survey details." :
                                                                                  @"questions"];
    
    self.provider = [[ELDataProvider alloc] initWithDataArray:@[]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    
    [self.indicatorView stopAnimating];
    [self.dataSource dataSetEmptyText:emptyMessage description:@"Please try again later."];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    NSMutableArray *mCategories = [[NSMutableArray alloc] init];
    
    switch (self.responseType) {
        case kELSurveyResponseTypeDetails:
            self.survey = [[ELSurvey alloc] initWithDictionary:responseDict error:nil];
            self.surveyViewManager = [[ELSurveyViewManager alloc] initWithSurvey:self.survey];
            self.surveyViewManager.delegate = self;
            self.title = [self.survey.name uppercaseString];
            
            // Retrieve surveys questions
            self.responseType = kELSurveyResponseTypeQuestions;
            
            [self.detailViewManager processRetrievalOfSurveyQuestions];
            
            break;
        case kELSurveyResponseTypeQuestions:
            for (NSDictionary *categoryDict in (NSArray *)responseDict[@"items"]) {
                [mCategories addObject:[[ELQuestionCategory alloc] initWithDictionary:categoryDict error:nil]];
            }
            
            self.provider = [[ELDataProvider alloc] initWithDataArray:[mCategories copy]
                                                             sections:[mCategories count]];
            self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                              dataProvider:self.provider
                                                            cellIdentifier:kELCellIdentifier];
            
            [self.indicatorView stopAnimating];
            [self.tableView setDelegate:self];
            [self.tableView setDataSource:self];
            [self.tableView reloadData];
            
            break;
        default:
            break;
    }
}

#pragma mark - Protocol Methods (ELSurveyViewManager)

- (void)onAPIPostResponseError:(NSDictionary *)errorDict {
    DLog(@"%@: %@", [self class], errorDict);
}

- (void)onAPIPostResponseSuccess:(NSDictionary *)responseDict {
    NSString *successMessage = [NSString stringWithFormat:kELSurveyAnswerSuccessMessage, self.isSurveyFinal ? @"submitted." :
                                                                                                              @"saved to draft."];
    
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
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Submit Options"
                                                                        message:@"You have the option to save your answers partially or submit for completion."
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    void (^actionBlock)(UIAlertAction *) = ^(UIAlertAction *action) {
        NSDictionary *formDict;
        
        self.isSurveyFinal = [action.title isEqualToString:kELActionSubmit];
        
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
    
    [controller addAction:[UIAlertAction actionWithTitle:kELActionSaveToDraft
                                                   style:UIAlertActionStyleDefault
                                                 handler:actionBlock]];
    [controller addAction:[UIAlertAction actionWithTitle:kELActionSubmit
                                                   style:UIAlertActionStyleDefault
                                                 handler:actionBlock]];
    [controller addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
    
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
}

@end
