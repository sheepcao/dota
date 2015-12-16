//
//  publisherViewController.m
//  dotaer
//
//  Created by Eric Cao on 8/19/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//
#import <GoogleMobileAds/GoogleMobileAds.h>

#import "publisherViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "globalVar.h"
#import "playerBtn.h"
#import "MBProgressHUD.h"
#import "VideoListViewController.h"
#import "DataCenter.h"

@interface publisherViewController ()<GADBannerViewDelegate>
//@property (nonatomic ,strong) NSArray *publisherArray;
@property (nonatomic ,strong) NSArray *nameArray;
@property (nonatomic ,strong) NSMutableArray *publisherIDArray;

@property (nonatomic ,strong) NSMutableDictionary *publisherVideosDic;

@end

@implementation publisherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"解说列表";
    
    //    self.publisherArray = @[@"伍声2009",@"DOta情书",@"卜严骏Pis",@"dota第一视角直播录制",@"GuAi小乖",@"superhebefans",@"满楼都素我的人",@"狗头神教牛蛙",@"Esports海涛",@"舞ル灬",@"Pc冷冷",@"小爷不狂",@"Kevinnnnnnnnnnn",@"梅西❤Huang",@"满楼水平",@"张登溶_nada",@"Music咖啡。",@"天枫燚",@"水一亦寒",@"朴一生dota"];
    
    self.nameArray = @[@"2009",@"情书",@"pis",@"第一视角直播录制",@"小乖",@"傻黑欢乐",@"小满",@"牛蛙",@"海涛",@"舞儿",@"狂湿",@"凯文",@"梅西",@"满楼水平",@"nada",@"南风解说",@"水一亦寒",@"朴一生"];
    
    self.publisherVideosDic = [[NSMutableDictionary alloc] init];
    self.publisherIDArray = [[NSMutableArray alloc] init];

    
    
    self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, 50)];
    self.bannerView.delegate = self;
    self.bannerView.adUnitID =ADMOB_ID;
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    
    [self.bannerView loadRequest:request];
    //need to recover..............
    
    [self.view addSubview:self.bannerView];
    
    
    
    
    [self setupScroll];
    
    [self requestPublisherVideos];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)requestPublisherVideos
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setTimeoutInterval:30];
    NSString *infoString = @"http://lefun.net.cn:8081/dota/getsubcate.json?cateid=1";
    [manager GET:infoString parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@" responseObject:%@",responseObject);
        
        NSArray *publishers = [responseObject objectForKey:@"items"];
        
        for (int i = 0; i<self.nameArray.count; i++) {
            
            for (NSDictionary *onePublisher in publishers) {
                NSString *publisherName = [onePublisher objectForKey:@"subcatename"];
                if ([DataCenter myContainsStringFrom:publisherName ForSting:self.nameArray[i]]) {
                    
                    [self.publisherIDArray insertObject:[onePublisher objectForKey:@"subcateid"] atIndex:i];
                    
                    playerBtn *relatedBtn = (playerBtn *)[self.publisherScroll viewWithTag:i+100];
                    [self refreshButton:relatedBtn Using:onePublisher];
                    break;
                }
            }
            
            
        }
        
        
        if (hud.superview) {
            [hud hide:YES afterDelay:1.6];
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

-(void)refreshButton:(playerBtn *)btn Using:(NSDictionary *)dic
{
    NSString *updateTime = [dic objectForKey:@"lastpdate"];
    NSString *updateDate = [updateTime componentsSeparatedByString:@" "][0];
    
    [btn.update setText:[NSString stringWithFormat:@"更新于:%@",updateDate]];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *dateString = [format stringFromDate:now];
    
    NSLog(@"date now :%@----%@",dateString,updateDate);
    
    if ([updateDate isEqualToString:dateString]) {
        [btn.update setText:@"更新于:今天"];
        NSLog(@"===============");
    }
    
}



-(void)setupScroll
{
    [self.publisherScroll setContentSize:CGSizeMake(SCREEN_WIDTH, 30+(self.nameArray.count+1)/2 * (SCREEN_WIDTH*5/12+25))];
    self.publisherScroll.canCancelContentTouches = YES;
    
    for (int i = 0; i < self.nameArray.count; i++) {
        playerBtn *publisherBtn = [[playerBtn alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/9+(i%2)*SCREEN_WIDTH*4/9, 30+(i/2)*(SCREEN_WIDTH*5/12+25), SCREEN_WIDTH/3, SCREEN_WIDTH*5/12)];
        publisherBtn.playerName = self.nameArray[i];
        publisherBtn.tag = i+100;
        [publisherBtn addTarget:self action:@selector(jumpToVideos:) forControlEvents:UIControlEventTouchUpInside];
        publisherBtn.layer.cornerRadius = 10.0f;
        publisherBtn.layer.borderWidth = 0.7f;
        //        publisherBtn.layer.borderColor = [UIColor colorWithRed:138/255.0f green:211/255.0f blue:221/255.0f alpha:1.0f].CGColor;
        publisherBtn.layer.borderColor = [UIColor colorWithRed:50/255.0f green:50/255.0f blue:50/255.0f alpha:1.0f].CGColor;
        
        [publisherBtn.name setText:self.nameArray[i]];
        [publisherBtn.head setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpeg",self.nameArray[i]]]];
        [self.publisherScroll addSubview:publisherBtn];
    }
    
    
}

-(void)jumpToVideos:(playerBtn *)btn
{
    if (self.publisherIDArray.count == self.nameArray.count) {
        
        
        VideoListViewController *videoVC = [[VideoListViewController alloc] initWithNibName:@"VideoListViewController" bundle:nil];
        videoVC.publisherID = self.publisherIDArray[btn.tag-100];
        videoVC.title = btn.playerName;
        
        [self.navigationController pushViewController:videoVC animated:YES];
        
    }
    
}

- (BOOL)shouldAutorotate {
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
