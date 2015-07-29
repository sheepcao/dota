//
//  playVideoViewController.m
//  dotaer
//
//  Created by Eric Cao on 7/28/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "playVideoViewController.h"
#import "YoukuWebView.h"
#import "globalVar.h"
#import "UIWebView+YouKu.h"
#import "AFHTTPRequestOperationManager.h"
#import "MediaPlayer/MediaPlayer.h"

@interface playVideoViewController ()

@property (strong,nonatomic) NSArray *nomalURLArray;
@end

@implementation playVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
    self.videoId = @"XMTI5MjIyMTM2OA==";
    [self.view setBackgroundColor:[UIColor blackColor]];
    // Do any additional setup after loading the view from its nib.
    
    

//    [self requestVideoInfo];

    self.webView = [[YoukuWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT , SCREEN_WIDTH) andVideoId:self.videoId];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 60, 60)];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *start = [[UIButton alloc] initWithFrame:self.webView.frame];
    [start setTitle:@"" forState:UIControlStateNormal];
    [start setBackgroundColor:[UIColor clearColor]];
    [start addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:start];
    
    

    
}


-(void)requestVideoInfo
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    
    
    [manager POST:videoInfoService parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        [hud hide:YES];
        
        NSLog(@"JSON: %@", responseObject);
        
        self.nomalURLArray = [responseObject objectForKey:@"high"];
        
        MPMoviePlayerViewController *playViewController=[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:@"http://61.55.189.71/youku/6772422ED45427FB3462F2F5D/0300080B0055A951FB0A1104B921BF9CCD5CD1-182A-F76D-5F4E-614A83C5EDD5.mp4"]];
        MPMoviePlayerController *player=[playViewController moviePlayer];
        
        NSLog(@"url:%@",self.nomalURLArray[0]);
        
        player.movieSourceType    = MPMovieSourceTypeStreaming;

//        NSLog(@"duration:%d",player.duration);
        player.scalingMode=MPMovieScalingModeFill;
        player.controlStyle=MPMovieControlStyleFullscreen;
        player.shouldAutoplay=YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMovie:) name:MPMoviePlayerLoadStateDidChangeNotification object:player];

        [self.view addSubview:player.view];

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        [hud hide:YES];
        
        
        
    }];
    
    
}
- (void)playMovie:(NSNotification *)notification {
    MPMoviePlayerController *player = notification.object;
    if (player.loadState & MPMovieLoadStatePlayable)
    {
        NSLog(@"Movie is Ready to Play");
        [player play];
    }
}

-(void)start:(UIButton *)btn
{
    NSString *ret = [self.webView stringByEvaluatingJavaScriptFromString:@"playVideo();"];
    NSLog(@"tap...%@",ret);
}

-(void)close:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)webViewDidStartLoad:(UIWebView *)webView{
    self.ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.ai setFrame:CGRectMake(self.webView.bounds.size.width/2 - 10, self.webView.bounds.size.height/2 - 10, 20, 20)];
    [self.ai startAnimating];
    [self.webView addSubview:self.ai];
    NSLog(@"start load video");
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"load fail! error = %@", error);
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.ai stopAnimating];
    NSLog(@"finish load video");
    
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = [request URL];
    if ([[url scheme] isEqualToString:@"http"] || [[url scheme] isEqualToString:@"https"]){
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    }
    return YES;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotate {
    return NO;
}


@end
