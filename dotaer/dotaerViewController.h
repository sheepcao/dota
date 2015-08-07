//
//  ViewController.h
//  dotaer
//
//  Created by Eric Cao on 7/6/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GADBannerView;


@interface dotaerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)  GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIImageView *backBlur;

-(void)showLoginPage;
@end

