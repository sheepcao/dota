//
//  topicHistoryViewController.h
//  dotaer
//
//  Created by Eric Cao on 9/8/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//
@class GADBannerView;
#import <UIKit/UIKit.h>

@interface topicHistoryViewController : UIViewController

@property(nonatomic, strong)  GADBannerView *bannerView;

@property (weak, nonatomic) IBOutlet UITableView *topicsTable;

@end
