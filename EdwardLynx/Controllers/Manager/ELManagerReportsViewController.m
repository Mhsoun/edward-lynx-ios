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
#import "ELTeamViewManager.h"

#pragma mark - Private Constants

static NSInteger const kELCellHeight = 55;
static NSString * const kELCellIdentifier = @"ManagerSurveyCell";
static NSString * const kELSegueIdentifier = @"ReportDetails";

#pragma mark - Class Implementation

@interface ELManagerReportsViewController ()

@property (nonatomic) NSInteger selectedIndex, selectedSection;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSDictionary *detailDict;
@property (nonatomic, strong) ELTeamViewManager *viewManager;

@end

@implementation ELManagerReportsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    CGRect frame;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    frame = CGRectMake(0, 0, 0, CGFLOAT_MIN);
    
    self.selectedIndex = -1, self.selectedSection = -1;
        
    self.tableView.emptyDataSetSource = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = ThemeColor(kELSurveySeparatorColor);
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
    
    RegisterNib(self.tableView, kELCellIdentifier);
    
    self.viewManager = [[ELTeamViewManager alloc] init];
    self.viewManager.delegate = self;
    
    [self.viewManager processRetrieveManagerReports];
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
    [NotificationCenter addObserver:self
                           selector:@selector(onSendPDFToEmail:)
                               name:kELManagerReportEmailNotification
                             object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [NotificationCenter removeObserver:self
                                  name:kELManagerReportDetailsNotification
                                object:nil];
    [NotificationCenter removeObserver:self
                                  name:kELManagerReportEmailNotification
                                object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kELSegueIdentifier]) {
        ELManagerReportDetailsViewController *controller = [segue destinationViewController];
        
        controller.detailDict = self.detailDict;
    }
}

#pragma mark - Protocol Methods (MFMailComposeViewController)

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    [ELUtils handleMailResult:result fromParentController:self];
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.users.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *surveys = self.users[section][@"surveys"];
    
    return surveys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *surveys = self.users[indexPath.section][@"surveys"];
    ELManagerSurveyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier
                                                                         forIndexPath:indexPath];
    
    [cell configure:surveys[indexPath.row] atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ELManagerSurveyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.reportCount == 0) {
        return;
    }
    
    if (self.selectedIndex == indexPath.row && self.selectedSection == indexPath.section) {  // User taps expanded row
        self.selectedIndex = -1;
        self.selectedSection = -1;
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (self.selectedIndex != -1) {  // User taps different row
        NSIndexPath *prevPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:self.selectedSection];
        
        self.selectedIndex = indexPath.row;
        self.selectedSection = indexPath.section;
        
        [tableView reloadRowsAtIndexPaths:@[prevPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {  // User taps new row with none expanded
        self.selectedIndex = indexPath.row;
        self.selectedSection = indexPath.section;
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    // Scroll selected cell to top (to initially display much content as possible)
    [tableView scrollToRowAtIndexPath:indexPath
                     atScrollPosition:UITableViewScrollPositionTop
                             animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isSelected;
    NSArray *surveys = self.users[indexPath.section][@"surveys"];
    NSArray *reports = surveys[indexPath.row][@"reports"];
    CGFloat expandedHeight = (kELManagerReportCellHeight * reports.count) + kELCellHeight;
    
    isSelected = self.selectedSection == indexPath.section && self.selectedIndex == indexPath.row;
    
    return isSelected ? expandedHeight : kELCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *userDict = self.users[section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, tableView.frame.size.width, 25)];
    
    label.font = Font(@"Lato-Medium", 16.0f);
    label.text = userDict[@"name"];
    label.textColor = ThemeColor(kELOrangeColor);
    label.lineBreakMode = NSLineBreakByClipping;
    label.numberOfLines = 1;
    label.minimumScaleFactor = 0.5;
    
    [view addSubview:label];
    [view setBackgroundColor:[UIColor clearColor]];
    
    return view;
}

#pragma mark - Protocol Methods (ELTeamViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    [self.indicatorView stopAnimating];
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELDetailsPageLoadError", nil)
                     completion:nil];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    self.users = responseDict[@"items"];
    
    [self.indicatorView stopAnimating];
    [self.tableView setHidden:NO];
    [self.tableView reloadData];
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
    self.detailDict = notification.userInfo;
    
    [self performSegueWithIdentifier:kELSegueIdentifier sender:self];
}

- (void)onSendPDFToEmail:(NSNotification *)notification {
    [ELUtils composeMailForController:self details:notification.userInfo];
}

@end
