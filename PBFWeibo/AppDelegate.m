//
//  AppDelegate.m
//  PBFWeibo
//
//  Created by apple on 15/5/7.
//  Copyright (c) 2015年 18970841357@163.com. All rights reserved.
//

#import "AppDelegate.h"
#import "IWOAuthViewController.h"
#import "IWAccount.h"
#import "IWWeiboTool.h"
#import "IWAccountTool.h"
#import "IWNewfeatureViewController.h"
#import "SDWebImageManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    // registering for remote notifications
    [self registerForRemoteNotification];
    
    // 先判断有无存储账号信息
    IWAccount *account = [IWAccountTool account];
    
    if (account) { // 之前登录成功
        [IWWeiboTool chooseRootController];
    } else { // 之前没有登录成功
        self.window.rootViewController = [[IWOAuthViewController alloc] init];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

/**
 让程序保持后台运行
 1.尽量申请后台运行的时间
 [application beginBackgroundTaskWithExpirationHandler:^{
 
 }];
 
 2.在Info.plist中声明自己的应用类型为audio、在后台播放mp3
 */

/**
 *  app进入后台会调用这个方法
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // 在后台开启任务让程序持续保持运行状态（能保持运行的时间是不确定）
    [application beginBackgroundTaskWithExpirationHandler:^{
        //        IWLog(@"过期了------");
    }];
    
    // 定时提醒（定时弹框）
    //    [UILocalNotification ];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 停止下载所有图片
    [[SDWebImageManager sharedManager] cancelAll];
    // 清除内存中的图片
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

- (void)registerForRemoteNotification {
    if (iOS8) {
        UIUserNotificationType types = UIUserNotificationTypeSound | UIUserNotificationTypeBadge | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}
#endif

@end
