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
    self.viewManager = [[ELDetailViewManager alloc] init];
    self.viewManager.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:kELCellIdentifier bundle:nil]
         forCellReuseIdentifier:kELCellIdentifier];
    
    // Retrieve surveys questions
    [self.viewManager processRetrievalOfSurveyQuestionsAtId:self.survey.objectId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (UITableView)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELQuestion *question = (ELQuestion *)[self.provider objectAtIndexPath:indexPath];
    NSArray *answerTypes = @[@(kELAnswerTypeOneToTenWithExplanation), @(kELAnswerTypeText),
                             @(kELAnswerTypeAgreeementScale), @(kELAnswerTypeStrongAgreeementScale),
                             @(kELAnswerTypeInvertedAgreementScale)];
    
    return [answerTypes containsObject:@(question.answer.type)] ? 150 : 100;
}

#pragma mark - Protocol Methods (ELAPIResponseDelegate)

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

@end
