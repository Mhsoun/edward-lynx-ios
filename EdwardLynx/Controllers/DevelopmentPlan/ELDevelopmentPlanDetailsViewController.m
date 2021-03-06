//
//  ELDevelopmentPlanDetailsViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 01/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <PNChart/PNCircleChart.h>
#import <REValidation/REValidation.h>

#import "ELDevelopmentPlanDetailsViewController.h"
#import "ELCreateDevelopmentPlanViewController.h"
#import "ELDetailViewManager.h"
#import "ELDevelopmentPlan.h"
#import "ELDevelopmentPlanAPIClient.h"
#import "ELDevelopmentPlanViewManager.h"
#import "ELGoalDetailsViewController.h"
#import "ELGoalTableViewCell.h"

#pragma mark - Private Constants

typedef NS_ENUM(NSInteger, kELActionOption) {
    kELActionOptionAdd = 1,
    kELActionOptionDelete = 2,
    kELActionOptionUpdate = 3,
    kELActionOptionGoalDelete = 4
};

static CGFloat const kELGoalCellHeight = 105;
static CGFloat const kELIconHeight = 20;
static NSString * const kELCellIdentifier = @"GoalCell";
static NSString * const kELCreateDevPlanGoalStoryboardIdentifier = @"CreateDevPlanGoal";
static NSString * const kELSegueIdentifier = @"UpdateDevPlan";

#pragma mark - Class Extension

@interface ELDevelopmentPlanDetailsViewController ()

@property (nonatomic) BOOL shared;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) kELActionOption actionOptionType;
@property (nonatomic, strong) NSMutableArray<ELGoal *> *mGoals;
@property (nonatomic, strong) UIAlertAction *addAction, *updateAction;
@property (nonatomic, strong) UIAlertController *actionAlert;
@property (nonatomic, strong) ELDetailViewManager *detailViewManager;
@property (nonatomic, strong) ELDevelopmentPlanViewManager *devPlanViewManager;
@property (nonatomic, strong) PNCircleChart *circleChart;

@end

@implementation ELDevelopmentPlanDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.shared = NO;
    self.actionOptionType = -1;
    self.mGoals = [[NSMutableArray alloc] init];
    
    if (!self.devPlan) {
        self.detailViewManager = [[ELDetailViewManager alloc] initWithObjectId:self.objectId];
        self.devPlanViewManager = [[ELDevelopmentPlanViewManager alloc] initWithObjectId:self.objectId];
        self.devPlanViewManager.delegate = self;
                
        [self.detailViewManager processRetrievalOfDevelopmentPlanDetails];
    } else {
        self.shared = self.devPlan.shared;
        self.title = [self.devPlan.name uppercaseString];
        self.mGoals = [NSMutableArray arrayWithArray:self.devPlan.goals];
        self.detailViewManager = [[ELDetailViewManager alloc] initWithDetailObject:self.devPlan];
        self.devPlanViewManager = [[ELDevelopmentPlanViewManager alloc] initWithDetailObject:self.devPlan];
        self.devPlanViewManager.delegate = self;
    }

    self.selectedIndex = -1;
    self.detailViewManager.delegate = self;
    
    // Table View
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    RegisterNib(self.tableView, kELCellIdentifier);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if (AppSingleton.needsPageReload) {
        [self.detailViewManager processRetrievalOfDevelopmentPlanDetails];
    }
    
    [super viewWillAppear:animated];
    
    // Notifications
    [NotificationCenter addObserver:self
                           selector:@selector(onGoalActionAddition:)
                               name:kELGoalActionAddNotification
                             object:nil];
    [NotificationCenter addObserver:self
                           selector:@selector(onGoalActionOptions:)
                               name:kELGoalActionOptionsNotification
                             object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Remove observers
    [NotificationCenter removeObserver:self
                                  name:kELGoalActionAddNotification
                                object:nil];
    [NotificationCenter removeObserver:self
                                  name:kELGoalActionOptionsNotification
                                object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Render circle chart
    [self.circleChart removeFromSuperview];
    
    self.circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 0, 100, 100)
                                                      total:@100
                                                    current:@0
                                                  clockwise:YES
                                                     shadow:YES
                                                shadowColor:[UIColor blackColor]
                                       displayCountingLabel:YES
                                          overrideLineWidth:@12];
    
    [self.circleChartView addSubview:self.circleChart];
    
    if (self.devPlan) {
        [self setupChart];
        [self setupDevPlan];
        [self.indicatorView stopAnimating];
        [self.tableView setHidden:NO];
        [self.tableView reloadData];
        
        // Share Button
        [self.shareButton setHidden:AppSingleton.devPlanUserId > -1];
    }
}

