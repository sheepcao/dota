//
//  searchHomeViewController.m
//  dotaer
//
//  Created by Eric Cao on 9/14/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "searchHomeViewController.h"
#import "scoreSearchViewController.h"
#import "MBProgressHUD.h"
#import "globalVar.h"

@interface searchHomeViewController ()<GADBannerViewDelegate>


@end

@implementation searchHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"战绩小秘书";
    
    self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, 50)];
    self.bannerView.delegate = self;
    self.bannerView.adUnitID =ADMOB_ID;
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    
    
    [self.bannerView loadRequest:request];
    [self.view addSubview:self.bannerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)search {
    
    [MobClick event:@"searchScore"];

    
    [self.view endEditing:YES];// this will do the trick

    
    if (self.keywordField.text && ![[self.keywordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        scoreSearchViewController *scoreSearchVC = [[scoreSearchViewController alloc] initWithNibName:@"scoreSearchViewController" bundle:nil];
        scoreSearchVC.keyword = self.keywordField.text;
        [self.navigationController pushViewController:scoreSearchVC animated:YES];
        

    
    }else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入合法的11账号";
        [hud hide:YES afterDelay:1.2f];
    }
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

@end
