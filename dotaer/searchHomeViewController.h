//
//  searchHomeViewController.h
//  dotaer
//
//  Created by Eric Cao on 9/14/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//
@class GADBannerView;

#import <UIKit/UIKit.h>

@interface searchHomeViewController : UIViewController

@property(nonatomic, strong)  GADBannerView *bannerView;

@property (weak, nonatomic) IBOutlet UITextField *keywordField;
- (IBAction)search;

@end
