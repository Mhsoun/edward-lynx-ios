//
//  ELCreateInstantFeedbackViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELCreateInstantFeedbackViewController.h"

#pragma mark - Private Constants

static CGFloat const kELCellHeight = 45;
static CGFloat const kELFormViewHeight = 350;
static NSString * const kELNoQuestionType = @"No type selected";
static NSString * const kELAddOptionCellIdentifier = @"AddOptionCell";
static NSString * const kELOptionCellIdentifier = @"OptionCell";

#pragma mark - Class Extension

@interface ELCreateInstantFeedbackViewController ()

@property (nonatomic, strong) NSDictionary *instantFeedbackDict;
@property (nonatomic, strong) ELFeedbackViewManager *viewManager;
@property (nonatomic, strong) NSMutableArray *mScaleOptions;

@end

@implementation ELCreateInstantFeedbackViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.viewManager = [[ELFeedbackViewManager alloc] init];
    self.mScaleOptions = [NSMutableArray arrayWithArray:@[@""]];
    self.questionTypeLabel.text = kELNoQuestionType;
    
    self.tableView.scrollEnabled = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"InviteFeedbackParticipants"]) {
        ELInviteUsersViewController *controller = [segue destinationViewController];
        controller.inviteType = kELInviteUsersInstantFeedback;
        controller.instantFeedbackDict = self.instantFeedbackDict;
    }
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mScaleOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *option = self.mScaleOptions[indexPath.row];
    
    if (option.length == 0) {
        ELAddScaleOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELAddOptionCellIdentifier];
        cell.optionTextField.delegate = self;
        
        return cell;
    } else {
        ELScaleOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELOptionCellIdentifier];
        cell.tag = indexPath.row;
        cell.delegate = self;
        cell.optionLabel.text = option;
        
        return cell;
    }
}

#pragma mark - Protocol Methods (UITextField)

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Add Option
    if (textField.text.length > 0) {
        [self.mScaleOptions insertObject:textField.text atIndex:0];
        [self.tableView reloadData];
        
        // Dynamically adjust scroll view based on table view content
        [self adjustScrollViewContentSize];
        [self scrollToBottom];
    }
    
    textField.text = @"";
    
    return YES;
}

#pragma mark - Protocol Methods (ELScaleOptionTableViewCell)

- (void)onDeletionAtRow:(NSInteger)row {
    [self.mScaleOptions removeObjectAtIndex:row];
    [self.tableView reloadData];
    
    // Dynamically adjust scroll view based on table view content
    [self adjustScrollViewContentSize];
}

#pragma mark - Private Methods

- (void)adjustScrollViewContentSize {
    CGFloat tableViewContentSizeHeight = (kELCellHeight * self.mScaleOptions.count) + kELCellHeight;
    
    [self.tableViewHeightConstraint setConstant:tableViewContentSizeHeight];
    [self.tableView updateConstraints];
    
    // Set the content size of your scroll view to be the content size of your
    // table view + whatever else you have in the scroll view.
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width,
                                               (kELFormViewHeight + tableViewContentSizeHeight + 30))];
}

- (void)scrollToBottom {
    CGRect rect = CGRectMake(self.scrollView.contentSize.width - 1, self.scrollView.contentSize.height - 1, 1, 1);
    
    [self.scrollView scrollRectToVisible:rect animated:YES];
}

#pragma mark - Interface Builder Actions

- (IBAction)onQuestionTypeButtonClick:(id)sender {
    UIAlertController *controller;
    NSArray *answerTypes = @[@(kELAnswerTypeOneToFiveScale), @(kELAnswerTypeOneToTenScale), @(kELAnswerTypeAgreeementScale),
                             @(kELAnswerTypeYesNoScale), @(kELAnswerTypeStrongAgreeementScale), @(kELAnswerTypeText),
                             @(kELAnswerTypeInvertedAgreementScale), @(kELAnswerTypeOneToTenWithExplanation), @(kELAnswerTypeCustomScale)];
    void (^alertActionBlock)(UIAlertAction *) = ^(UIAlertAction *action) {
        CGFloat height = [ELUtils answerTypeByLabel:action.title] == kELAnswerTypeCustomScale ? (kELCellHeight * 2) : 0;
        
        self.questionTypeLabel.text = action.title;
        
        [self.tableViewHeightConstraint setConstant:height];
        [self.tableView updateConstraints];
    };
    
    controller = [UIAlertController alertControllerWithTitle:@"Select preferred Question type"
                                                     message:nil
                                              preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSNumber *answerTypeObj in answerTypes) {
        kELAnswerType answerType = [answerTypeObj integerValue];
        
        [controller addAction:[UIAlertAction actionWithTitle:[ELUtils labelByAnswerType:answerType]
                                                       style:UIAlertActionStyleDefault
                                                     handler:alertActionBlock]];
    }
    
    [controller addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
    
    if (IDIOM == IPAD) {
        UIPopoverPresentationController *popPresenter;
        
        [controller setModalPresentationStyle:UIModalPresentationPopover];
        
        popPresenter = [controller popoverPresentationController];
        popPresenter.sourceView = (UIButton *)sender;
        popPresenter.sourceRect = [(UIButton *)sender bounds];
    }
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)onInviteButtonClick:(id)sender {
    BOOL isValid;
    ELFormItemGroup *typeGroup, *questionGroup;
    
    typeGroup = [[ELFormItemGroup alloc] initWithText:self.questionTypeLabel.text
                                                 icon:nil
                                           errorLabel:self.questionTypeErrorLabel];
    questionGroup = [[ELFormItemGroup alloc] initWithText:self.questionTextView.text
                                                     icon:nil
                                               errorLabel:self.questionErrorLabel];
    self.instantFeedbackDict = @{@"type": typeGroup,
                                 @"question": questionGroup,
                                 @"anonymous": @(self.isAnonymousSwitch.on),
                                 @"isNA": @(self.isNASwitch.on)};
    isValid = [self.viewManager validateCreateInstantFeedbackFormValues:self.instantFeedbackDict];
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (!isValid) {
        return;
    }
    
    [self performSegueWithIdentifier:@"InviteFeedbackParticipants" sender:self];
}

@end
