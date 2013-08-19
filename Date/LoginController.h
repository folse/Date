//
//  LoginController.h
//  Date
//
//  Created by folse on 8/9/13.
//  Copyright (c) 2013 folse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LoginController : UIViewController<MBProgressHUDDelegate>

@property (strong, nonatomic) IBOutlet UITextField *inputTF;

@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

@end
