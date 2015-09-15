//
//  settingViewController.h
//  dotaer
//
//  Created by Eric Cao on 8/20/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//
@class GADBannerView;

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface settingViewController : UIViewController<MFMailComposeViewControllerDelegate>
@property(nonatomic, strong)  GADBannerView *bannerView;

@property (weak, nonatomic) IBOutlet UIImageView *backIMG;

@end