- (void)dealloc {
    DLog(@"%@", [self class]);
    
    // Reset User ID for filtering Dev Plans
    if (AppSingleton.devPlanUserId > -1) {
        AppSingleton.devPlanUserId = -1;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kELSegueIdentifier]) {
        ELCreateDevelopmentPlanViewController *controller = (ELCreateDevelopmentPlanViewController *)[segue destinationViewController];
        
        controller.devPlan = self.devPlan;
    }
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.devPlan.goals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ELGoal *goal = self.devPlan.goals[indexPath.row];
    ELGoalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier forIndexPath:indexPath];
    
    goal.createdAt = self.devPlan.createdAt;
    goal.urlLink = Format(@"%@/goals/%@", self.devPlan.urlLink, @(goal.objectId));
    
    cell.delegate = self;
    cell.devPlanName = self.devPlan.name;
    
    [cell configure:goal atIndexPath:indexPath];
    [cell.tableView setHidden:self.selectedIndex != indexPath.row];
    
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
    ELGoal *goal = self.devPlan.goals[indexPath.row];
    NSInteger actionCount = [AppSingleton.user isNotAdminDevPlan] ? goal.actions.count : goal.actions.count + 1;
    CGFloat expandedHeight = (kELActionCellHeight * actionCount) + kELGoalCellHeight;
    
    return self.selectedIndex == indexPath.row ? expandedHeight : kELGoalCellHeight;
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    CGFloat iconHeight = 15;
    
    // Button
    [self.addGoalButton setHidden:[AppSingleton.user isNotAdminDevPlan]];
    [self.addGoalButton setImage:[FontAwesome imageWithIcon:fa_plus
                                                  iconColor:[UIColor blackColor]
                                                   iconSize:iconHeight
                                                  imageSize:CGSizeMake(iconHeight, iconHeight)]
                        forState:UIControlStateNormal];
}

#pragma mark - Protocol Methods (ELDetailViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELDetailsPageLoadError", nil)
                     completion:nil];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    self.devPlan = [[ELDevelopmentPlan alloc] initWithDictionary:responseDict error:nil];
    self.devPlan.urlLink = responseDict[@"_links"][@"self"][@"href"];
    
    self.shared = self.devPlan.shared;
    self.mGoals = [NSMutableArray arrayWithArray:self.devPlan.goals];
    self.title = [self.devPlan.name uppercaseString];
    
    [self setupChart];
    [self setupDevPlan];
    [self.indicatorView stopAnimating];
    [self.tableView setHidden:NO];
    [self.tableView reloadData];
    
    // Share Button
    [self.shareButton setHidden:AppSingleton.devPlanUserId > -1];
    
    // Decrement badge count
    Application.applicationIconBadgeNumber--;
}

#pragma mark - Protocol Methods (ELAPIPostResponse)

- (void)onAPIPostResponseError:(NSDictionary *)errorDict {
    [self dismissViewControllerAnimated:YES completion:nil];
//    [ELUtils presentToastAtView:self.view
//                        message:NSLocalizedString(@"kELPostMethodError", nil)
//                     completion:nil];
}

