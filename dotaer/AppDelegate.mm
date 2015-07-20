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
#import "centerViewController.h"

@interface AppDelegate ()

@end

BMKMapManager* _mapManager;

@implementation AppDelegate

- (dotaerViewController *)demoController {
    return [[dotaerViewController alloc] initWithNibName:@"dotaerViewController" bundle:nil];
}

- (UINavigationController *)navigationController {
    return [[UINavigationController alloc]
            initWithRootViewController:[self demoController]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.\
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    SideMenuViewController *leftMenuViewController = [[SideMenuViewController alloc] init];
    leftMenuViewController.items = [NSArray arrayWithObjects:@"战绩更新",@"关注",@"消息",@"关于我们", nil];
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:[self navigationController]
                                                    leftMenuViewController:leftMenuViewController
                                                    rightMenuViewController:nil];
    self.window.rootViewController = container;
    
    [self.window makeKeyAndVisible];
    
    
    // 要使用百度地图，请先启动BaiduMapManager
   
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"MWVBk7FngAqgl0fSzErXRGzF" generalDelegate:self];
    
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    return YES;
}

//- (IIViewDeckController*)generateControllerStack {
////    myMenuViewController* rightController = [[myMenuViewController alloc] initWithNibName:@"myMenuViewController" bundle:nil];
//    myMenuViewController* leftController = [[myMenuViewController alloc] initWithNibName:@"myMenuViewController" bundle:nil];
//
//    
//    UIViewController *centerController = [[dotaerViewController alloc] initWithNibName:@"dotaerViewController" bundle:nil];
//    centerController = [[UINavigationController alloc] initWithRootViewController:centerController];
//    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:centerController
//                                                                                    leftViewController:leftController
//                                                                                   rightViewController:nil];
//    deckController.leftSize = 200;
////    deckController.navigationControllerBehavior = IIViewDeckNavigationControllerIntegrated;
//    
//    [deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];
//    return deckController;
//}


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
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}
@end
