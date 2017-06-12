//
//  ELSurveyDetailsViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELSurveyDetailsViewController.h"
#import "ELBaseQuestionTypeView.h"
#import "ELDetailViewManager.h"
#import "ELQuestionCategory.h"
#import "ELQuestionTableViewCell.h"
#import "ELSurvey.h"
#import "ELSurveyViewManager.h"

#pragma mark - Private Constants

static NSString * const kELCellIdentifier = @"QuestionCell";

#pragma mark - Class Extension

@interface ELSurveyDetailsViewController ()

@property (nonatomic) BOOL isSurveyFinal;
@property (nonatomic, strong) ELDetailViewManager *detailViewManager;
@property (nonatomic, strong) ELSurveyViewManager *surveyViewManager;

@end

@implementation ELSurveyDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    if (!self.survey) {
        self.detailViewManager = [[ELDetailViewManager alloc] initWithObjectId:self.objectId];
        
        [self.detailViewManager processRetrievalOfSurveyDetails];
    }
    
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

- (void)dealloc {
    DLog(@"%@", [self class]);
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.category.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELQuestion *question = self.category.questions[indexPath.row];
    ELQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier
                                                                    forIndexPath:indexPath];
    
    [cell configure:question atIndexPath:indexPath];
    [cell setUserInteractionEnabled:self.survey.status != kELSurveyStatusCompleted];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELQuestion *question = self.category.questions[indexPath.row];
    
    return question.heightForQuestionView + kELCustomScaleItemHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 25)];
    
    label.font = [UIFont fontWithName:@"Lato-Medium" size:18];
    label.text = self.category.title;
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
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELDetailsPageLoadError", nil)
                     completion:nil];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    self.survey = [[ELSurvey alloc] initWithDictionary:responseDict error:nil];
    
    [self.indicatorView stopAnimating];
    [self.tableView reloadData];
}

#pragma mark - Public Methods

- (NSArray *)formValues {
    NSMutableArray *mAnswers = [[NSMutableArray alloc] init];
    
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
    
    return [mAnswers copy];
}

@end