- (void)onAPIPostResponseSuccess:(NSDictionary *)responseDict {
    BOOL toReload;
    NSString *message;
    
    toReload = YES;
    AppSingleton.needsPageReload = YES;
    
    switch (self.actionOptionType) {
        case kELActionOptionAdd:
            message = NSLocalizedString(@"kELDevelopmentPlanGoalActionCreateSuccess", nil);
            
            break;
        case kELActionOptionDelete:
            message = NSLocalizedString(@"kELDevelopmentPlanGoalActionDeleteSuccess", nil);
            
            break;
        case kELActionOptionUpdate:
            message = NSLocalizedString(@"kELDevelopmentPlanGoalActionUpdateSuccess", nil);
            
            break;
        case kELActionOptionGoalDelete:
            message = NSLocalizedString(@"kELDevelopmentPlanGoalUpdateSuccess", nil);
            
            break;
        default:
            toReload = NO;
            message = self.shared ? NSLocalizedString(@"kELDevelopmentPlanUnshareUpdateSuccess", nil) :
                                    NSLocalizedString(@"kELDevelopmentPlanShareUpdateSuccess", nil);
            
            // Update shared status
            [self setShared:!self.shared];
            [self.shareButton setImage:[FontAwesome imageWithIcon:self.shared ? fa_check_square : fa_square_o
                                                        iconColor:ThemeColor(kELOrangeColor)
                                                         iconSize:kELIconHeight
                                                        imageSize:CGSizeMake(kELIconHeight, kELIconHeight)]
                              forState:UIControlStateNormal];
            
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [ELUtils presentToastAtView:self.view
                        message:message
                     completion:nil];
    
    if (toReload) {
        [self reloadPage];
    }
}

#pragma mark - Protocol Methods (ELDevelopmentPlan)

- (void)onGoalOptions:(__kindof ELModel *)object sender:(UIButton *)sender {
    UIAlertController *alertController;
    ELGoal *goal = (ELGoal *)object;
    __weak typeof(self) weakSelf = self;
    void (^deleteAPIBlock)(UIAlertAction * _Nonnull action) = ^(UIAlertAction * _Nonnull action) {
        weakSelf.actionOptionType = kELActionOptionGoalDelete;
        
        [weakSelf presentViewController:[ELUtils loadingAlert]
                               animated:YES
                             completion:nil];
        [weakSelf.devPlanViewManager processDeleteDevelopmentPlanGoalWithLink:goal.urlLink];
    };
    void (^deleteAlertActionBlock)(UIAlertAction * _Nonnull action) = ^(UIAlertAction * _Nonnull action) {
        NSString *title = NSLocalizedString(@"kELDevelopmentPlanGoalActionCompleteHeaderMessage", nil);
        NSString *message = NSLocalizedString(@"kELDevelopmentPlanGoalDeleteDetailsMessage", nil);
        UIAlertController *controller = Alert(title, Format(message, goal.title));
        
        [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELDeleteButton", nil)
                                                       style:UIAlertActionStyleDestructive
                                                     handler:deleteAPIBlock]];
        [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELCancelButton", nil)
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil]];
        
        [weakSelf presentViewController:controller
                               animated:YES
                             completion:nil];
    };
    
    alertController = ActionSheet(nil, nil);
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELDevelopmentPlanGoalButtonUpdate", nil)
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [self addUpdateGoal:goal];
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELDevelopmentPlanGoalButtonDelete", nil)
                                                        style:UIAlertActionStyleDestructive
                                                      handler:deleteAlertActionBlock]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELCancelButton", nil)
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        alertController.modalPresentationStyle = UIModalPresentationPopover;
        alertController.popoverPresentationController.sourceView = sender;
    }
    
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

