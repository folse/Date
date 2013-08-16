//
//  MainViewController.m
//  Date
//
//  Created by folse on 8/9/13.
//  Copyright (c) 2013 folse. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidAppear:(BOOL)animated
{
    if (!USER_LOGIN) {
        [self performSegueWithIdentifier:@"LoginFromMain" sender:self];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"http://dev.zh.ongl.in/client/calendar"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
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

@end
