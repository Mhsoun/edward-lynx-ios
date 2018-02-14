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

@implementation ELInstantFeedbackRespondentsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isFreeText = NO;
    
    NSDictionary *jsonDict = [ELUtils dictionaryFromJSONAtFile:@"sample"];
    NSMutableArray *mAnswers = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in jsonDict[@"frequencies"]) {
        [mAnswers addObject:[[ELAnswerOption alloc] initWithDictionary:dict error:nil]];
    }
    
    self.items = [mAnswers copy];
        
    if (self.isFreeText) {
        [self.tableView registerNib:[UINib nibWithNibName:kELFreeTextCellIdentifier bundle:nil]
             forCellReuseIdentifier:kELFreeTextCellIdentifier];
    } else {
//        NSMutableArray *mAnswers = [[NSMutableArray alloc] init];
//
//        for (ELAnswerOption *option in self.items) {
//            // Not include options without any respondents
//            if (option.submissions.count == 0) {
//                continue;
//            }
//
//            [mAnswers addObject:option];
//        }
//
//        self.items = [mAnswers copy];
        
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
    return self.isFreeText ? 1 : self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.items[section].submissions.count > 0 ? self.items[section].submissions.count : 1;
    
    return self.isFreeText ? self.items.count : count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isFreeText) {
        ELRespondentFreeTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELFreeTextCellIdentifier
                                                                                  forIndexPath:indexPath];
        
        [cell configure:self.items[indexPath.row] atIndexPath:indexPath];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier forIndexPath:indexPath];
        ELAnswerOptionRespondent *respondent = [[ELAnswerOptionRespondent alloc] initWithDictionary:@{@"id": @(-1),
                                                                                                      @"name": NSLocalizedString(@"kELReportRespondentsNone", nil),
                                                                                                      @"email": @"a@a.com"}
                                                                                              error:nil];
        
        if (self.items[indexPath.section].submissions.count > 0) {
            respondent = self.items[indexPath.section].submissions[indexPath.row];
        }
        
        cell.indentationLevel = 3;
        cell.indentationWidth = 10;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = Font(@"Lato-Regular", 14.0f);
        cell.textLabel.text = respondent.name;
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
    return self.isFreeText ? UITableViewAutomaticDimension : 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isFreeText) {
        return [[UIView alloc] init];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, tableView.frame.size.width, 25)];
    ELAnswerOption *option = self.items[section];
    
    label.font = Font(@"Lato-Medium", 16.0f);
    label.text = option.shortDescription;
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
