//
//  ELInstantFeedbackRespondentsViewController.m
//  EdwardLynxAppStore
//
//  Created by Jason Jon E. Carreos on 09/02/2018.
//  Copyright © 2018 Ingenuity Global Consulting. All rights reserved.
//

#import "ELInstantFeedbackRespondentsViewController.h"
#import "ELRespondentFreeTextTableViewCell.h"

#pragma mark - Private Constants

static NSString * const kELCellIdentifier = @"ItemCell";
static NSString * const kELFreeTextCellIdentifier = @"RespondentFreeTextCell";

#pragma mark - Class Implementation

@interface ELInstantFeedbackRespondentsViewController ()

@property (nonatomic) BOOL isFreeText;
@property (nonatomic, strong) NSArray *items;

@end

@implementation ELInstantFeedbackRespondentsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isFreeText = YES;  // TEMP
    
    if (self.isFreeText) {
        [self.tableView registerNib:[UINib nibWithNibName:kELFreeTextCellIdentifier bundle:nil]
             forCellReuseIdentifier:kELFreeTextCellIdentifier];
    } else {
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kELCellIdentifier];
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self layoutPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isFreeText ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isFreeText) {
        ELRespondentFreeTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELFreeTextCellIdentifier
                                                                                  forIndexPath:indexPath];
        
        [cell configure:@{@"response": @"By the way, it is bad practice to have names like \"string\" in Objective-C. It invites a runtime naming collision. Avoid them even in once off practice apps. Naming collisions can be very hard to track down and you don't want to waste the time.",
                          @"respondent": @"Test User"}
            atIndexPath:indexPath];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = Font(@"Lato-Regular", 14.0f);
        cell.textLabel.text = @"Test";
        cell.textLabel.textColor = [UIColor whiteColor];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.isFreeText ? CGFLOAT_MIN : 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.isFreeText ? UITableViewAutomaticDimension : 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isFreeText) {
        return [[UIView alloc] init];
    }
    
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
    // Table View
    self.tableView.estimatedRowHeight = 45;
    
    if (!self.isFreeText) {
        self.tableView.separatorColor = [UIColor clearColor];
    }
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // Title
    self.navigationItem.title = [NSLocalizedString(@"kELReportRespondents", nil) uppercaseString];
}

@end
