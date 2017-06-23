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
    self.mParticipants = [[NSMutableArray alloc] init];
    self.mInitialParticipants = [[NSMutableArray alloc] init];
    self.checkIcon = [FontAwesome imageWithIcon:fa_check_circle
                                      iconColor:ThemeColor(kELGreenColor)
                                       iconSize:kELIconSize
                                      imageSize:CGSizeMake(kELIconSize, kELIconSize)];
    
    self.viewManager = [[ELTeamViewManager alloc] init];
    self.viewManager.delegate = self;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.hidden = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    RegisterNib(self.tableView, kELCellIdentifier);
    
    [self.viewManager processRetrieveUsersWithSharedDevPlans];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [cell setUserInteractionEnabled:!participant.isAlreadyInvited];
    [cell setAccessoryView:cell.participant.isSelected ? [[UIImageView alloc] initWithImage:self.checkIcon] : nil];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ELParticipantTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.allCellsAction) {
        cell.participant.isSelected = self.selected;
    } else {
        [cell handleObject:[self.provider rowObjectAtIndexPath:indexPath] selectionActionAtIndexPath:indexPath];
    }
    
    // Toggle selected state
    if (cell.participant.isSelected) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:self.checkIcon];
        
        if (![self.mParticipants containsObject:cell.participant]) {
            [self.mParticipants addObject:cell.participant];
        }
    } else {
        cell.accessoryView = nil;
        
        [self.mParticipants removeObject:cell.participant];
    }
    
    // Button state
    [self updateSelectAllButtonForIndexPath:indexPath];
    
    // Updated selected users label
    self.noOfPeopleLabel.text = Format(NSLocalizedString(@"kELUsersNumberSelectedLabel", nil),
                                       @(self.mParticipants.count));
}

#pragma mark - Protocol Methods (ELAPIResponse)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    [self.indicatorView stopAnimating];
    [self.tableView setHidden:NO];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    [self.indicatorView stopAnimating];
    [self.tableView setHidden:NO];
    
    for (NSDictionary *dict in responseDict[@"items"]) {
        [self.mInitialParticipants addObject:[[ELParticipant alloc] initWithDictionary:dict error:nil]];
    }
    
    self.provider = [[ELDataProvider alloc] initWithDataArray:self.mInitialParticipants];
    self.dataSource = [[ELTableDataSource alloc] initWithTableView:self.tableView
                                                      dataProvider:self.provider
                                                    cellIdentifier:kELCellIdentifier];
    
    [self.tableView reloadData];
}

#pragma mark - Protocol Methods (DZNEmptyDataSet)

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attributes = @{NSFontAttributeName: Font(@"Lato-Regular", 18.0f),
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"kELInviteUsersRetrievalEmpty", nil)
                                           attributes:attributes];
}

#pragma mark - Private Methods

- (void)updateSelectAllButtonForIndexPath:(NSIndexPath *)indexPath {
    NSString *key;
    NSInteger selectedCount = 0, rowsCount = [self.provider numberOfRows];
    
    // Traverse cells to get count of currently selected rows
    for (int i = 0; i < rowsCount; i++) {
        ELParticipantTableViewCell *cell;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        cell = (ELParticipantTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.participant.isSelected && cell.isUserInteractionEnabled) {
            selectedCount++;
        }
    }
    
    if (selectedCount == 0 || !selectedCount) {
        key = @"kELSelectAllButton";
    } else if (selectedCount >= rowsCount) {
        key = self.mInitialParticipants.count ? @"kELDeselectAllButton" : nil;
    }
    
    if (!key) {
        return;
    }
    
    [self.selectAllButton setTitle:NSLocalizedString(key, nil) forState:UIControlStateNormal];
}

#pragma mark - Interface Builder Actions

- (IBAction)onSelectAllButtonClick:(id)sender {
    BOOL isSelected;
    NSString *title;
    UIButton *button = (UIButton *)sender;
    
    isSelected = [button.titleLabel.text isEqualToString:NSLocalizedString(@"kELSelectAllButton", nil)];
    title = isSelected ? @"kELDeselectAllButton" : @"kELSelectAllButton";
    
    self.allCellsAction = YES;
    self.selected = [button.titleLabel.text isEqualToString:NSLocalizedString(@"kELSelectAllButton", nil)];
    
    [button setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
    
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
    
}

@end
