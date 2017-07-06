//
//  ELManagerReportDetailsViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/07/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"

@interface ELManagerReportDetailsViewController : ELBaseViewController<UIWebViewDelegate>

@property (strong, nonatomic) NSString *link;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end
