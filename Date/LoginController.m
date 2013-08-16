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

@interface LoginController ()<TencentSessionDelegate,MBProgressHUDDelegate,UMSocialDataDelegate>

@end

@implementation LoginController

AFJSONRequestOperation *operation;
NSString *openUserName;
NSString *openUserAvatar;
NSString *openUserId;
MBProgressHUD *HUD;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sinaLoginBtn:(id)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        NSLog(@"response is %@",response);
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.delegate = self;
        [HUD setLabelText:@"正在进入..."];
        [self.view addSubview:HUD];
        [HUD show:YES];
        
        [_qqLoinnBtn setHidden:YES];
        
        [_sinaLoinnBtn setHidden:YES];
        
        
        NSString *responseType = [response valueForKey:@"responseType"];
        
        NSDictionary *dataDic = [response valueForKey:@"data"];
        NSDictionary *sinaDic = [dataDic valueForKey:@"sina"];
        
        s(responseType)
        if([responseType integerValue] == 9){
            
            NSDictionary *userDic = [sinaDic valueForKey:@"username"];
            
            openUserName = [userDic valueForKey:@"userName"];
            openUserAvatar = [userDic valueForKey:@"iconURL"];
            openUserId = [NSString stringWithFormat:@"sina%@",[userDic valueForKey:@"usid"]];
            
        }else if ([responseType integerValue] == 10){
            
            openUserName = [sinaDic valueForKey:@"username"];
            openUserAvatar = [sinaDic valueForKey:@"icon"];
            openUserId = [NSString stringWithFormat:@"sina%@",[sinaDic valueForKey:@"usid"]];
            
        }else {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"微博授权失败" message:@"新浪微博在维护中，请使用QQ登录或稍后再试" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
            
            [HUD hide:YES];
            
            
            return ;
        }
        
        [USER setValue:openUserId forKey:@"OpenId"];
        
        [self userLogin];
    });
    
}

-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    if (response.viewControllerType == UMSViewControllerOauth) {
        NSLog(@"didFinishOauthAndGetAccount response is %@",response);
    }
}

- (IBAction)qqLoginBtn:(id)sender {
    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"222222" andDelegate:self];
	_tencentOAuth.redirectURI = @"www.qq.com";
    
    _permissions =  [NSArray arrayWithObjects:
                     @"get_user_info",@"add_share",nil] ;
    
    if ([USER objectForKey:@"AccessToken"]){
        [_tencentOAuth setAccessToken:[USER objectForKey:@"AccessToken"]];
    }
    if ([USER objectForKey:@"OpenId"]) {
        [_tencentOAuth setOpenId:[USER objectForKey:@"OpenId"]];
    }
    if ([USER objectForKey:@"ExpirationDate"]) {
        [_tencentOAuth setExpirationDate:[USER objectForKey:@"ExpirationDate"]];
    }
    
    [_tencentOAuth authorize:_permissions inSafari:NO];
    
}

- (void)tencentDidLogin {
	NSLog(@"登录成功");
    if ([_tencentOAuth accessToken]!=nil) {
        [USER setValue:[_tencentOAuth accessToken] forKey:@"AccessToken"];
    }
    if ([_tencentOAuth openId]!=nil) {
        [USER setValue:[_tencentOAuth openId] forKey:@"OpenId"];
    }
    if ([_tencentOAuth expirationDate]!=nil) {
        [USER setValue:[_tencentOAuth expirationDate] forKey:@"ExpirationDate"];
    }
    //    NSLog(@"%@=====",[_tencentOAuth accessToken]);
    //    NSLog(@"%@=====",[_tencentOAuth openId]);
    //    NSLog(@"%@=====",[_tencentOAuth expirationDate]);
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = self;
    [HUD setLabelText:@"正在进入..."];
    [self.view addSubview:HUD];
    [HUD show:YES];
    [_qqLoinnBtn setHidden:YES];
    
    [_sinaLoinnBtn setHidden:YES];
    
    
    [_tencentOAuth getUserInfo];
}


/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
	if (cancelled){
        NSLog(@"用户取消登录");
        [self dismissViewControllerAnimated:YES completion:nil];
	}
	else {
		NSLog(@"登录失败");
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"额..." message:@"他们的授权登录服务说让您再试一次 >_<" delegate:self cancelButtonTitle:@"哦" otherButtonTitles:nil];
        [alertView show];
	}
	
}
/**
 * Called when the notNewWork.
 */
-(void)tencentDidNotNetWork
{
	NSLog(@"无网络连接，请设置网络");
}
/**
 * Called when the get_user_info has response.
 */
- (void)getUserInfoResponse:(APIResponse*) response {
    
	if (response.retCode == URLREQUEST_SUCCEED){
        
        openUserName = [response.jsonResponse objectForKey:@"nickname"];
        openUserAvatar = [response.jsonResponse objectForKey:@"figureurl_qq_2"];
        
        // ---Print Login Msg Begin
		NSMutableString *str = [NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
        }
		NSLog(@"UserInfo===%@",str);
        // ---Print Login Msg End
        
        NSLog(@"获取个人信息完成");
        
        NSString *openId = [USER objectForKey:@"OpenId"];
        openUserId = [NSString stringWithFormat:@"platform%@",openId];
        
        if (openUserName == nil) {
            openUserName = @"";
        }
        
        if (openUserAvatar == nil) {
            openUserAvatar = @"";
        }
        
        //去我们服务器做注册或登录
        [self userLogin];
        
	}else {
        [HUD setHidden:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"额..." message:@"他们的授权登录服务说让您再试一次 >_<" delegate:self cancelButtonTitle:@"哦" otherButtonTitles:nil];
        [alertView show];
	}
}

-(NSString *)reversedString:(NSString *) str
{
    int length = [str length];
    NSMutableString *reversedString;
    
    reversedString = [[NSMutableString alloc] initWithCapacity: length];
    
    while (length > 0) {
        [reversedString appendString:[NSString stringWithFormat:@"%C", [str characterAtIndex:--length]]];
    }
    return reversedString;
}

- (void)userLogin
{            
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc] init];
    [parameterDict setObject:openUserId forKey:@"openid"];
    [parameterDict setObject:openUserName forKey:@"nickname"];
    [parameterDict setObject:openUserAvatar forKey:@"avatar"];
    
    if (openUserId!=nil) {
        NSURL *url = [NSURL URLWithString:@"http://dev.zh.ongl.in"];
        AFHTTPClient* httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSURLRequest* request = [httpClient requestWithMethod:@"POST" path:@"/client/s_login" parameters:parameterDict];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            s(JSON);
            
            if ([[JSON valueForKey:@"ret"] integerValue] == 0) {
                
                [USER setBool:YES forKey:@"userLogined"];
                
                [HUD hide:YES];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                                                
            }
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            
        }];
        
        [operation start];
    }
}

@end
