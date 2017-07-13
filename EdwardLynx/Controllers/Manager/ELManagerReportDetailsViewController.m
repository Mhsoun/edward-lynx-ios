//
//  ELManagerReportDetailsViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/07/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELManagerReportDetailsViewController.h"
#import "ELAPIClient.h"

@implementation ELManagerReportDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    CGFloat size;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    size = 20;
    self.title = [self.detailDict[@"name"] uppercaseString];
    
    [self.sendEmailBarButtonItem setImage:[FontAwesome imageWithIcon:fa_envelope
                                                           iconColor:ThemeColor(kELOrangeColor)
                                                            iconSize:size
                                                           imageSize:CGSizeMake(size, size)]];
    
    [self.webView setDelegate:self];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailDict[@"link"]]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (UIWebView)

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.indicatorView stopAnimating];
}

#pragma mark - Interface Builder Actions

- (IBAction)onSendEmailBarButtonItemClick:(id)sender {
    NSDictionary *emailDict = @{@"title": self.detailDict[@"name"],
                                @"body": self.detailDict[@"link"],
                                @"recipients": @[AppSingleton.user.email]};
    
    [NotificationCenter postNotificationName:kELManagerReportEmailNotification
                                      object:nil
                                    userInfo:emailDict];
}

@end
