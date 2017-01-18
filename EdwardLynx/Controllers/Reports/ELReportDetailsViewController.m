//
//  ELReportDetailsViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELReportDetailsViewController.h"

#pragma mark - Class Extension

@interface ELReportDetailsViewController ()

@property (nonatomic, strong) ELDetailViewManager *viewManager;

@end

@implementation ELReportDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewManager = [[ELDetailViewManager alloc] init];
    self.viewManager.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShareReport"]) {
        ELInviteUsersViewController *controller = (ELInviteUsersViewController *)[segue destinationViewController];
        controller.inviteType = kELInviteUsersReports;
        controller.instantFeedback = self.instantFeedback;
    }
}

#pragma mark - Protocol Methods (ELDetailViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    //
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    //
}

#pragma mark - Interface Builder Actions

- (IBAction)onShareButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"ShareReport" sender:self];
}

@end
