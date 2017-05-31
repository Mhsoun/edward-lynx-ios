//
//  ELReportChildPageViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELReportChildPageViewController.h"
#import "ELReportChartTableViewCell.h"

#pragma mark - Private Constants

static NSString * const kELCellIdentifier = @"ReportChartCell";

#pragma mark - Class Extension

@interface ELReportChildPageViewController ()

@property (nonatomic) kELReportChartType type;

@end

@implementation ELReportChildPageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Detailed Answer Summary per category data
//    self.items = @[@{@"dataPoints": @[@{@"Question": @1,
//                                        @"Percentage": @0,
//                                        @"Percentage_1": @0.14},
//                                      @{@"Question": @2,
//                                        @"Percentage": @0.25,
//                                        @"Percentage_1": @0.5},
//                                      @{@"Question": @3,
//                                        @"Percentage": @0.8,
//                                        @"Percentage_1": @0.4}]}];

    // Radar Diagram
//    self.items = @[@[@{@"id": @176,
//                       @"name": @"Category 1",
//                       @"roles": @[@{@"id": @(-1),
//                                     @"name": @"Others combined",
//                                     @"average": @0.65},
//                                   @{@"id": @9,
//                                     @"name": @"Candidates",
//                                     @"average": @0.15}]},
//                     @{@"id": @177,
//                       @"name": @"Category 2",
//                       @"roles": @[@{@"id": @-1,
//                                     @"name": @"Others combined",
//                                     @"average": @0.83333333333333},
//                                   @{@"id": @9,
//                                     @"name": @"Candidates",
//                                     @"average": @0.5}]},
//                     @{@"id": @178,
//                       @"name": @"Category 3",
//                       @"roles": @[@{@"id": @-1,
//                                     @"name": @"Others combined",
//                                     @"average": @0.66666666666667},
//                                   @{@"id": @9,
//                                     @"name": @"Candidates",
//                                     @"average": @0}]}]];
    
    // Yes/No
//    self.items = @[@{@"id": @529,
//                     @"categoryId": @177,
//                     @"category": @"Category 2",
//                     @"yesPercentage": @100,
//                     @"noPercentage": @0},
//                   @{@"id": @529,
//                     @"categoryId": @178,
//                     @"category": @"Category 3",
//                     @"yesPercentage": @54,
//                     @"noPercentage": @46}];

    // Participant
//    self.items = @[@{@"dataPoints": @[@{@"Title": @"\"Colleague\"",
//                                        @"Percentage": @0.65,
//                                        @"role_style": @"orangeColor"},
//                                      @{@"Title": @"\"Candidates\"",
//                                        @"Percentage": @0.15,
//                                        @"role_style": @"selfColor"}]},
//                   @{@"dataPoints": @[@{@"Title": @"\"Colleague\"",
//                                        @"Percentage": @0.83,
//                                        @"role_style": @"orangeColor"},
//                                      @{@"Title": @"\"Candidates\"",
//                                        @"Percentage": @0.5,
//                                        @"role_style": @"selfColor"}]}];
    
    // Initialization
    [self populatePage];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Detailed Answer Summary per category data
//    return [self.items[0][@"dataPoints"] count];
    
    switch (self.type) {
        case kELReportChartTypeRadar:
            return 1;
            break;
        default:
            return self.items.count;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELReportChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier
                                                                       forIndexPath:indexPath];
    
    [cell configure:@{@"type": @(self.type),
                      @"data": self.items[indexPath.row]}
        atIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.type) {
        case kELReportChartTypeHorizontalBarBlindspot:
        case kELReportChartTypeHorizontalBarBreakdown:
            return 150;
        case kELReportChartTypeBar:
            return 200;
        default:
            return 350;
    }
}

#pragma mark - Protocol Methods (DZNEmptyDataSet)

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:14],
                                 NSForegroundColorAttributeName: [[RNThemeManager sharedManager] colorForKey:kELWhiteColor]};
    
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"kELReportEmptyMessage", nil)
                                           attributes:attributes];
}

#pragma mark - Private Methods

- (void)populatePage {
    if ([self.key containsString:@"blindspot"]) {
        self.type = kELReportChartTypeHorizontalBarBlindspot;
        
        // NOTE: Sample data
//        self.items = @[@{@"id": @530,
//                         @"title": @"question #5",
//                         @"category": @"Category 3",
//                         @"answerType": @{
//                                 @"type": @4,
//                                 @"description": @"Strong agreement scale",
//                                 @"help": @"An strong agreement scale that determines how much the person that answers the question agrees with it, where strongly disagree means the lowest and strongly agree, the highest.",
//                                 @"isText": @NO,
//                                 @"isNumeric": @NO,
//                                 @"options": @[@{@"description": @"Strongly Disagree",
//                                                 @"value": @0},
//                                               @{@"description": @"Disagree",
//                                                 @"value": @1},
//                                               @{@"description": @"Agree",
//                                                 @"value": @2},
//                                               @{@"description": @"Strongly Agree",
//                                                 @"value": @3}]},
//                         @"self": @0,
//                         @"others": @67,
//                         @"gap": @67}];
        if ([self.key containsString:@"overestimated"]) {
            self.headerLabel.text = NSLocalizedString(@"kELReportTypeBlindspotOverHeader", nil);
            self.detailLabel.text = NSLocalizedString(@"kELReportTypeBlindspotOverDetail", nil);
        } else {
            self.headerLabel.text = NSLocalizedString(@"kELReportTypeBlindspotUnderHeader", nil);
            self.detailLabel.text = NSLocalizedString(@"kELReportTypeBlindspotUnderDetail", nil);
        }
    } else if ([self.key isEqualToString:@"breakdown"]) {
        self.type = kELReportChartTypeHorizontalBarBreakdown;
        
        self.headerLabel.text = NSLocalizedString(@"kELReportTypeBreakdownHeader", nil);
        self.detailLabel.text = NSLocalizedString(@"kELReportTypeBreakdownDetail", nil);
        
        // NOTE: Sample data
//        self.items = @[@{@"dataPoints": @[@{@"Percentage": @(0.65),
//                                            @"Title": @"\"Colleague\"",
//                                            @"role_style": @"orangeColor"},
//                                          @{@"Percentage": @(0.70),
//                                            @"Title": @"\"Candidate\"",
//                                            @"role_style": @"selfColor"}]}];
    } else if ([self.key isEqualToString:@"detailed_answer_summary"]) {
        self.type = kELReportChartTypeBar;
        
        self.headerLabel.text = NSLocalizedString(@"kELReportTypeDetailPerCategoryHeader", nil);
    } else if ([self.key isEqualToString:@"radar_diagram"]) {
        self.type = kELReportChartTypeRadar;
        self.items = @[self.items];
        
        self.headerLabel.text = NSLocalizedString(@"kELReportTypeRadarHeader", nil);
        self.detailLabel.text = NSLocalizedString(@"kELReportTypeRadarDetail", nil);
    }  else if ([self.key isEqualToString:@"yes_or_no"]) {
        self.type = kELReportChartTypePie;
        
        self.headerLabel.text = NSLocalizedString(@"kELReportTypeYesNoHeader", nil);
    }
}

@end
