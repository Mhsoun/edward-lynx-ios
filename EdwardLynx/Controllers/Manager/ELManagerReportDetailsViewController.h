//
//  ELManagerReportDetailsViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/07/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"

@interface ELManagerReportDetailsViewController : ELBaseViewController<MFMailComposeViewControllerDelegate, UIWebViewDelegate>

@property (strong, nonatomic) NSDictionary *detailDict;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendEmailBarButtonItem;
- (IBAction)onSendEmailBarButtonItemClick:(id)sender;

@end
