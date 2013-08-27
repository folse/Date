//
//  MainViewController.h
//  Date
//
//  Created by folse on 8/9/13.
//  Copyright (c) 2013 folse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

#import "RESideMenu.h"

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface MainViewController : UIViewController<MBProgressHUDDelegate, UIWebViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webview;

@property (strong, readonly, nonatomic) RESideMenu *sideMenu;




@end
