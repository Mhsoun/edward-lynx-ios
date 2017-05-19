//
//  ELCreateInstantFeedbackViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELCreateInstantFeedbackViewController.h"
#import "ELAddObjectTableViewCell.h"
#import "ELBaseQuestionTypeView.h"
#import "ELDropdownView.h"
#import "ELFeedbackViewManager.h"
#import "ELInstantFeedback.h"
#import "ELInviteUsersViewController.h"
#import "ELItemTableViewCell.h"

#pragma mark - Private Constants

static CGFloat const kELCellHeight = 45;
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
        [self toggleQuestionTypePreview];
        [ELUtils scrollViewToBottom:self.scrollView];
    }
    
    textField.text = @"";
    
    return YES;
}

#pragma mark - Protocol Methods (UITextView)

- (void)textViewDidChange:(UITextView *)textView {
    self.questionPreviewLabel.text = textView.text;
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    NSString *titleLabel = self.instantFeedback ? @"kELInstantFeedbackTitle" : @"kELCreateInstantFeedbackTitle";
    
    // Button
    [self.inviteButton setTitle:NSLocalizedString(@"kELInviteParticipantsButton", nil) forState:UIControlStateNormal];
    
    // Title
    self.title = [NSLocalizedString(titleLabel, nil) uppercaseString];
}

#pragma mark - Protocol Methods (ELDropdown)

- (void)onDropdownSelectionValueChange:(NSString *)value {
    self.selectedAnswerType = value;
    
    [self toggleOptionsTable];
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

- (void)drawDashedBorderAroundView:(UIView *)view {
    CGFloat cornerRadius = 10, borderWidth = 2.5;
    CGRect frame = view.bounds;
    CGMutablePathRef path = CGPathCreateMutable();
    NSInteger dashPattern1 = 8, dashPattern2 = 8;
    UIColor *lineColor = [UIColor lightGrayColor];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    // Drawing a border around a view
    CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
    CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    // Path is set as the shapeLayer object's path
    shapeLayer.path = path;
    CGPathRelease(path);
    
    shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    shapeLayer.frame = frame;
    shapeLayer.masksToBounds = NO;
    
    [shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.strokeColor = [lineColor CGColor];
    shapeLayer.lineWidth = borderWidth;
    shapeLayer.lineDashPattern = [NSArray arrayWithObjects:
                                  [NSNumber numberWithInteger:dashPattern1],
                                  [NSNumber numberWithInteger:dashPattern2],
                                  nil];
    shapeLayer.lineCap = kCALineCapRound;
    
    // shapeLayer is added as a sublayer of the view, the border is visible
    view.layer.cornerRadius = cornerRadius;
    
    [view.layer addSublayer:shapeLayer];
}

- (void)populatePage {
    NSMutableArray *mTypes = [[NSMutableArray alloc] initWithArray:@[[ELUtils labelByAnswerType:kELAnswerTypeYesNoScale],
                                                                     [ELUtils labelByAnswerType:kELAnswerTypeText],
                                                                     [ELUtils labelByAnswerType:kELAnswerTypeOneToTenScale],
                                                                     [ELUtils labelByAnswerType:kELAnswerTypeCustomScale]]];
    
    self.dropdown = [[ELDropdownView alloc] initWithItems:mTypes
                                           baseController:self
                                         defaultSelection:nil];
    self.dropdown.delegate = self;
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
}

- (void)toggleOptionsTable {
    BOOL isCustomScale = [self.selectedAnswerType isEqualToString:[ELUtils labelByAnswerType:kELAnswerTypeCustomScale]];
    
    [self.tableViewHeightConstraint setConstant:isCustomScale ? (kELCellHeight * 2) : 0];
    [self.tableView updateConstraints];
}

- (void)toggleQuestionTypePreview {
    CGFloat height;
    __kindof ELBaseQuestionTypeView *questionView;
    kELAnswerType answerType = [ELUtils answerTypeByLabel:self.selectedAnswerType];
    ELQuestion *question = [ELUtils questionTemplateForAnswerType:answerType];
    
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
        
        if (self.isNASwitch.isOn) {
            [mOptions addObject:[[ELAnswerOption alloc] initWithDictionary:@{@"description": @"N/A", @"value": @(-1)}
                                                                     error:nil]];
        }
        
        question.answer.options = [mOptions copy];
    }
    
    // Setup QuestionView
    questionView = [ELUtils viewByAnswerType:[ELUtils answerTypeByLabel:self.selectedAnswerType]];
    questionView.frame = self.questionPreview.bounds;
    questionView.userInteractionEnabled = NO;
    questionView.question = question;
    
    height = question.answer.options.count == 0 && answerType != kELAnswerTypeText ? kELCellHeight :
                                                                                     question.heightForQuestionView;
    
    [self.heightConstraint setConstant:height + (CGRectGetHeight(self.questionPreviewLabel.frame) * 1.5)];
    [self.formView updateConstraints];
    [self adjustScrollViewContentSize];
    
    [self.questionPreview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.questionPreview addSubview:questionView];
    [self.questionPreview.subviews makeObjectsPerformSelector:@selector(setNeedsDisplay)];
    
    // TODO Draw dotted line
//    for (CALayer *layer in [self.questionContainerView.layer.sublayers copy]) {
//        if ([layer isKindOfClass:[CAShapeLayer class]]) {
//            [layer removeFromSuperlayer];
//            
//            break;
//        }
//    }
//    
//    [self drawDashedBorderAroundView:self.questionContainerView];
}

- (void)updateOptionsTableView {
    [self.tableView reloadData];
    
    // Dynamically adjust scroll view based on table view content
    [self adjustScrollViewContentSize];
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
    ELFormItemGroup *questionGroup = [[ELFormItemGroup alloc] initWithText:self.questionTextView.text
                                                                      icon:nil
                                                                errorLabel:self.questionErrorLabel];
    
    self.mInstantFeedbackDict = [NSMutableDictionary dictionaryWithDictionary:@{@"type": self.selectedAnswerType,
                                                                                @"question": questionGroup,
                                                                                @"anonymous": @(self.isAnonymousSwitch.on),
                                                                                @"isNA": @(self.isNASwitch.on)}];
    
    if ([self.selectedAnswerType isEqualToString:[ELUtils labelByAnswerType:kELAnswerTypeCustomScale]]) {
        [self.mCustomScaleOptions removeObject:@""];
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

@end
