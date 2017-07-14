//
//  ELManagerUsersViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 23/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#import "ELManagerUsersViewController.h"
#import "ELDataProvider.h"
#import "ELParticipant.h"
#import "ELParticipantTableViewCell.h"
#import "ELTableDataSource.h"
#import "ELTeamViewManager.h"

#pragma mark - Private Constants

static CGFloat const kELIconSize = 17.5f;
static NSString * const kELCellIdentifier = @"ParticipantCell";

#pragma mark - Class Extension

@interface ELManagerUsersViewController ()

@property (nonatomic) BOOL selected, allCellsAction;
@property (nonatomic) NSInteger currentCount, initialCount;
@property (nonatomic, strong) UIImage *checkIcon;
@property (nonatomic, strong) NSMutableArray *mInitialParticipants, *mParticipants;
@property (nonatomic, strong) ELTableDataSource *dataSource;
@property (nonatomic, strong) ELTeamViewManager *viewManager;
@property (nonatomic, strong) ELDataProvider<ELParticipant *> *provider;

@end

@implementation ELManagerUsersViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.currentCount = 0, self.initialCount = 0;
    self.mParticipants = [[NSMutableArray alloc] init];
    self.mInitialParticipants = [[NSMutableArray alloc] init];
    self.checkIcon = [FontAwesome imageWithIcon:fa_check_circle
                                      iconColor:ThemeColor(kELGreenColor)
                                       iconSize:kELIconSize
                                      imageSize:CGSizeMake(kELIconSize, kELIconSize)];
    
    self.searchBar.delegate = self;
    
    self.viewManager = [[ELTeamViewManager alloc] init];
    self.viewManager.delegate = self;
    self.viewManager.postDelegate = self;
    
    self.tableView.hidden = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    RegisterNib(self.tableView, kELCellIdentifier);
    
    [self.viewManager processRetrieveUsersWithSharedDevPlans];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DLog(@"%@", [self class]);
}

#pragma mark - Protocol Methods (UISearchBar)

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSMutableArray *mFilteredParticipants = [self.mInitialParticipants mutableCopy];
    NSString *condition = @"SELF.name CONTAINS [cd]%@ || SELF.email CONTAINS [cd]%@";
    
    if (searchText.length > 0) {
        [mFilteredParticipants filterUsingPredicate:[NSPredicate predicateWithFormat:condition,
                                                     searchText,
                                                     searchText]];
    }
    
    self.provider = [[ELDataProvider alloc] initWithDataArray:[mFilteredParticipants copy]];
    
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [[searchBar delegate] searchBar:searchBar textDidChange:@""];
    
    [searchBar setText:@""];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar endEditing:YES];
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.provider numberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELParticipant *participant = (ELParticipant *)[self.provider rowObjectAtIndexPath:indexPath];
    ELParticipantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier
                                                                       forIndexPath:indexPath];
    
    [cell configure:participant atIndexPath:indexPath];
    [cell setAccessoryView:cell.participant.managed ? [[UIImageView alloc] initWithImage:self.checkIcon] : nil];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ELParticipantTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.allCellsAction) {
        cell.participant.managed = self.selected;
    } else {
        [cell handleObject:[self.provider rowObjectAtIndexPath:indexPath] selectionActionAtIndexPath:indexPath];
    }
    
    // Toggle selected state
    if (cell.participant.managed) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:self.checkIcon];
        
        if (![self.mParticipants containsObject:[cell.participant apiPostDictionary]]) {
            self.currentCount++;
            
            [self.mParticipants addObject:[cell.participant apiPostDictionary]];
        }
    } else {
        self.currentCount--;
        
        cell.accessoryView = nil;
        
        [self.mParticipants removeObject:[cell.participant apiPostDictionary]];
    }
    
    // Button state
    [self updateSelectAllButtonForIndexPath:indexPath];
    
    // Updated selected users label
    self.noOfPeopleLabel.text = Format(NSLocalizedString(@"kELUsersNumberSelectedLabel", nil),
                                       @(self.mParticipants.count));
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    [self.selectAllButton setTitle:@"" forState:UIControlStateNormal];
    [self toggleSelectAllButton:fa_square_o];
    
//    [self toggleSelectAllButton:@"kELSelectAllButton"];
    
    self.navigationItem.title = [self.navigationItem.title uppercaseString];
}

#pragma mark - Protocol Methods (ELAPIPostResponse)

- (void)onAPIPostResponseError:(NSDictionary *)errorDict {
    [self dismissViewControllerAnimated:YES completion:nil];
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELPostMethodError", nil)
                     completion:nil];
}