- (void)onGoalUpdate:(__kindof ELModel *)object {
    ELGoal *goal = (ELGoal *)object;
    
    [self.mGoals replaceObjectAtIndex:self.selectedIndex withObject:goal];
    [self.devPlan setGoals:[self.mGoals copy]];
    [self.tableView reloadData];
    
    [self.chartLabel setAttributedText:self.devPlan.attributedProgressText];
    [self.circleChart updateChartByCurrent:[NSNumber numberWithDouble:(self.devPlan.progress * 100)]];
}

#pragma mark - Private Methods

- (void)addUpdateGoal:(ELGoal *)goal {
    ELGoalDetailsViewController *controller = StoryboardController(@"CreateDevelopmentPlan",
                                                                   kELCreateDevPlanGoalStoryboardIdentifier);
    
    controller.goal = goal;
    controller.toAddNew = !goal;
    controller.requestLink = goal ? goal.urlLink : Format(@"%@/goals", self.devPlan.urlLink);
    controller.withAPIProcess = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)reloadPage {
    [self.tableView setHidden:YES];
    [self.indicatorView startAnimating];
    [self.detailViewManager processRetrievalOfDevelopmentPlanDetails];
}

- (void)setupChart {
    self.chartLabel.attributedText = self.devPlan.attributedProgressText;
    
    // Chart
    [ELUtils circleChart:self.circleChart progress:self.devPlan.progress];
    [self.circleChart setDisplayAnimated:NO];
    [self.circleChart strokeChart];
    
    // Share to manager
    [self.shareButton setImage:[FontAwesome imageWithIcon:self.shared ? fa_check_square : fa_square_o
                                                iconColor:ThemeColor(kELOrangeColor)
                                                 iconSize:kELIconHeight
                                                imageSize:CGSizeMake(kELIconHeight, kELIconHeight)]
                      forState:UIControlStateNormal];
}

- (void)setupDevPlan {
    for (ELGoal *goal in self.devPlan.goals) {
        goal.isAlreadyAdded = YES;
        
        for (ELGoalAction *action in goal.actions) {
            action.isAlreadyAdded = YES;
        }
    }
}

- (void)updateGoalAction:(ELGoalAction *)action {
    __weak typeof(self) weakSelf = self;
    NSString *title = NSLocalizedString(@"kELDevelopmentPlanGoalActionUpdateAlertHeader", nil);
    NSString *message = NSLocalizedString(@"kELDevelopmentPlanGoalActionUpdateAlertDetail", nil);
    
    self.actionAlert = Alert(title, message);
    self.updateAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"kELUpdateButton", nil)
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * _Nonnull alertAction) {
        NSString *name = [self.actionAlert.textFields[0] text];
        NSDictionary *formDict = @{@"title": name, @"link": action.urlLink};
        
        weakSelf.actionOptionType = kELActionOptionUpdate;
        
        [weakSelf presentViewController:[ELUtils loadingAlert]
                               animated:YES
                             completion:nil];
        [weakSelf.devPlanViewManager processUpdateDevelopmentPlanGoalAction:formDict];
    }];
    self.updateAction.enabled = NO;
    
    [self.actionAlert addAction:self.updateAction];
    [self.actionAlert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELCancelButton", nil)
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil]];
    [self.actionAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = action.title;
        textField.placeholder = NSLocalizedString(@"kELNameLabel", nil);
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        
        [textField addTarget:weakSelf
                      action:@selector(onAlertControllerTextsChanged:)
            forControlEvents:UIControlEventEditingChanged];
    }];
    
    [self presentViewController:self.actionAlert
                       animated:YES
                     completion:nil];
}

#pragma mark - Notifications

