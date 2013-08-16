//
//  AppDelegate.m
//  Date
//
//  Created by folse on 8/9/13.
//  Copyright (c) 2013 folse. All rights reserved.
//

#import "AppDelegate.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "UMSocialData.h"
#import "UMSocialSnsService.h"
#import "UMSocialControllerService.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    [UMSocialData setAppKey:@"520db1eb56240b696400c878"];
    [UMSocialData openLog:YES];
    
    [UMSocialControllerService defaultControllerService].socialData.extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    [UMSocialControllerService defaultControllerService].socialData.extConfig.appUrl = @"https://itunes.apple.com/cn/app/qian-fangqpos/id587767923?l=en&mt=8";
        
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *) sourceApplication annotation:(id)annotation
{
    NSString *urlString = [url absoluteString];
    s(urlString);
    if([[urlString substringToIndex:7] isEqualToString:@"tencent"]){
        return [TencentOAuth HandleOpenURL:url];
    }
    
    return YES;
}

@end
