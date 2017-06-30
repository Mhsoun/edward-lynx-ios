//
//  ELManagerCategoryViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELManagerCategoryViewController.h"
#import "ELTeamViewManager.h"

#pragma mark - Private Constants

static NSString * const kELCellIdentifier = @"ManagerCategoryCell";

#pragma mark - Class Extension

@interface ELManagerCategoryViewController ()

@property (nonatomic, strong) NSMutableArray<ELTeamDevelopmentPlan *> *mCategories, *mInitialCategories;
@property (nonatomic, strong) ELTeamViewManager *viewManager;

@end

@implementation ELManagerCategoryViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.mCategories = [[NSMutableArray alloc] init];
    self.mInitialCategories = [[NSMutableArray alloc] init];
    self.navigationItem.title = [self.navigationItem.title uppercaseString];
    
    [self createSampleData];
    
    self.viewManager = [[ELTeamViewManager alloc] init];
    self.viewManager.postDelegate = self;
    
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.separatorColor = ThemeColor(kELSurveySeparatorColor);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.editing = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    return self.mInitialCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = [FontAwesome imageWithIcon:fa_check_circle
                                            iconColor:[UIColor clearColor]
                                             iconSize:15
                                            imageSize:CGSizeMake(15, 15)];
    
    cell.textLabel.font = Font(@"Lato-Regular", 14.0f);
    cell.textLabel.text = [self.mInitialCategories[indexPath.row] name];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = self.mInitialCategories[indexPath.row];  // TEMP
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([self.mCategories containsObject:object]) {
        cell.imageView.image = [FontAwesome imageWithIcon:fa_check_circle
                                                iconColor:[UIColor clearColor]
                                                 iconSize:15
                                                imageSize:CGSizeMake(15, 15)];
        
        [self.mCategories removeObject:object];
    } else {
        cell.imageView.image = [FontAwesome imageWithIcon:fa_check_circle
                                                iconColor:ThemeColor(kELGreenColor)
                                                 iconSize:15
                                                imageSize:CGSizeMake(15, 15)];
        
        [self.mCategories addObject:object];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    ELTeamDevelopmentPlan *category = self.mInitialCategories[sourceIndexPath.row];
    
    [self.mInitialCategories removeObjectAtIndex:sourceIndexPath.row];
    [self.mInitialCategories insertObject:category atIndex:destinationIndexPath.row];
}

#pragma mark - Protocol Methods (ELAPIPostResponse)

- (void)onAPIPostResponseError:(NSDictionary *)errorDict {
    [self dismissViewControllerAnimated:YES completion:nil];
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELTeamDevelopmentPlanCreateError", nil)
                     completion:nil];
}

- (void)onAPIPostResponseSuccess:(NSDictionary *)responseDict {
    [self dismissViewControllerAnimated:YES completion:nil];
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELTeamDevelopmentPlanCreateSuccess", nil)
                     completion:nil];
}

#pragma mark - Private Methods

- (void)createSampleData {
    ELTeamDevelopmentPlan *teamDevPlan = [[ELTeamDevelopmentPlan alloc] initWithDictionary:@{@"id": @123,
                                                                                             @"name": @"Dev Plan 1",
                                                                                             @"position": @1}
                                                                                     error:nil];
    
    [self.mInitialCategories addObject:teamDevPlan];
    
    teamDevPlan = [[ELTeamDevelopmentPlan alloc] initWithDictionary:@{@"id": @123,
                                                                      @"name": @"Dev Plan 0",
                                                                      @"position": @0}
                                                              error:nil];
    
    [self.mInitialCategories addObject:teamDevPlan];
    
    teamDevPlan = [[ELTeamDevelopmentPlan alloc] initWithDictionary:@{@"id": @123,
                                                                      @"name": @"Dev Plan 3",
                                                                      @"position": @3}
                                                              error:nil];
    
    [self.mInitialCategories addObject:teamDevPlan];
    
    teamDevPlan = [[ELTeamDevelopmentPlan alloc] initWithDictionary:@{@"id": @123,
                                                                      @"name": @"Dev Plan 2",
                                                                      @"position": @2}
                                                              error:nil];
    
    [self.mInitialCategories addObject:teamDevPlan];
    [self sortArrayByCategory:self.mInitialCategories];
}

- (void)sortArrayByCategory:(NSMutableArray *)mList {
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position"
                                                                    ascending:YES];
    
    [self.mInitialCategories sortUsingDescriptors:@[valueDescriptor]];
}

#pragma mark - Interface Builder Actions

- (IBAction)onAddButtonClick:(id)sender {
    self.nameErrorLabel.hidden = self.nameField.text.length > 0;
    
    if (self.nameField.text == 0) {
        return;
    }
    
    // TODO Either API call or just add to list
    
//    [self.viewManager processCreateTeamDevPlan:@{@"id": @-1,
//                                                 @"name": self.nameField.text,
//                                                 @"position": @(self.mInitialCategories.count - 1)}];
}

- (IBAction)onSubmitButtonClick:(id)sender {
    // TODO API call depending on Add button behavior
}

@end
