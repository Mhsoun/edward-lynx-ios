//
//  ELInstantFeedbackRespondentsViewController.m
//  EdwardLynxAppStore
//
//  Created by Jason Jon E. Carreos on 09/02/2018.
//  Copyright © 2018 Ingenuity Global Consulting. All rights reserved.
//

#import "ELInstantFeedbackRespondentsViewController.h"

#pragma mark - Private Constants

static NSString * const kELCellIdentifier = @"ManagerSurveyCell";

#pragma mark - Class Implementation

@interface ELInstantFeedbackRespondentsViewController ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation ELInstantFeedbackRespondentsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Table View
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kELCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.font = Font(@"Lato-Regular", 14.0f);
    cell.textLabel.text = @"Test";
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, tableView.frame.size.width, 25)];
    
    label.font = Font(@"Lato-Medium", 16.0f);
    label.text = @"1";
    label.textColor = ThemeColor(kELOrangeColor);
    label.lineBreakMode = NSLineBreakByClipping;
    label.numberOfLines = 1;
    label.minimumScaleFactor = 0.5;
    
    [view addSubview:label];
    [view setBackgroundColor:[UIColor clearColor]];
    
    return view;
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    self.tableView.tableFooterView = [[UIView alloc] init];
}


@end
