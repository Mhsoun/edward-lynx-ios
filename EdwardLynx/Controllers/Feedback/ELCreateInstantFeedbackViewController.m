//
//  ELCreateInstantFeedbackViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <TNRadioButtonGroup/TNRadioButtonGroup.h>

#import "ELCreateInstantFeedbackViewController.h"
#import "ELAddObjectTableViewCell.h"
#import "ELDropdownView.h"
#import "ELFeedbackViewManager.h"
#import "ELInstantFeedback.h"
#import "ELInviteUsersViewController.h"
#import "ELItemTableViewCell.h"

#pragma mark - Private Constants

static CGFloat const kELCellHeight = 45;
static CGFloat const kELFormViewHeight = 355;
static NSString * const kELAddOptionCellIdentifier = @"AddOptionCell";
static NSString * const kELOptionCellIdentifier = @"OptionCell";

static NSString * const kELSegueIdentifier = @"InviteFeedbackParticipants";

#pragma mark - Class Extension

@interface ELCreateInstantFeedbackViewController ()

@property (nonatomic, strong) NSString *selectedAnswerType;
@property (nonatomic, strong) NSMutableArray *mCustomScaleOptions;
@property (nonatomic, strong) NSMutableDictionary *mInstantFeedbackDict;
@property (nonatomic, strong) ELDropdownView *dropdown;
@property (nonatomic, strong) ELFeedbackViewManager *viewManager;
//@property (nonatomic, strong) TNRadioButtonGroup *radioGroup;

@end

@implementation ELCreateInstantFeedbackViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.selectedAnswerType = kELNoQuestionType;
    self.viewManager = [[ELFeedbackViewManager alloc] init];
    self.mCustomScaleOptions = [NSMutableArray arrayWithArray:@[@""]];
    self.mInstantFeedbackDict = [[NSMutableDictionary alloc] init];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    
    [self populatePage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kELSegueIdentifier]) {
        ELInviteUsersViewController *controller = [segue destinationViewController];
        
        controller.inviteType = kELInviteUsersInstantFeedback;
        controller.instantFeedbackDict = self.mInstantFeedbackDict;
        
        if (self.instantFeedback) {
            controller.instantFeedback = self.instantFeedback;
        }
    }
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mCustomScaleOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id option = self.mCustomScaleOptions[indexPath.row];
    
    if ([option isKindOfClass:[NSString class]] && [(NSString *)option length] == 0) {
        ELAddObjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELAddOptionCellIdentifier];
        
        cell.textField.delegate = self;
        
        return cell;
    } else {
        ELItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELOptionCellIdentifier];
        
        cell.tag = indexPath.row;
        cell.delegate = self;
        cell.optionLabel.text = [option isKindOfClass:[NSString class]] ? option : [(ELAnswerOption *)option shortDescription];
        
        return cell;
    }
}

#pragma mark - Protocol Methods (UITextField)

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Add Option
    if (textField.text.length > 0) {
        [self.mCustomScaleOptions insertObject:textField.text atIndex:self.mCustomScaleOptions.count - 1];
        
        // Dynamically adjust scroll view based on table view content
        [self updateOptionsTableView];
        [ELUtils scrollViewToBottom:self.scrollView];
    }
    
    textField.text = @"";
    
    return YES;
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
//    NSMutableArray *mData = [[NSMutableArray alloc] init];
    NSString *buttonLabel = self.instantFeedback ? @"kELAddMoreParticipantsButton" : @"kELSelectParticipantsButton";
    NSString *titleLabel = self.instantFeedback ? @"kELInstantFeedbackTitle" : @"kELCreateInstantFeedbackTitle";
//    NSArray *answerTypes = @[[ELUtils labelByAnswerType:kELAnswerTypeYesNoScale],
//                             [ELUtils labelByAnswerType:kELAnswerTypeText],
//                             [ELUtils labelByAnswerType:kELAnswerTypeOneToTenScale],
//                             [ELUtils labelByAnswerType:kELAnswerTypeCustomScale]];
    
    // Button
    [self.inviteButton setTitle:[NSLocalizedString(buttonLabel, nil) uppercaseString]
                       forState:UIControlStateNormal];
    
    // Title
    self.title = [NSLocalizedString(titleLabel, nil) uppercaseString];
    
    // Radio Group
//    for (NSString *answerType in answerTypes) {
//        TNCircularRadioButtonData *data = [TNCircularRadioButtonData new];
//        BOOL isEqual = [[ELUtils labelByAnswerType:self.instantFeedback.question.answer.type] isEqualToString:answerType];
//        
//        data.selected = !self.instantFeedback ? NO : isEqual;
//        data.identifier = answerType;
//        
//        data.labelText = answerType;
//        data.labelFont = [UIFont fontWithName:@"Lato-Regular" size:14];
//        data.labelColor = [UIColor whiteColor];
//        
//        data.borderColor = [UIColor whiteColor];
//        data.circleColor = [[RNThemeManager sharedManager] colorForKey:kELOrangeColor];
//        data.borderRadius = 15;
//        data.circleRadius = 10;
//        
//        [mData addObject:data];
//    }
//    
//    self.radioGroup = [[TNRadioButtonGroup alloc] initWithRadioButtonData:[mData copy]
//                                                                   layout:TNRadioButtonGroupLayoutVertical];
//    
//    [self.radioGroup setIdentifier:@"Answer Types group"];
//    [self.radioGroup setMarginBetweenItems:15];
//    
//    [self.radioGroup create];
//    [self.radioGroupView addSubview:self.radioGroup];
    
    // Notification to handle selection changes
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onAnswerTypeGroupUpdate:)
//                                                 name:SELECTED_RADIO_BUTTON_CHANGED
//                                               object:self.radioGroup];
}

