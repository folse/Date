//
//  LoginController.h
//  Date
//
//  Created by folse on 8/9/13.
//  Copyright (c) 2013 folse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "UMSocial.h"

@interface LoginController : UIViewController
{
    TencentOAuth * _tencentOAuth;
    NSMutableArray* _permissions;
    
}

@property (nonatomic) IBOutlet UIButton *qqLoinnBtn;
@property (nonatomic) IBOutlet UIButton *sinaLoinnBtn;

@end
