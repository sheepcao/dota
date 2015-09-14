//
//  commentDetailViewController.m
//  dotaer
//
//  Created by Eric Cao on 9/8/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "commentDetailViewController.h"
#import "globalVar.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "DataCenter.h"
#import "playerPageViewController.h"

@interface commentDetailViewController ()

@end

@implementation commentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.headIMG.layer.cornerRadius = self.headIMG.bounds.size.height/2;
    self.headIMG.layer.masksToBounds = YES;
    
    [self.usernameLabel setText:self.username];
    
    NSString *headPath = [NSString stringWithFormat:@"%@%@.png",imagePath,self.username];
    
    NSURL *url = [NSURL URLWithString:[headPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [self.headIMG setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultHead.png"]];
    [self.likeCountLabel setText:self.likeCount];
    
    [self.commentBody setText:self.commentContent];
    
    
    
    if ([[DataCenter sharedDataCenter] isGuest]) {
        [self.likeButton setHidden:YES];
    }else
    {
        [self.likeButton setHidden:NO];
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)likeTapped:(id)sender {
    if ([self.likeCountLabel.text isEqualToString:@""]) {
        
    }else
    {
        [self requestComments];
    }
}

- (IBAction)userButtonTap:(id)sender {
    
    playerPageViewController *playInfo = [[playerPageViewController alloc] initWithNibName:@"playerPageViewController" bundle:nil];
    
    playInfo.playerName =  self.username;
    
    playInfo.distance = -1;
    
    [self.navigationController pushViewController:playInfo animated:YES];

}


-(void)requestComments
{
    NSString *username;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"haveDefaultUser"] isEqualToString:@"yes"]) {
        
        NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoDic"];
        username = [userDic objectForKey:@"username"];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
    
    NSDictionary *parameters;
    if (self.commentID && username) {
        parameters = @{@"tag": @"addUps",@"commentID":self.commentID,@"commentUser":username};
    }else
    {
        parameters = @{@"tag": @"none"};
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:12];  //Time out after 25 seconds
    
    
    [manager POST:commentURL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"ups Json: %@", responseObject);
        
        if ([[responseObject objectForKey:@"ups_count"] intValue] == -1) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请勿重复点赞";
            [hud hide:YES afterDelay:1.5];
        }else
        {
            [self.likeCountLabel setText:[NSString stringWithFormat:@"赞:%@",[responseObject objectForKey:@"ups_count"]]];
            [hud hide:YES];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ups JsonError: %@", error.localizedDescription);
        NSLog(@"ups Json ERROR: %@",  operation.responseString);
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"网络请求失败,请稍后重试";
        [hud hide:YES afterDelay:1.5];
        
    }];
    
    
}

- (BOOL)shouldAutorotate {
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; // your own style
}

- (BOOL)prefersStatusBarHidden {
    return NO; // your own visibility code
}
@end
