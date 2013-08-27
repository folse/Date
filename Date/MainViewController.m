//
//  MainViewController.m
//  Date
//
//  Created by folse on 8/9/13.
//  Copyright (c) 2013 folse. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

@interface MainViewController ()

@end

@implementation MainViewController

MBProgressHUD *HUD;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (USER_LOGIN) {
        
        [self loadWebPage];
                    
    }else {
            
        [self performSegueWithIdentifier:@"LoginFromMain" sender:self];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_webview setDelegate:self];
    
    
}
- (IBAction)swipeAction:(id)sender {
    
    [self menuBtnAction:self];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = self;
    [HUD setLabelText:@"正在读取资料..."];
    [self.view addSubview:HUD];
    [HUD show:YES];
    
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
    
    [HUD hide:YES];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError:%@", error);
    
    [HUD hide:YES];
}
         
- (void)loadWebPage
{
    NSURL *url = [NSURL URLWithString:@"http://dev.zh.ongl.in/client/calendar"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSString *sessionId = [USER valueForKey:@"sessionId"];
    NSString *sessionIdString = [NSString stringWithFormat:@"sessionid=%@", sessionId];;
    [request setValue:sessionIdString forHTTPHeaderField:@"Cookie"];
    [_webview loadRequest:request];
}
         
         
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnAction:(id)sender {
    
    [_webview goBack];
}

- (IBAction)menuBtnAction:(id)sender
{
    if (!_sideMenu) {
        RESideMenuItem *homeItem = [[RESideMenuItem alloc] initWithTitle:@"首页" action:^(RESideMenu *menu, RESideMenuItem *item) {
            
            [menu hide];
        }];
        
        RESideMenuItem *logOutItem = [[RESideMenuItem alloc] initWithTitle:@"注销" action:^(RESideMenu *menu, RESideMenuItem *item) {
            
            [menu hide];
            
            [USER setBool:NO forKey:@"userLogined"];
            
            [self performSegueWithIdentifier:@"LoginFromMain" sender:self];
        }];
        
        _sideMenu = [[RESideMenu alloc] initWithItems:@[homeItem,logOutItem]];
        _sideMenu.verticalOffset = IS_WIDESCREEN ? 110 : 76;
        
    }
    
    [_sideMenu show];
}

@end
