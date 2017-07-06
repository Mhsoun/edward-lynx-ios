//
//  ELManagerReportsViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/07/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELManagerReportsViewController.h"
#import "ELManagerReportDetailsViewController.h"
#import "ELManagerSurveyTableViewCell.h"

#pragma mark - Private Constants

static NSInteger const kELCellHeight = 55;
static NSString * const kELCellIdentifier = @"ManagerSurveyCell";
static NSString * const kELSegueIdentifier = @"ReportDetails";

#pragma mark - Class Implementation

@interface ELManagerReportsViewController ()

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSArray *surveys;

@end

@implementation ELManagerReportsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.selectedIndex = -1;
    self.surveys = @[@{@"name": @"Test",
                       @"reports": @[@{@"name": @"Report 1",
                                       @"link": @"http://www.pdf995.com/samples/pdf.pdf"},
                                     @{@"name": @"Report 2",
                                       @"link": @"http://www.pdf995.com/samples/pdf.pdf"},
                                     @{@"name": @"Report 3",
                                       @"link": @"http://www.pdf995.com/samples/pdf.pdf"}]},
                     @{@"name": @"Test 1",
                       @"reports": @[@{@"name": @"Report 1",
                                       @"link": @"http://www.pdf995.com/samples/pdf.pdf"}]}];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = ThemeColor(kELSurveySeparatorColor);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    RegisterNib(self.tableView, kELCellIdentifier);
    
    [self.indicatorView stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [NotificationCenter addObserver:self
                           selector:@selector(onReportDetailsSelection:)
                               name:kELManagerReportDetailsNotification
                             object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [NotificationCenter removeObserver:self
                                  name:kELManagerReportDetailsNotification
                                object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kELSegueIdentifier]) {
        ELManagerReportDetailsViewController *controller = [segue destinationViewController];
        
        controller.link = self.link;
    }
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.surveys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELManagerSurveyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier
                                                                         forIndexPath:indexPath];
    
    [cell configure:self.surveys[indexPath.row] atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex == indexPath.row) {  // User taps expanded row
        self.selectedIndex = -1;
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (self.selectedIndex != -1) {  // User taps different row
        NSIndexPath *prevPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
        
        self.selectedIndex = indexPath.row;
        
        [tableView reloadRowsAtIndexPaths:@[prevPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {  // User taps new row with none expanded
        self.selectedIndex = indexPath.row;
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    // Scroll selected cell to top (to initially display much content as possible)
    [tableView scrollToRowAtIndexPath:indexPath
                     atScrollPosition:UITableViewScrollPositionTop
                             animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *reports = self.surveys[indexPath.row][@"reports"];
    CGFloat expandedHeight = (kELManagerReportCellHeight * reports.count) + kELCellHeight;
    
    return self.selectedIndex == indexPath.row ? expandedHeight : kELCellHeight;
}

#pragma mark - Protocol Methods (ELTeamViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attributes = @{NSFontAttributeName: Font(@"Lato-Regular", 14.0f),
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"kELReportEmptyMessage", nil)
                                           attributes:attributes];
}

#pragma mark - Protocol Methods (XLPagerTabStrip)

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController {
    return [NSLocalizedString(@"kELTabTitleReports", nil) uppercaseString];
}
     
#pragma mark - Selectors
     
- (void)onReportDetailsSelection:(NSNotification *)notification {
    self.link = notification.userInfo[@"link"];
    
    [self performSegueWithIdentifier:kELSegueIdentifier sender:self];
}

@end
