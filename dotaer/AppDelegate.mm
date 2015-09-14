//
//  AppDelegate.m
//  dotaer
//
//  Created by Eric Cao on 7/6/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "AppDelegate.h"
#import "globalVar.h"
#import "MFSideMenu.h"
#import "SideMenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "dotaerViewController.h"
#import "myMenuViewController.h"
#import "DataCenter.h"

@interface AppDelegate ()<BMKGeneralDelegate>

@end

BMKMapManager* _mapManager;

@implementation AppDelegate

- (dotaerViewController *)demoController {
    return [[dotaerViewController alloc] initWithNibName:@"dotaerViewController" bundle:nil];
}

- (UINavigationController *)navigationController {
    
    UINavigationController * navi = [[UINavigationController alloc]
                                     initWithRootViewController:[self demoController]];
    [navi.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBar.png"] forBarMetrics:UIBarMetricsDefault];
    [navi.navigationBar setBarTintColor:[UIColor whiteColor]];
//    [navi.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    navi.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    return navi;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.\
    
    
    // 要使用百度地图，请先启动BaiduMapManager
    
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"RT6Hg1uzL8vGkOKkKv0D1iVY" generalDelegate:self];
    
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    

    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    NSMutableArray *favorArray = [[DataCenter sharedDataCenter] fetchFavors];
//    NSString *favorString = @"关注";
//    if (favorArray && favorArray.count>0)
//    {
//        favorString = [NSString stringWithFormat:@"关注(%lu)",(unsigned long)favorArray.count];
//    }
    
    SideMenuViewController *leftMenuViewController = [[SideMenuViewController alloc] init];
    leftMenuViewController.items = [NSArray arrayWithObjects:@"视频解说",@"我的主页",@"今日话题",@"我的圈子",@"战绩小秘书", nil];
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:[self navigationController]
                                                    leftMenuViewController:leftMenuViewController
                                                    rightMenuViewController:nil];
    container.leftMenuWidth = SCREEN_WIDTH*4/7;
    container.menuWidth = SCREEN_WIDTH*4/7;
    self.window.rootViewController = container;
    
    [self.window makeKeyAndVisible];
    
    [MobClick startWithAppkey:@"55c2fdc7e0f55a9eef004677" reportPolicy:REALTIME   channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    [self setShareIDs];
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    
//    if (launchOptions) {
//        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//        if (pushNotificationKey) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"noti" message:@"remote noti!!!!!~~~~~~~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
//    }
    
    return YES;
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceToken"];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
    [[NSUserDefaults standardUserDefaults] setObject:@"none" forKey:@"deviceToken"];

}


- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}


-(void)setShareIDs
{
    [ShareSDK registerApp:@"943060bfe881"];//字符串api20为您的ShareSDK的AppKey
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"1054017016"
                               appSecret:@"f724ecce1e644e16c1cb44c349f2df27"
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];
    
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"1054017016"
                                appSecret:@"f724ecce1e644e16c1cb44c349f2df27"
                              redirectUri:@"https://api.weibo.com/oauth2/default.html"
                              weiboSDKCls:[WeiboSDK class]];
       //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wxe9f0021070a60b40"
                           wechatCls:[WXApi class]];
    
    
    [ShareSDK connectWeChatWithAppId:@"wxe9f0021070a60b40"   //微信APPID
                           appSecret:@"2b1b86bc877665e9dc8bb3b6af7e3bb4"  //微信APPSecret
                           wechatCls:[WXApi class]];
    
    
}


#pragma mapDelegate
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }else
    {

        NSLog(@"授权失败:%d",iError);
    }
    
//    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *doc = [NSString stringWithFormat:@"%@/11.txt",documentDir];
//    NSLog(@"path11:%@",doc);
//    NSString *log = [NSString stringWithFormat:@"error:%d",iError];
//    NSError *error;
//    
//    [log writeToFile:doc atomically:YES encoding:NSUTF8StringEncoding error:&error];

}


@end