- (void)onAPIPostResponseSuccess:(NSDictionary *)responseDict {
    NSString *message = self.currentCount < self.initialCount ? NSLocalizedString(@"kELManagerUsersDisableSuccess", nil) :
                                                                NSLocalizedString(@"kELManagerUsersEnableSuccess", nil);
    
    AppSingleton.needsPageReload = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [ELUtils presentToastAtView:self.view
                        message:message
                     completion:^{
                         [self.navigationController popViewControllerAnimated:YES];
                     }];
}

#pragma mark - Protocol Methods (ELAPIResponse)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    [self.indicatorView stopAnimating];
    [self.tableView setHidden:NO];
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELDetailsPageLoadError", nil)
                     completion:nil];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    ELParticipant *participant;
    
    [self.indicatorView stopAnimating];
    [self.tableView setHidden:NO];
    
    for (NSDictionary *dict in responseDict[@"items"]) {
        participant = [[ELParticipant alloc] initWithDictionary:dict error:nil];
        
        [self.mInitialParticipants addObject:participant];
        
        if (participant.managed) {
            [self.mParticipants addObject:[participant apiPostDictionary]];
        }
    }
    
    self.currentCount = self.mParticipants.count;
    self.initialCount = self.mParticipants.count;
    
    // Updated selected users label
    self.noOfPeopleLabel.text = Format(NSLocalizedString(@"kELUsersNumberSelectedLabel", nil),
                                       @(self.mParticipants.count));
    
    self.provider = [[ELDataProvider alloc] initWithDataArray:self.mInitialParticipants];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.emptyDataSetSource = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView reloadData];
    [self layoutPage];
}

#pragma mark - Protocol Methods (DZNEmptyDataSet)

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attributes = @{NSFontAttributeName: Font(@"Lato-Regular", 14.0f),
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"kELInviteUsersRetrievalEmpty", nil)
                                           attributes:attributes];
}

#pragma mark - Private Methods

- (void)toggleSelectAllButton:(NSString *)key {
    CGFloat size = 20;
    
//    [self.selectAllButton setTitle:NSLocalizedString(key, nil)
//                          forState:UIControlStateNormal];
    
    [self.selectAllButton setTag:[key isEqualToString:fa_square_o] ? 0 : 1];
    [self.selectAllButton setTintColor:ThemeColor(kELOrangeColor)];
    [self.selectAllButton setImage:[FontAwesome imageWithIcon:key
                                                    iconColor:ThemeColor(kELOrangeColor)
                                                     iconSize:size
                                                    imageSize:CGSizeMake(size, size)]
                          forState:UIControlStateNormal];
}

- (void)updateSelectAllButtonForIndexPath:(NSIndexPath *)indexPath {
    NSString *key;
    NSInteger selectedCount = self.mParticipants.count, rowsCount = [self.provider numberOfRows];
    
    if (selectedCount == 0 || !selectedCount) {
//        key = @"kELSelectAllButton";
        key = fa_square_o;
    } else if (selectedCount >= rowsCount) {
//        key = self.mInitialParticipants.count ? @"kELDeselectAllButton" : nil;
        key = self.mInitialParticipants.count ? fa_check_square : nil;
    }
    
    if (!key) {
        return;
    }
    
    [self toggleSelectAllButton:key];
}

#pragma mark - Interface Builder Actions

- (IBAction)onSelectAllButtonClick:(id)sender {
    BOOL isSelected;
    NSString *key;
    UIButton *button = (UIButton *)sender;
    
//    isSelected = [button.titleLabel.text isEqualToString:NSLocalizedString(@"kELSelectAllButton", nil)];
//    title = isSelected ? NSLocalizedString(@"kELDeselectAllButton", nil) :
//                         NSLocalizedString(@"kELSelectAllButton", nil);
    
    isSelected = button.tag == 0;
    key = isSelected ? fa_check_square : fa_square_o;
    
//    self.selected = [button.titleLabel.text isEqualToString:NSLocalizedString(@"kELSelectAllButton", nil)];
    
    self.selected = button.tag == 0;
    self.allCellsAction = YES;
    
    [self toggleSelectAllButton:key];
    
    for (int i = 0; i < [self.provider numberOfRows]; i++) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionBottom];
        [[self.tableView delegate] tableView:self.tableView
                     didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    self.allCellsAction = NO;
}

- (IBAction)onSubmitButtonClick:(id)sender {
    [self presentViewController:[ELUtils loadingAlert]
                       animated:YES
                     completion:nil];
    [self.viewManager processEnableUsersForManagerDashboard:@{@"users": [self.mParticipants copy]}];
}

@end
