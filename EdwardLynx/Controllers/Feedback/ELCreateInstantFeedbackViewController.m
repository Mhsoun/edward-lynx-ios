//
//  ELCreateInstantFeedbackViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UITextView+Placeholder/UITextView+Placeholder.h>

#import "ELCreateInstantFeedbackViewController.h"
#import "ELAddObjectTableViewCell.h"
#import "ELBaseQuestionTypeView.h"
#import "ELDropdownView.h"
#import "ELFeedbackViewManager.h"
#import "ELInstantFeedback.h"
#import "ELInviteUsersViewController.h"
#import "ELItemTableViewCell.h"

#pragma mark - Private Constants

static CGFloat const kELCellHeight = 50;
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
    
    self.questionTextView.delegate = self;
    self.questionTextView.placeholder = NSLocalizedString(@"kELCreateTextViewPlaceholderLabel", nil);
    
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    
    RegisterNib(self.tableView, kELAddOptionCellIdentifier);
    RegisterNib(self.tableView, kELOptionCellIdentifier);
    
    [self populatePage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.dropdown.delegate = self;
    self.dropdown.baseController = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.dropdown reset];
}

- (void)dealloc {
    DLog(@"%@", [self class]);
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
        ELAddObjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELAddOptionCellIdentifier
                                                                         forIndexPath:indexPath];
        
        cell.delegate = self;
        
        return cell;
    } else {
        ELItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELOptionCellIdentifier
                                                                    forIndexPath:indexPath];
        
        cell.tag = indexPath.row;
        cell.delegate = self;
        cell.optionLabel.text = [option isKindOfClass:[NSString class]] ? option : [(ELAnswerOption *)option shortDescription];
        
        return cell;
    }
}

#pragma mark - Protocol Methods (UITextView)

- (void)textViewDidChange:(UITextView *)textView {
    self.questionPreviewLabel.text = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [[IQKeyboardManager sharedManager] resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - Protocol Methods (ELAddItem)

- (void)onAddNewItem:(NSString *)item {
    [self.mCustomScaleOptions insertObject:item atIndex:self.mCustomScaleOptions.count - 1];
    
    // Dynamically adjust scroll view based on table view content
    [self updateOptionsTableView];
    [self toggleQuestionTypePreview];
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    self.navigationItem.title = [self.navigationItem.title uppercaseString];
    
    // Button
    [self.inviteButton setTitle:NSLocalizedString(@"kELInviteParticipantsButton", nil)
                       forState:UIControlStateNormal];
    
    // Title
    if (self.instantFeedback) {
        self.title = [NSLocalizedString(@"kELInstantFeedbackTitle", nil) uppercaseString];
    } else {
        self.title = [NSLocalizedString(@"kELCreateInstantFeedbackTitle", nil) uppercaseString];
    }
}

#pragma mark - Protocol Methods (ELDropdown)

- (void)onDropdownSelectionValueChange:(NSString *)value index:(NSInteger)index {
    self.selectedAnswerType = value;
    
    // Update page
    [self toggleOptionsTableView];
    [self toggleQuestionTypePreview];
}

#pragma mark - Protocol Methods (ELItemTableViewCell)

- (void)onDeletionAtRow:(NSInteger)row {
    [self.mCustomScaleOptions removeObjectAtIndex:row];
    
    // Dynamically adjust scroll view based on table view content
    [self updateOptionsTableView];
    [self toggleQuestionTypePreview];
}

#pragma mark - Private Methods

- (void)adjustScrollViewContentSize {
    BOOL isCustomScale = [self.selectedAnswerType isEqualToString:[ELUtils labelByAnswerType:kELAnswerTypeCustomScale]];
    CGFloat tableHeight = (kELCellHeight * self.mCustomScaleOptions.count) + kELCellHeight;
    CGFloat tableViewContentSizeHeight = isCustomScale ? tableHeight : 0;
    
    [self.tableViewHeightConstraint setConstant:tableViewContentSizeHeight];
    [self.tableView updateConstraints];
    
    // Set the content size of your scroll view to be the content size of your
    // table view + whatever else you have in the scroll view.
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width,
                                               (self.heightConstraint.constant + tableViewContentSizeHeight + 30))];
}

- (void)populatePage {
    NSMutableArray *mTypes = [[NSMutableArray alloc] initWithArray:@[[ELUtils labelByAnswerType:kELAnswerTypeYesNoScale],
                                                                     [ELUtils labelByAnswerType:kELAnswerTypeText],
                                                                     [ELUtils labelByAnswerType:kELAnswerTypeOneToTenScale],
                                                                     [ELUtils labelByAnswerType:kELAnswerTypeCustomScale]]];
    
    self.dropdown = [[ELDropdownView alloc] initWithItems:mTypes
                                           baseController:self
                                         defaultSelection:nil];
    self.selectedAnswerType = !self.instantFeedback ? [ELUtils labelByAnswerType:kELAnswerTypeYesNoScale] :
                                                      [ELUtils labelByAnswerType:self.instantFeedback.question.answer.type];
    
    // Content
    [self.questionTextView setText:self.instantFeedback.question.text];
    [self.isAnonymousSwitch setOn:self.instantFeedback.anonymous animated:YES];
    [self.isNASwitch setOn:self.instantFeedback.question.isNA animated:YES];
    
    // Dropdown
    [self.dropdown setFrame:self.dropdownView.bounds];
    [self.dropdownView addSubview:self.dropdown];
    
    // Question Preview
    [self toggleQuestionTypePreview];
    
    // Custom Scale option
    [self toggleFormAccessibility];
    [self toggleOptionsTableView];
    
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
}

