//
//  ELDevelopmentPlansViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 03/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELDevelopmentPlansViewController.h"
#import "ELDevelopmentPlan.h"
#import "ELDevelopmentPlanDetailsViewController.h"
#import "ELListViewController.h"

#pragma mark - Private Constants

static NSString * const kELListSegueIdentifier = @"ListContainer";
static NSString * const kELDetailsSegueIdentifier = @"DevelopmentPlanDetail";

#pragma mark - Class Extension

@interface ELDevelopmentPlansViewController ()

@property (nonatomic, strong) ELDevelopmentPlan *selectedDevPlan;

@end

@implementation ELDevelopmentPlansViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    if ([segue.identifier isEqualToString:kELDetailsSegueIdentifier]) {
        ELDevelopmentPlanDetailsViewController *controller = (ELDevelopmentPlanDetailsViewController *)[segue destinationViewController];
        
        controller.objectId = self.selectedDevPlan.objectId;
    } else if ([segue.identifier isEqualToString:kELListSegueIdentifier]) {
        ELListViewController *controller = (ELListViewController *)[segue destinationViewController];
        
        controller.delegate = self;
        controller.listType = kELListTypeDevPlan;
        controller.listFilter = [self.tabs[self.index] integerValue];
    }
}

#pragma mark - Protocol Methods (ELListViewController)

- (void)onRowSelection:(__kindof ELModel *)object {
    self.selectedDevPlan = (ELDevelopmentPlan *)object;
    
    [self performSegueWithIdentifier:kELDetailsSegueIdentifier sender:self];
}

#pragma mark - Protocol Methods (XLPagerTabStrip)

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController {
    return [[ELUtils labelByListFilter:[self.tabs[self.index] integerValue]] uppercaseString];
}

@end