- (void)onGoalActionAddition:(NSNotification *)notification {
    __weak typeof(self) weakSelf = self;
    NSString *title = NSLocalizedString(@"kELDevelopmentPlanGoalActionCreateAlertHeader", nil);
    NSString *message = NSLocalizedString(@"kELDevelopmentPlanGoalActionCreateAlertDetail", nil);
    
    self.actionAlert = Alert(title, message);
    self.addAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"kELAddButton", nil)
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull alertAction) {
        NSString *name = [self.actionAlert.textFields[0] text];
        NSDictionary *formDict = @{@"title": name,
                                   @"position": notification.userInfo[@"index"],
                                   @"link": notification.userInfo[@"link"]};
        
        weakSelf.actionOptionType = kELActionOptionAdd;
        
        [weakSelf presentViewController:[ELUtils loadingAlert]
                               animated:YES
                             completion:nil];
        [weakSelf.devPlanViewManager processAddDevelopmentPlanGoalAction:formDict];
    }];
    self.updateAction.enabled = NO;
    
    [self.actionAlert addAction:self.addAction];
    [self.actionAlert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELCancelButton", nil)
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil]];
    [self.actionAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"kELNameLabel", nil);
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        
        [textField addTarget:weakSelf
                      action:@selector(onAlertControllerTextsChanged:)
            forControlEvents:UIControlEventEditingChanged];
    }];
    
    [self presentViewController:self.actionAlert
                       animated:YES
                     completion:nil];
}

- (void)onGoalActionOptions:(NSNotification *)notification {
    UIAlertController *alertController;
    ELGoalAction *action = notification.userInfo[@"action"];
    __weak typeof(self) weakSelf = self;
    void (^deleteAPIBlock)(UIAlertAction * _Nonnull action) = ^(UIAlertAction * _Nonnull alertAction) {
        weakSelf.actionOptionType = kELActionOptionDelete;
        
        [weakSelf presentViewController:[ELUtils loadingAlert]
                               animated:YES
                             completion:nil];
        [weakSelf.devPlanViewManager processDeleteDevelopmentPlanGoalActionWithLink:action.urlLink];
    };
    void (^deleteAlertActionBlock)(UIAlertAction * _Nonnull action) = ^(UIAlertAction * _Nonnull alertAction) {
        NSString *title = NSLocalizedString(@"kELDevelopmentPlanGoalActionCompleteHeaderMessage", nil);
        NSString *message = NSLocalizedString(@"kELDevelopmentPlanGoalActionDeleteDetailsMessage", nil);
        UIAlertController *controller = Alert(title, Format(message, action.title));
        
        [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELDeleteButton", nil)
                                                       style:UIAlertActionStyleDestructive
                                                     handler:deleteAPIBlock]];
        [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELCancelButton", nil)
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil]];
        
        [weakSelf presentViewController:controller
                               animated:YES
                             completion:nil];
    };
    
    alertController = ActionSheet(nil, nil);
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELDevelopmentPlanGoalActionButtonUpdate", nil)
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull alertAction) {
                                                          [self updateGoalAction:action];
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELDevelopmentPlanGoalActionButtonDelete", nil)
                                                        style:UIAlertActionStyleDestructive
                                                      handler:deleteAlertActionBlock]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELCancelButton", nil)
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        alertController.modalPresentationStyle = UIModalPresentationPopover;
        alertController.popoverPresentationController.sourceView = notification.userInfo[@"sender"];
    }
    
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

#pragma mark - Interface Builder Actions

- (IBAction)onShareButtonClick:(id)sender {
    [self presentViewController:[ELUtils loadingAlert]
                       animated:YES
                     completion:nil];
    
    [self.devPlanViewManager processUpdateDevelopmentPlan:@{@"shared": @(!self.shared)}];
}

- (IBAction)onAddGoalButtonClick:(id)sender {
    [self addUpdateGoal:nil];
}

#pragma mark - Targets

- (void)onAlertControllerTextsChanged:(UITextField *)sender {
    NSArray *nameErrors;
    NSArray<UITextField *> *textFields = self.actionAlert.textFields;
    
    nameErrors = [REValidation validateObject:textFields.firstObject.text
                                         name:@"Name"
                                   validators:@[@"presence"]];
    
    [self.updateAction setEnabled:(nameErrors.count == 0)];
}

@end
