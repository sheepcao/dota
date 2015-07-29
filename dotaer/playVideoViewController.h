//
//  playVideoViewController.h
//  dotaer
//
//  Created by Eric Cao on 7/28/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YoukuWebView.h"

@interface playVideoViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) YoukuWebView *webView ;
@property (strong, nonatomic) UIWebView *myWebView;
@property (nonatomic, strong) UIActivityIndicatorView *ai;

@property (strong, nonatomic) NSString *videoId;

@end
