//
//  LoginController.m
//  Date
//
//  Created by folse on 8/9/13.
//  Copyright (c) 2013 folse. All rights reserved.
//

#import "LoginController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@interface LoginController ()

@end

@implementation LoginController

AFJSONRequestOperation *operation;
NSString *mobile;
NSString *password;
MBProgressHUD *HUD;
NSString *inputType = @"mobile";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [_inputTF becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (IBAction)textFieldListener {
    
    if ([inputType isEqualToString:@"mobile"]) {
        
        if (_inputTF.text.length == 11) {
            
            [_inputTF resignFirstResponder];
            
            mobile = _inputTF.text;
            
            [self userInit];
        }
        
    }else if ([inputType isEqualToString:@"password"]){
        
        [_loginBtn setHidden:NO];
    }
}

- (void)userInit
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = self;
    [HUD setLabelText:@"正在获取您的资料..."];
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc] init];
    [parameterDict setObject:mobile forKey:@"mobile"];
    
    NSURL *url = [NSURL URLWithString:@"http://dev.zh.ongl.in"];
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSURLRequest* request = [httpClient requestWithMethod:@"POST" path:@"/client/init" parameters:parameterDict];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        s(JSON);
        
        if ([[JSON valueForKey:@"ret"] integerValue] == 0) {
            
            [HUD hide:YES];
            
            [_inputTF setPlaceholder:@"请输入密码"];
            
        }else if ([[JSON valueForKey:@"ret"] integerValue] == 1){
            
            [HUD hide:YES];
            
            [_inputTF setPlaceholder:@"请设置密码"];
            
            [_loginBtn setTitle:@"注册" forState:UIControlStateNormal];
        
        }else {
        
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在商家绑定后继续" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            
            [alertView show];
            
        }
        [self setTextField];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    
    [operation start];
    
}

- (void)setTextField
{
    [_inputTF setText:@""];
    
    [_inputTF setKeyboardType:UIKeyboardTypeDefault];
    
    [_inputTF becomeFirstResponder];
    
    inputType = @"password";
}

- (IBAction)loginBtnAction:(id)sender {
    
    password = _inputTF.text;
    
    [_inputTF resignFirstResponder];
    
    [self userLogin];
    
}

- (void)userLogin
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = self;
    [HUD setLabelText:@"正在为您登录..."];
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc] init];
    [parameterDict setObject:mobile forKey:@"mobile"];
    [parameterDict setObject:password forKey:@"password"];
    
    NSURL *url = [NSURL URLWithString:@"http://dev.zh.ongl.in"];
    AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSURLRequest* request = [httpClient requestWithMethod:@"POST" path:@"/client/login" parameters:parameterDict];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        s(JSON);
        
        if ([[JSON valueForKey:@"ret"] integerValue] == 0) {
            
            [USER setBool:YES forKey:@"userLogined"];
            
            [HUD hide:YES];
            
            s([JSON valueForKey:@"sessionid"]);
            
            NSString *sessionId = [JSON valueForKey:@"sessionid"];
            
            [USER setValue:sessionId forKey:@"sessionId"];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    
    [operation start];
    
}

@end
