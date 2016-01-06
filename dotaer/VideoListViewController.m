//
//  VideoListViewController.m
//  dotaer
//
//  Created by Eric Cao on 8/19/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <GoogleMobileAds/GoogleMobileAds.h>


#import "VideoListViewController.h"
#import "videoTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"
#import "globalVar.h"
#import "WatchVideoViewController.h"

@interface VideoListViewController ()<GADBannerViewDelegate>

@property (nonatomic ,strong) NSMutableArray *videoArray;
@property (nonatomic ,strong) NSString *totalVideos;

@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;
@property(nonatomic, strong)  GADBannerView *bannerView;
@property(nonatomic, strong) MBProgressHUD *hud;
@end

@implementation VideoListViewController
@synthesize moviePlayer;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

//    self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-50-64,SCREEN_WIDTH, 50)];
//    self.bannerView.delegate = self;
//    self.bannerView.adUnitID =ADMOB_ID;
//    self.bannerView.rootViewController = self;
//    
//    GADRequest *request = [GADRequest request];
//    
//    
//    [self.bannerView loadRequest:request];
//    [self.view addSubview:self.bannerView];
    //need to recover..............

    
    self.videoArray = [NSMutableArray arrayWithArray: [self.videoDic objectForKey:@"videos"]];
    
    self.totalVideos = [self.videoDic objectForKey:@"total"];
    
//    UIVisualEffect *blurEffect_b;
//    blurEffect_b = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    
//    UIVisualEffectView *visualEffectView_b;
//    visualEffectView_b = [[UIVisualEffectView alloc] initWithEffect:blurEffect_b];
//    
//    visualEffectView_b.frame =CGRectMake(0, 0, self.backIMG.frame.size.width, self.backIMG.frame.size.height) ;
//    [self.backIMG addSubview:visualEffectView_b];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Table view data source


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoArray.count;
}
// Customize the appearance of table view cells.
- (videoTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    videoTableViewCell *cell =(videoTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"publisherCell"];
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"videoTableViewCell" owner:self options:nil] objectAtIndex:0];//加载nib文件
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    NSString *videoLink = [self.videoArray[indexPath.row] objectForKey:@"thumbnail"];
    NSURL *url = [NSURL URLWithString:[videoLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *updateDate = [[self.videoArray[indexPath.row] objectForKey:@"published"] componentsSeparatedByString:@" "][0];

    cell.backgroundColor = [UIColor clearColor];
    
    [cell.headImg setImageWithURL:url];
    [cell.title setText:[self.videoArray[indexPath.row] objectForKey:@"title"]];
    [cell.updateTime setText:updateDate];
    NSString *viewCount = [self.videoArray[indexPath.row] objectForKey:@"view_count"];
    if ([viewCount longLongValue] >100000) {
        viewCount = [NSString stringWithFormat:@"%d万",(int)[viewCount longLongValue]/10000];
    }
    [cell.playCountLabel setText:[NSString stringWithFormat:@"%@",viewCount]];

    NSLog(@"index:%ld",indexPath.row);

    if((indexPath.row+1)%30 == 0 )
    {
        if (self.videoArray.count <= (indexPath.row+1) && (indexPath.row+1) < [self.totalVideos intValue]) {
            [self requestMoreVideo:((int)indexPath.row +1 +30)];
        }
    }
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.dimBackground = YES;
    

   
    

    NSString *link = [self.videoArray[indexPath.row] objectForKey:@"link"];
    
    [self requestVideoInfo:link];

    
}


-(void)requestVideoInfo:(NSString *)videoURL
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager.requestSerializer setTimeoutInterval:30];
    
    NSDictionary *parameters = @{@"tag": @"getVid",@"VideoURL":videoURL};
    
    [manager POST:videoInfoService parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        
        NSLog(@"JSON: %@", [responseObject objectForKey:@"m3u8"]);
        NSString *vid = @"";
        NSArray *secondPart = [[responseObject objectForKey:@"m3u8"] componentsSeparatedByString:@"vid="];
        
        if (secondPart.count>1) {
            vid = [secondPart[1] componentsSeparatedByString:@"&"][0];
            [self requestVideoURLForLink:vid];
        }
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        
        
        
        
    }];
    
    
}


-(void)requestVideoURLForLink:(NSString *)link
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:30];
    
//    link = @"341407959";
    NSString *infoURLstring = [NSString stringWithFormat:@"http://lefun.net.cn:3301/?vid=%@",link];
    
    
    
    [manager GET:infoURLstring parameters:nil success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        
        NSString *videoURL = [json objectForKey:@"data"];
        NSURL *url=[[NSURL alloc] initWithString:videoURL];
        ;
        moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:url];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDonePressed:) name:MPMoviePlayerDidExitFullscreenNotification object:moviePlayer];
        
        [self.hud hide:YES];
        

        

        [moviePlayer.view setFrame:self.view.bounds];

        moviePlayer.controlStyle=MPMovieControlStyleFullscreen;
        moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        //moviePlayer.shouldAutoplay=NO;
        [moviePlayer prepareToPlay];
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        
        [self.view addSubview:moviePlayer.view];
        [moviePlayer setFullscreen:YES animated:YES];
        
        
        
        [MobClick event:@"videoPlay"];




        
//        WatchVideoViewController *watchVideo = [[WatchVideoViewController alloc] initWithNibName:@"WatchVideoViewController" bundle:nil];
//        watchVideo.linkURL = url;
//        [self presentViewController:watchVideo animated:YES completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        
        
    }];
    
}


- (void) moviePlayBackDonePressed:(NSNotification*)notification
{
    [moviePlayer stop];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerDidExitFullscreenNotification object:moviePlayer];
    [self setNeedsStatusBarAppearanceUpdate];

    
    if ([moviePlayer respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [moviePlayer.view removeFromSuperview];
        

    }
    moviePlayer=nil;
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [self setNeedsStatusBarAppearanceUpdate];

    [moviePlayer stop];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    
    if ([moviePlayer respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [moviePlayer.view removeFromSuperview];
        
     
    }
}



//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (((int)(scrollView.contentOffset.y+self.publisherListTable.frame.size.height) % (220 * 15)) == 0 &&scrollView.contentOffset.y >0.001) {
//        
//        int refreshCount = ((int)(scrollView.contentOffset.y+self.publisherListTable.frame.size.height) / (220 * 15));
//        if ((refreshCount+1)*15 > self.videoArray.count) {
//            NSLog(@"refresh!!!!!!!!!!!!!!!!!!!");
//        }
//        
//    }
//}

-(void)requestMoreVideo:(int)total
{

    if (total > [self.totalVideos intValue]) {
        total = [self.totalVideos intValue];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setTimeoutInterval:30];
    NSString *infoString;

    infoString = [NSString stringWithFormat:@"https://openapi.youku.com/v2/videos/by_user.json?client_id=cb52b838b5477abd&user_name=%@&count=30&page=%d",self.title,total/30];
    NSLog(@"total:%d",total);
    
    NSString* infoURLstring = [infoString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:infoURLstring parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@" --- responseObject:%@",responseObject);
        
//        [self.videoArray removeAllObjects];
        NSArray *videoNewArray = [responseObject objectForKey:@"videos"];

     
        self.videoArray = [NSMutableArray arrayWithArray:[self.videoArray arrayByAddingObjectsFromArray:videoNewArray]];
        
//        self.videoArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"videos"]];

        [self.publisherListTable reloadData];
        if (hud.superview) {
        
            [hud hide:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        if (hud.superview) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"网络请求失败";
            
            [hud hide:YES afterDelay:1.5];
        }
        
    }];

}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)viewWillLayoutSubviews {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
