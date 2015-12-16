//
//  VideoListViewController.h
//  dotaer
//
//  Created by Eric Cao on 8/19/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backIMG;
@property (weak, nonatomic) IBOutlet UITableView *publisherListTable;

@property (strong,nonatomic) NSDictionary *videoDic;
@property (strong,nonatomic) NSString *publisherID;

@end