- (void)toggleOptionsTableView {
    CGFloat height;
    BOOL isCustomScale = [self.selectedAnswerType isEqualToString:[ELUtils labelByAnswerType:kELAnswerTypeCustomScale]];
    
    height = (kELCellHeight * self.mCustomScaleOptions.count) + kELCellHeight;
    
    [self.tableViewHeightConstraint setConstant:isCustomScale ? height : 0];
    [self.tableView updateConstraints];
}

- (void)toggleQuestionTypePreview {
    CGFloat height;
    __kindof ELBaseQuestionTypeView *questionView;
    kELAnswerType answerType = [ELUtils answerTypeByLabel:self.selectedAnswerType];
    ELQuestion *question = [ELUtils questionTemplateForAnswerType:answerType];
    
    self.isNAView.hidden = answerType == kELAnswerTypeText;
    
    if (answerType != kELAnswerTypeText) {
        NSMutableArray *mOptions = [[NSMutableArray alloc] initWithArray:question.answer.options];
        
        // Add Custom scale options to the question template for preview
        if (answerType == kELAnswerTypeCustomScale) {
            for (int i = 0; i < self.mCustomScaleOptions.count; i++) {
                NSString *option = self.mCustomScaleOptions[i];
                
                if (option.length == 0) {
                    continue;
                }
                
                [mOptions addObject:[[ELAnswerOption alloc] initWithDictionary:@{@"description": option, @"value": @(i)}
                                                                         error:nil]];
            }
        }
        
        question.isNA = self.isNASwitch.on;
        question.answer.options = [mOptions copy];
    }
    
    // Setup ELQuestionView
    questionView = [ELUtils viewByAnswerType:[ELUtils answerTypeByLabel:self.selectedAnswerType]];
    questionView.frame = self.questionPreview.bounds;
    questionView.userInteractionEnabled = NO;
    questionView.question = question;
    
    height = question.answer.options.count == 0 && answerType != kELAnswerTypeText ? kELCellHeight :
                                                                                     question.heightForQuestionView;
    
    [self updateQuestionTypePreviewWithHeight:height];
    
    [self.questionPreview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.questionPreview addSubview:questionView];
    [self.questionPreview.subviews makeObjectsPerformSelector:@selector(setNeedsDisplay)];
}

- (void)updateOptionsTableView {
    [self.tableView reloadData];
    
    // Dynamically adjust scroll view based on table view content
    [self adjustScrollViewContentSize];
}

- (void)updateQuestionTypePreviewWithHeight:(CGFloat)height {
    [self.heightConstraint setConstant:height + CGRectGetHeight(self.questionPreviewLabel.frame) + 15];
    [self.questionPreview updateConstraints];
}

#pragma mark - Interface Builder Actions

- (IBAction)onNAOptionSwitchValueChange:(id)sender {
    kELAnswerType answerType = [ELUtils answerTypeByLabel:self.selectedAnswerType];
    
    if (answerType == kELAnswerTypeText) {
        return;
    }
    
    [self toggleQuestionTypePreview];
}

- (IBAction)onInviteButtonClick:(id)sender {
    BOOL isValid, hasSelection;
    NSArray *validOptions;
    ELFormItemGroup *questionGroup = [[ELFormItemGroup alloc] initWithText:self.questionTextView.text
                                                                      icon:nil
                                                                errorLabel:self.questionErrorLabel];
    
    self.mInstantFeedbackDict = [NSMutableDictionary dictionaryWithDictionary:@{@"type": self.selectedAnswerType,
                                                                                @"question": questionGroup,
                                                                                @"anonymous": @(self.isAnonymousSwitch.on),
                                                                                @"isNA": @(self.isNASwitch.on)}];
    
    if ([self.selectedAnswerType isEqualToString:[ELUtils labelByAnswerType:kELAnswerTypeCustomScale]]) {
        validOptions = [self.mCustomScaleOptions subarrayWithRange:NSMakeRange(0, self.mCustomScaleOptions.count - 1)];
        
        if (validOptions.count == 0 ) {
            [ELUtils presentToastAtView:self.view
                                message:NSLocalizedString(@"kELCustomScaleValidationMessage", nil)
                             completion:nil];
        }
        
        [self.mInstantFeedbackDict setObject:validOptions forKey:@"options"];
    }
    
    hasSelection = self.dropdown.hasSelection;
    isValid = [self.viewManager validateCreateInstantFeedbackFormValues:self.mInstantFeedbackDict];
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (!(isValid && hasSelection)) {
        return;
    }
    
    [self performSegueWithIdentifier:kELSegueIdentifier sender:self];
}

@end
