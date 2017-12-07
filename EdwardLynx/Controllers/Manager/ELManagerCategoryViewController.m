//
//  ELManagerCategoryViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <TNRadioButtonGroup/TNRadioButtonGroup.h>

#import "ELManagerCategoryViewController.h"
#import "ELTeamViewManager.h"

#pragma mark - Private Constants

typedef NS_ENUM(NSInteger, kELTeamDevPlanAction) {
    kELTeamDevPlanActionCreate = 1,
    kELTeamDevPlanActionUpdate = 2
};

static NSString * const kELCellIdentifier = @"ManagerCategoryCell";

#pragma mark - Class Extension

@interface ELManagerCategoryViewController ()

@property (nonatomic) kELTeamDevPlanAction action;
@property (nonatomic, strong) NSString *selectedLanguage;
@property (nonatomic, strong) NSMutableArray<ELTeamDevelopmentPlan *> *mCategories;
@property (nonatomic, strong) ELTeamViewManager *viewManager;
@property (nonatomic, strong) TNRadioButtonGroup *radioGroup;

@end

@implementation ELManagerCategoryViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.action = -1;
    self.mCategories = [[NSMutableArray alloc] init];
    self.navigationItem.title = [self.navigationItem.title uppercaseString];
    
    self.viewManager = [[ELTeamViewManager alloc] init];
    self.viewManager.postDelegate = self;
    
    [self sortArrayByPosition:self.mItems];
    
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
    return self.mItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELTeamDevelopmentPlan *teamDevPlan = self.mItems[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = [FontAwesome imageWithIcon:fa_check_circle
                                            iconColor:teamDevPlan.visible ? ThemeColor(kELGreenColor) : [UIColor clearColor]
                                             iconSize:15
                                            imageSize:CGSizeMake(15, 15)];
    
    cell.textLabel.font = Font(@"Lato-Regular", 14.0f);
    cell.textLabel.text = teamDevPlan.name;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIColor *color;
    ELTeamDevelopmentPlan *teamDevPlan = self.mItems[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    self.action = kELTeamDevPlanActionUpdate;
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([self.mCategories containsObject:teamDevPlan]) {
        [self.mCategories removeObject:teamDevPlan];
    } else {
        [self.mCategories addObject:teamDevPlan];
    }
    
    teamDevPlan.visible = !teamDevPlan.visible;
    color = teamDevPlan.visible ? ThemeColor(kELGreenColor) : [UIColor clearColor];
    cell.imageView.image = [FontAwesome imageWithIcon:fa_check_circle
                                            iconColor:color
                                             iconSize:15
                                            imageSize:CGSizeMake(15, 15)];
    
    [self.mItems replaceObjectAtIndex:indexPath.row withObject:teamDevPlan];
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
    ELTeamDevelopmentPlan *sourceCategory = self.mItems[sourceIndexPath.row];
    ELTeamDevelopmentPlan *destinationCategory = self.mItems[destinationIndexPath.row];
    
    self.action = kELTeamDevPlanActionUpdate;
    
    [self.mItems removeObjectAtIndex:sourceIndexPath.row];
    [self.mItems insertObject:sourceCategory atIndex:destinationIndexPath.row];
    
    sourceCategory.position = [self.mItems indexOfObject:sourceCategory];
    destinationCategory.position = [self.mItems indexOfObject:destinationCategory];
    
    [self.mItems replaceObjectAtIndex:sourceCategory.position withObject:sourceCategory];
    [self.mItems replaceObjectAtIndex:destinationCategory.position withObject:destinationCategory];
}

#pragma mark - Protocol Methods (ELAPIPostResponse)

- (void)onAPIPostResponseError:(NSDictionary *)errorDict {
//    NSString *message;
//    
//    switch (self.action) {
//        case kELTeamDevPlanActionCreate:
//            message = NSLocalizedString(@"kELTeamDevelopmentPlanCreateError", nil);
//            
//            break;
//        case kELTeamDevPlanActionUpdate:
//            message = NSLocalizedString(@"kELTeamDevelopmentPlanUpdateError", nil);
//            
//            break;
//        default:
//            break;
//    }
    
    self.action = -1;
    
    [self dismissViewControllerAnimated:YES completion:nil];
//    [ELUtils presentToastAtView:self.view
//                        message:message
//                     completion:nil];
}

- (void)onAPIPostResponseSuccess:(NSDictionary *)responseDict {
    NSMutableArray *mItems;
    NSString *message;
    ELCategory *category;
    ELTeamDevelopmentPlan *teamDevPlan;
    
    AppSingleton.needsPageReload = YES;
    
    switch (self.action) {
        case kELTeamDevPlanActionCreate:
            self.nameField.text = @"";
            self.radioGroup.selectedRadioButton = self.radioGroup.radioButtons[0];
            
            message = NSLocalizedString(@"kELTeamDevelopmentPlanCreateSuccess", nil);
            teamDevPlan = [[ELTeamDevelopmentPlan alloc] initWithDictionary:responseDict error:nil];
            teamDevPlan.position = 0;
            
            // Add new Team Dev Plan to current list
            if (!self.mItems.count || self.mItems.count == 0) {
                [self.mItems addObject:teamDevPlan];
            } else {
                [self.mItems insertObject:teamDevPlan atIndex:0];
            }
            
            // Add as category for Developmemt Plan creation
            category = [[ELCategory alloc] initWithDictionary:@{@"id": @-1, @"title": teamDevPlan.name} error:nil];
            mItems = [AppSingleton.categories mutableCopy];
            
            [mItems addObject:category];
            
            AppSingleton.categories = [mItems copy];
            
            break;
        case kELTeamDevPlanActionUpdate:
            message = NSLocalizedString(@"kELTeamDevelopmentPlanUpdateSuccess", nil);
            
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.action == kELTeamDevPlanActionCreate) {
        self.action = -1;
        
        [self.tableView reloadData];
    }
    
    [ELUtils presentToastAtView:self.view message:message completion:^{
        if (self.action == kELTeamDevPlanActionUpdate) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    NSArray *languages = @[@"en", @"sv", @"fn"];
    NSMutableArray *mData = [[NSMutableArray alloc] init];
    
    self.selectedLanguage = languages[0];
    
    // Radio Group
    for (int i = 0; i < languages.count; i++) {
        NSString *language = languages[i];
        TNCircularRadioButtonData *data = [TNCircularRadioButtonData new];
        
        data.selected = i == 0;
        data.identifier = language;
        
        data.labelText = language;
        data.labelFont = Font(@"Lato-Regular", 14.0f);
        data.labelColor = [UIColor whiteColor];
        
        data.borderColor = [UIColor whiteColor];
        data.circleColor = ThemeColor(kELOrangeColor);
        data.borderRadius = 20;
        data.circleRadius = 15;
        
        [mData addObject:data];
    }
    
    self.radioGroup = [[TNRadioButtonGroup alloc] initWithRadioButtonData:[mData copy]
                                                                   layout:TNRadioButtonGroupLayoutHorizontal];
    
    [self.radioGroup setIdentifier:@"Gender group"];
    [self.radioGroup setMarginBetweenItems:15];
    
    [self.radioGroup create];
    [self.radioGroupView addSubview:self.radioGroup];
    
    // Notification to handle selection changes
    [NotificationCenter addObserver:self
                           selector:@selector(onGenderTypeGroupUpdate:)
                               name:SELECTED_RADIO_BUTTON_CHANGED
                             object:self.radioGroup];
}

#pragma mark - Private Methods

- (void)sortArrayByPosition:(NSMutableArray *)mList {
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position"
                                                                    ascending:YES];
    
    [mList sortUsingDescriptors:@[valueDescriptor]];
}

#pragma mark - Interface Builder Actions

- (IBAction)onAddButtonClick:(id)sender {
    self.nameErrorLabel.hidden = self.nameField.text.length > 0;
    
    if (self.nameField.text.length == 0) {
        return;
    }
    
    // Process creation
    self.action = kELTeamDevPlanActionCreate;
    
    [self presentViewController:[ELUtils loadingAlert]
                       animated:YES
                     completion:nil];
    [self.viewManager processCreateTeamDevPlan:@{@"name": self.nameField.text,
                                                 @"lang": self.selectedLanguage}];
}

- (IBAction)onSubmitButtonClick:(id)sender {
    NSMutableArray *mTeamDevPlans = [[NSMutableArray alloc] init];
    
    self.action = kELTeamDevPlanActionUpdate;
    
    for (ELTeamDevelopmentPlan *teamDevPlan in self.mItems) {
        [mTeamDevPlans addObject:[teamDevPlan putDictionary]];
    }
    
    // Update Team Dev Plans
    [self presentViewController:[ELUtils loadingAlert]
                       animated:YES
                     completion:nil];
    [self.viewManager processUpdateTeamDevPlans:@{@"items": [mTeamDevPlans copy]}];
}

#pragma mark - Notifications

- (void)onGenderTypeGroupUpdate:(NSNotification *)notification {
    self.selectedLanguage = self.radioGroup.selectedRadioButton.data.identifier;
}

@end
