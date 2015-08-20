//
//  publisherViewController.h
//  dotaer
//
//  Created by Eric Cao on 8/19/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//
@class GADBannerView;

#import <UIKit/UIKit.h>


@interface publisherViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backIMG;
@property(nonatomic, strong)  GADBannerView *bannerView;

@property (weak, nonatomic) IBOutlet UIScrollView *publisherScroll;

@end
