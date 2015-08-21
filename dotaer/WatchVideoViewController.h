//
//  WatchVideoViewController.h
//  dotaer
//
//  Created by Eric Cao on 8/20/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface WatchVideoViewController : UIViewController
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic,strong) NSURL *linkURL;

@end
