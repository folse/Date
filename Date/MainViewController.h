//
//  MainViewController.h
//  Date
//
//  Created by folse on 8/9/13.
//  Copyright (c) 2013 folse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MainViewController : UIViewController<MBProgressHUDDelegate, UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webview;


@end
