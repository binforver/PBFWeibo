//
//  PBFTabbarController.m
//  PBFWeibo
//
//  Created by apple on 15/5/7.
//  Copyright (c) 2015年 18970841357@163.com. All rights reserved.
//

#import "PBFTabbarController.h"
#import "PBFHomeViewController.h"
#import "PBFMessageViewController.h"
#import "PBFDiscoverViewController.h"
#import "PBFMeViewController.h"
#import "UIImage+MJ.h"
#import "IWTabBar.h"
#import "IWUserTool.h"
#import "IWAccountTool.h"
#import "IWAccount.h"
#import "IWNavigationController.h"
#import "IWComposeViewController.h"

@interface PBFTabbarController ()<IWTabBarDelegate>
/**
 *  自定义的tabbar
 */
@property (nonatomic, weak) IWTabBar *customTabBar;

@property (nonatomic, strong) PBFHomeViewController *home;
@property (nonatomic, strong) PBFMessageViewController *message;
// 3.广场
@property (nonatomic, strong) PBFDiscoverViewController *discover;
// 4.我
@property (nonatomic, strong) PBFMeViewController *me;

@end

@implementation PBFTabbarController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化tabbar
    [self setupTabbar];
    
    // 初始化所有的子控制器
    [self setupAllChildViewControllers];
    
    // 定时检查未读数
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(checkUnreadCount) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

/**
 *  定时检查未读数
 */
- (void)checkUnreadCount
{
    //    IWLog(@"checkUnreadCount-----");
    
    // 1.请求参数
    IWUserUnreadCountParam *param = [IWUserUnreadCountParam param];
    param.uid = @([IWAccountTool account].uid);
    
    // 2.发送请求
    [IWUserTool userUnreadCountWithParam:param success:^(IWUserUnreadCountResult *result) {
        // 3.设置badgeValue
        // 3.1.首页
        self.home.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", result.status];
        
        // 3.2.消息
        self.message.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", result.messageCount];
        
        // 3.3.我
        self.me.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", result.follower];
        
        // 4.设置图标右上角的数字
        [UIApplication sharedApplication].applicationIconBadgeNumber = result.count;
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

/**
 *  初始化tabbar
 */
- (void)setupTabbar
{
    IWTabBar *customTabBar = [[IWTabBar alloc] init];
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}

#pragma mark - tabbar的代理方法
/**
 *  监听tabbar按钮的改变
 *  @param from   原来选中的位置
 *  @param to     最新选中的位置
 */
- (void)tabBar:(IWTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to
{
    self.selectedIndex = to;
    
    if (to == 0) { // 点击了首页
        [self.home refresh];
    }
}

/**
 *  监听加号按钮点击
 */
- (void)tabBarDidClickedPlusButton:(IWTabBar *)tabBar
{
    IWComposeViewController *compose = [[IWComposeViewController alloc] init];
    IWNavigationController *nav = [[IWNavigationController alloc] initWithRootViewController:compose];
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 *  初始化所有的子控制器
 */
- (void)setupAllChildViewControllers
{
    // 1.首页
    PBFHomeViewController *home = [[PBFHomeViewController alloc] init];
    [self setupChildViewController:home title:@"首页" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
    self.home = home;
    
    // 2.消息
    PBFMessageViewController *message = [[PBFMessageViewController alloc] init];
    [self setupChildViewController:message title:@"消息" imageName:@"tabbar_message_center" selectedImageName:@"tabbar_message_center_selected"];
    self.message = message;
    
    // 3.广场
    PBFDiscoverViewController *discover = [[PBFDiscoverViewController alloc] init];
    [self setupChildViewController:discover title:@"广场" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];
    self.discover = discover;
    
    // 4.我
    PBFMeViewController *me = [[PBFMeViewController alloc] init];
    [self setupChildViewController:me title:@"我" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
    self.me = me;
}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childVc.title = title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageWithName:imageName];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageWithName:selectedImageName];
    if (iOS7) {
        childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVc.tabBarItem.selectedImage = selectedImage;
    }
    
    // 2.包装一个导航控制器
    IWNavigationController *nav = [[IWNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
    // 3.添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}

@end
