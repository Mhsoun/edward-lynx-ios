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
static NSString * const kELCommentCellIdentifier = @"ReportCommentCell";

#pragma mark - Class Extension

@interface ELReportChildPageViewController ()

@property (nonatomic) kELReportChartType type;

@end

@implementation ELReportChildPageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    CGRect frame;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    [self populatePage];
    
    frame = CGRectMake(0.0f,
                       0.0f,
                       CGRectGetWidth(self.tableView.bounds),
                       CGFLOAT_MIN);
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (self.type) {
        case kELReportChartTypeComments:
            return self.items.count;
        default:
            return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *answers;
    
    switch (self.type) {
        case kELReportChartTypeComments:
            answers = self.items[section][@"answer"];
            
            return [answers count];
        case kELReportChartTypeRadar:
            return 1;
        default:
            return self.items.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title;
    NSDictionary *dataDict;
    ELReportChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier
                                                                       forIndexPath:indexPath];
    
    if (self.type == kELReportChartTypeComments) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:kELCommentCellIdentifier];
        
        dataDict = self.items[indexPath.section][@"answer"][indexPath.row];
        
        cell.imageView.image = [FontAwesome imageWithIcon:fa_circle
                                                iconColor:[UIColor whiteColor]
                                                 iconSize:5
                                                imageSize:CGSizeMake(5, 5)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12];
        cell.textLabel.lineBreakMode = NSLineBreakByClipping;
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.text = dataDict[@"text"];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        return cell;
    }
    
    title = self.type == kELReportChartTypeHorizontalBarHighestLowest ? [self.key componentsSeparatedByString:@"."][2] : @"";
    dataDict = self.items[indexPath.row];
    
    [cell configure:@{@"title": title,
                      @"type": @(self.type),
                      @"data": dataDict}
        atIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.type) {
        case kELReportChartTypeComments:
            return 30;
        case kELReportChartTypeHorizontalBarBlindspot:
        case kELReportChartTypeHorizontalBarBreakdown:
        case kELReportChartTypeHorizontalBarHighestLowest:
            return 150;
        case kELReportChartTypeBarCategory:
            return 200;
        case kELReportChartTypePie:
            return 250;
        default:
            return 350;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.type != kELReportChartTypeComments) {
        return 0;
    }
    
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label;
    UIView *view;
    
    if (self.type != kELReportChartTypeComments) {
        return nil;
    }
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 35)];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.tableView.frame), 30)];
    label.font = [UIFont fontWithName:@"Lato-Italic" size:14];
    label.textColor = [UIColor whiteColor];
    label.text = self.items[section][@"question"];
    
    [view addSubview:label];
    
    return view;
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
    } else if ([self.key isEqualToString:@"comments"]) {
        self.type = kELReportChartTypeComments;
        
        self.headerLabel.text = NSLocalizedString(@"kELReportTypeCommentsHeader", nil);
    } else if ([self.key isEqualToString:@"detailed_answer_summary"]) {
        self.type = kELReportChartTypeBarCategory;
        
        self.headerLabel.text = NSLocalizedString(@"kELReportTypeDetailPerCategoryHeader", nil);
    } else if ([self.key containsString:@"highestLowestIndividual"]) {
        NSString *headerText;
        NSString *subKey = [self.key componentsSeparatedByString:@"."][1];
        NSString *title = [self.key componentsSeparatedByString:@"."][2];
        
        self.type = kELReportChartTypeHorizontalBarHighestLowest;
        
        if ([subKey isEqualToString:@"highest"]) {
            headerText = NSLocalizedString(@"kELReportTypeHighestHeader", nil);
            
            self.detailLabel.text = NSLocalizedString(@"kELReportTypeHighestDetail", nil);
        } else {
            headerText = NSLocalizedString(@"kELReportTypeLowestHeader", nil);
            
            self.detailLabel.text = NSLocalizedString(@"kELReportTypeLowestDetail", nil);
        }
        
        self.headerLabel.text = [NSString stringWithFormat:headerText, title];
    } else if ([self.key isEqualToString:@"radar_diagram"]) {
        self.type = kELReportChartTypeRadar;
        self.items = @[self.items];
        
        self.headerLabel.text = NSLocalizedString(@"kELReportTypeRadarHeader", nil);
        self.detailLabel.text = NSLocalizedString(@"kELReportTypeRadarDetail", nil);
    } else if ([self.key isEqualToString:@"response_rate"]) {
        self.type = kELReportChartTypeBarResponseRate;
        self.items = @[self.items];
        
        self.headerLabel.text = NSLocalizedString(@"kELReportTypeResponseRateHeader", nil);
        self.detailLabel.text = NSLocalizedString(@"kELReportTypeResponseRateDetail", nil);
    } else if ([self.key isEqualToString:@"yes_or_no"]) {
        self.type = kELReportChartTypePie;
        
        self.headerLabel.text = NSLocalizedString(@"kELReportTypeYesNoHeader", nil);
    }
}

@end
