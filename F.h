//
//  F.h
//  ThinkCare
//
//  Created by Folse on 5/11/13.
//  Copyright (c) 2013 Folse. All rights reserved.
//

#define s(content) NSLog(@"%@", content);
#define i(content) NSLog(@"%d", content);
#define f(content) NSLog(@"%f", content);

#define USER [NSUserDefaults standardUserDefaults]
#define USER_ID [USER valueForKey:@"userId"]
#define USER_NAME [USER valueForKey:@"userName"]
#define USER_LOGIN [USER boolForKey:@"userLogined"]
#define F_COLOR [UIColor colorWithRed:231.0/255.0 green:106.0/255.0 blue:141.0/255.0 alpha:1.0] 


#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define TEST FALSE

#if TEST
#define API_BASE_URL @"http://0.meilidaren.duapp.com"
#else
#define API_BASE_URL @"http://mldrapi.duapp.com"
#endif
