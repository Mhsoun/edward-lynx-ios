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

#pragma mark - Class Extension

@interface ELSurveyDetailsViewController ()

@property (nonatomic, strong) NSIndexPath *prevIndexPath;
@property (nonatomic, strong) ELTableDataSource *dataSource;
@property (nonatomic, strong) ELDetailViewManager *viewManager;
@property (nonatomic, strong) ELDataProvider<ELQuestion *> *provider;

@end

@implementation ELSurveyDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.viewManager = [[ELDetailViewManager alloc] initWithDetailObject:self.survey];
    self.viewManager.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:kELCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELCellIdentifier];
    
    // Retrieve surveys questions
    [self.viewManager processRetrievalOfSurveyQuestions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (UITableView)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELQuestion *question = (ELQuestion *)[self.provider objectAtIndexPath:indexPath];
    
    return [ELUtils toggleQuestionTypeViewExpansionByType:question.answer.type] ? 185 : 135;
}

#pragma mark - Protocol Methods (ELDetailViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    self.provider = [[ELDataProvider alloc] initWithDataArray:@[]];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    
    [self.indicatorView stopAnimating];
    [self.dataSource dataSetEmptyText:@"Failed to retrieve questions"
                          description:@"Please try again later."];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    NSMutableArray *mData = [[NSMutableArray alloc] init];
    
    for (NSDictionary *categoryDict in (NSArray *)responseDict[@"items"]) {
        [mData addObject:[[ELQuestionCategory alloc] initWithDictionary:categoryDict error:nil]];
    }
    
    ELQuestionCategory *category = mData[0];  // TEMP
    
    self.provider = [[ELDataProvider alloc] initWithDataArray:category.questions];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    
    [self.indicatorView stopAnimating];
    [self.tableView setDelegate:self];
    [self.tableView reloadData];
}

#pragma mark - Interface Builder Actions

- (IBAction)onDoneButtonClick:(id)sender {
    NSMutableArray *mAnswers = [[NSMutableArray alloc] init];
    
    // Retrieve answer from question views
    for (int i = 0; i < [self.tableView numberOfRowsInSection:0]; i++) {
        ELQuestionTableViewCell *cell;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:NO];
        
        cell = (ELQuestionTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        [mAnswers addObject:[[ELUtils questionViewFromSuperview:cell.questionContainerView] formValues]];
    }
    
    // TODO Handle validation and get value for `key`
    
//    [self.viewManager processSurveyAnswerSubmissionWithFormData:@{@"key": @"",
//                                                                  @"answers": [mAnswers copy]}];
}

@end
