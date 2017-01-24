//
//  ELProfileViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELProfileViewController.h"

#pragma mark - Class Extension

@interface ELProfileViewController ()

@property (nonatomic, strong) NSString *selectedGender;
@property (nonatomic, strong) TNRadioButtonGroup *radioGroup;

@end

@implementation ELProfileViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Populate with user information
    [self populatePage];
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    NSMutableArray *mData = [[NSMutableArray alloc] init];
    NSArray *genders = @[@"Male", @"Female", @"Other"];
    
    // Radio Group
    for (int i = 0; i < genders.count; i++) {
        NSString *genderType = genders[i];
        TNCircularRadioButtonData *data = [TNCircularRadioButtonData new];
        
        data.selected = i == 0;
        data.identifier = [genderType lowercaseString];
        
        data.labelText = genderType;
        data.labelFont = [UIFont fontWithName:@"Lato-Regular" size:14];
        data.labelColor = [UIColor whiteColor];
        
        data.borderColor = [UIColor whiteColor];
        data.circleColor = [UIColor whiteColor];
        data.borderRadius = 15;
        data.circleRadius = 10;
        
        [mData addObject:data];
    }
    
    self.radioGroup = [[TNRadioButtonGroup alloc] initWithRadioButtonData:[mData copy]
                                                                   layout:TNRadioButtonGroupLayoutVertical];
    
    [self.radioGroup setIdentifier:@"Gender group"];
    [self.radioGroup setMarginBetweenItems:15];
    
    [self.radioGroup create];
    [self.radioGroupView addSubview:self.radioGroup];
    
    // Notification to handle selection changes
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onGenderTypeGroupUpdate:)
                                                 name:SELECTED_RADIO_BUTTON_CHANGED
                                               object:self.radioGroup];
}

#pragma mark - Private Methods

- (void)populatePage {
    ELUser *user = [ELAppSingleton sharedInstance].user;
    
    self.nameTextField.text = user.name;
    self.emailTextField.text = user.email;
}

#pragma mark - Notifications

- (void)onGenderTypeGroupUpdate:(NSNotification *)notification {
    self.selectedGender = self.radioGroup.selectedRadioButton.data.identifier;
}

@end
