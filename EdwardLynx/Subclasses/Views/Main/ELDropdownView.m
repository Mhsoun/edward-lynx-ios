//
//  ELDropdownView.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDropdownView.h"
#import "ELListPopupViewController.h"

#pragma mark - Private Constants

static CGFloat const kELIconSize = 15;

#pragma mark - Class Extension

@interface ELDropdownView ()

@property (nonatomic) BOOL hasValidation;

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSString *selectedItem;
@property (strong, nonatomic) __kindof ELBaseViewController *baseController;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ELDropdownView

@synthesize enabled = _enabled;
@synthesize hasSelection = _hasSelection;

#pragma mark - Lifecycle

- (instancetype)initWithItems:(NSMutableArray *)items
               baseController:(__kindof ELBaseViewController *)controller
             defaultSelection:(NSString *)defaultSelection {
    NSArray *elements;
    
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    elements = [[NSBundle mainBundle] loadNibNamed:@"DropdownView"
                                             owner:self
                                           options:nil];
    
    for (id anObject in elements) {
        if ([anObject isKindOfClass:[self class]]) {
            self = anObject;
            
            break;
        }
    }
    
    self.hasValidation = NO;
    
    if (defaultSelection) {
        self.hasValidation = YES;
        
        [items insertObject:defaultSelection atIndex:0];
    }
    
    self.items = [items copy];
    self.baseController = controller;
    self.delegate = controller;
    
    _hasSelection = !self.hasValidation;
    
    [self setupContent];
    
    return self;
}

- (void)reset {
    self.baseController = nil;
    self.delegate = nil;
}

#pragma mark - Getters/Setters

- (BOOL)enabled {
    return _enabled;
}

- (BOOL)hasSelection {
    self.errorLabel.hidden = _hasSelection;
     
    return _hasSelection;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    
    self.button.enabled = enabled;
}

- (void)setHasSelection:(BOOL)hasSelection {
    _hasSelection = hasSelection;
}

#pragma mark - Protocol Methods (ELListPopup)

- (void)onItemSelection:(NSString *)item {
    self.titleLabel.text = item;
    self.selectedItem = item;
    
    _hasSelection = self.hasValidation ? ![self.selectedItem isEqualToString:self.items[0]] : YES;
    
    [self.delegate onDropdownSelectionValueChange:self.selectedItem];
}

#pragma mark - Private Methods

- (UIAlertController *)itemsAlertController {
    __weak typeof(self) weakSelf = self;
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    void (^actionBlock)(UIAlertAction *) = ^(UIAlertAction *action) {
        weakSelf.titleLabel.text = action.title;
        weakSelf.selectedItem = action.title;
        
        _hasSelection = weakSelf.hasValidation ? ![weakSelf.selectedItem isEqualToString:weakSelf.items[0]] : YES;
        
        [weakSelf.delegate onDropdownSelectionValueChange:weakSelf.selectedItem];
    };
    
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"kELCancelButton", nil)
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
    
    for (NSString *title in self.items) {
        [controller addAction:[UIAlertAction actionWithTitle:title
                                                       style:UIAlertActionStyleDefault
                                                     handler:actionBlock]];
    }
    
    return controller;
}

- (void)setDefaultValue:(NSString *)value {
    self.titleLabel.text = value;
}

- (void)setupContent {
    // Content
    self.selectedItem = self.items[0];
    self.errorLabel.text = self.items[0];
    self.titleLabel.text = self.items[0];
    
    // UI
    [self.button setImage:[FontAwesome imageWithIcon:fa_chevron_down
                                           iconColor:[[RNThemeManager sharedManager] colorForKey:kELDarkVioletColor]
                                            iconSize:kELIconSize
                                           imageSize:CGSizeMake(kELIconSize, kELIconSize)]
                 forState:UIControlStateNormal];
    [self.button setTintColor:[[RNThemeManager sharedManager] colorForKey:kELDarkVioletColor]];
}

#pragma mark - Interface Builder Actions

- (IBAction)onDropdownButtonClick:(id)sender {
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    [ELUtils displayPopupForViewController:self.baseController
                                      type:kELPopupTypeList
                                   details:@{@"title": @"",
                                             @"items": self.items,
                                             @"delegate": self}];
}

@end
