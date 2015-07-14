//
//  ViewController.h
//  dotaer
//
//  Created by Eric Cao on 7/6/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalVar.h"
#import "userInfo.h"
#import "SideMenuViewController.h"


@interface dotaerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


-(void)showLoginPage;
@end