#pragma mark - Protocol Methods (ELDropdown)

- (void)onDropdownSelectionValueChange:(NSString *)value {
    self.selectedAnswerType = value;
    
    [self toggleOptionsTable];
}

#pragma mark - Protocol Methods (ELItemTableViewCell)

- (void)onDeletionAtRow:(NSInteger)row {
    [self.mCustomScaleOptions removeObjectAtIndex:row];
    
    // Dynamically adjust scroll view based on table view content
    [self updateOptionsTableView];
}

#pragma mark - Private Methods

- (void)adjustScrollViewContentSize {
    CGFloat tableViewContentSizeHeight = (kELCellHeight * self.mCustomScaleOptions.count) + kELCellHeight;
    
    [self.tableViewHeightConstraint setConstant:tableViewContentSizeHeight];
    [self.tableView updateConstraints];
    
    // Set the content size of your scroll view to be the content size of your
    // table view + whatever else you have in the scroll view.
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width,
                                               (kELFormViewHeight + tableViewContentSizeHeight + 30))];
}

- (void)populatePage {
    NSMutableArray *mTypes = [[NSMutableArray alloc] initWithArray:@[[ELUtils labelByAnswerType:kELAnswerTypeYesNoScale],
                                                                     [ELUtils labelByAnswerType:kELAnswerTypeText],
                                                                     [ELUtils labelByAnswerType:kELAnswerTypeOneToTenScale],
                                                                     [ELUtils labelByAnswerType:kELAnswerTypeCustomScale]]];
    
    self.dropdown = [[ELDropdownView alloc] initWithItems:mTypes
                                           baseController:self
                                         defaultSelection:@"No Answer type selected"];
    self.dropdown.delegate = self;
    self.selectedAnswerType = [ELUtils labelByAnswerType:self.instantFeedback.question.answer.type];
    
    // Content
    [self.questionTextView setText:self.instantFeedback.question.text];
    [self.isAnonymousSwitch setOn:self.instantFeedback.anonymous animated:YES];
    [self.isNASwitch setOn:self.instantFeedback.question.isNA animated:YES];
    
    // Dropdown
    [self.dropdown setFrame:self.dropdownView.bounds];
    [self.dropdownView addSubview:self.dropdown];
    
    // Custom Scale option
    [self toggleFormAccessibility];
    [self toggleOptionsTable];
    
    if (self.instantFeedback.question.answer.type != kELAnswerTypeCustomScale) {
        return;
    }
    
    [self.mCustomScaleOptions removeAllObjects];
    [self.mCustomScaleOptions addObjectsFromArray:self.instantFeedback.question.answer.options];
    [self.mCustomScaleOptions addObject:@""];
    
    [self updateOptionsTableView];
}

- (void)toggleFormAccessibility {
    BOOL editable = !self.instantFeedback;
    
    [self.questionTextView setEditable:editable];
    [self.isNASwitch setEnabled:editable];
    [self.isAnonymousSwitch setEnabled:editable];
    [self.tableView setUserInteractionEnabled:editable];
    [self.dropdown setEnabled:editable];
//    [self.radioGroup setUserInteractionEnabled:editable];
}

- (void)toggleOptionsTable {
    BOOL isCustomScale = [self.selectedAnswerType isEqualToString:[ELUtils labelByAnswerType:kELAnswerTypeCustomScale]];
    
    [self.tableViewHeightConstraint setConstant:isCustomScale ? (kELCellHeight * 2) : 0];
    [self.tableView updateConstraints];
}

- (void)updateOptionsTableView {
    [self.tableView reloadData];
    
    // Dynamically adjust scroll view based on table view content
    [self adjustScrollViewContentSize];
}

#pragma mark - Interface Builder Actions

- (IBAction)onInviteButtonClick:(id)sender {
    BOOL isValid, hasSelection;
    ELFormItemGroup *questionGroup = [[ELFormItemGroup alloc] initWithText:self.questionTextView.text
                                                                      icon:nil
                                                                errorLabel:self.questionErrorLabel];
    
    self.mInstantFeedbackDict = [NSMutableDictionary dictionaryWithDictionary:@{@"question": questionGroup,
                                                                                @"anonymous": @(self.isAnonymousSwitch.on),
                                                                                @"isNA": @(self.isNASwitch.on)}];
    
    if ([self.selectedAnswerType isEqualToString:[ELUtils labelByAnswerType:kELAnswerTypeCustomScale]]) {
        [self.mInstantFeedbackDict setObject:self.mCustomScaleOptions forKey:@"options"];
    }
    
    hasSelection = self.dropdown.hasSelection;
    isValid = [self.viewManager validateCreateInstantFeedbackFormValues:self.mInstantFeedbackDict];
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (!(isValid && hasSelection)) {
        return;
    }
    
    [self performSegueWithIdentifier:kELSegueIdentifier sender:self];
}

//#pragma mark - Notifications
//
//- (void)onAnswerTypeGroupUpdate:(NSNotification *)notification {
//    self.selectedAnswerType = self.radioGroup.selectedRadioButton.data.identifier;
//    
//    [self toggleOptionsTable];
//}

@end
