//
//  playerPageViewController.h
//  dotaer
//
//  Created by Eric Cao on 7/16/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userInfo.h"

@interface playerPageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *achieveView;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIImageView *infoBackImage;
@property (strong, nonatomic) UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *notePadTable;

@property (strong, nonatomic) userInfo *playerInfo;
@property (strong, nonatomic) NSString *playerName;

@end
