//
//  topicsViewController.m
//  dotaer
//
//  Created by Eric Cao on 9/2/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "topicsViewController.h"
#import "commentTableViewCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "globalVar.h"
#import "playerPageViewController.h"
#import "addCommentViewController.h"
#import "DataCenter.h"
#import "commentDetailViewController.h"
#import "topicHistoryViewController.h"

#import <GoogleMobileAds/GoogleMobileAds.h>

@interface topicsViewController ()<GADBannerViewDelegate>


@property (nonatomic,strong) NSMutableArray *commentsArray;

@end

@implementation topicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    

    [self.topicLabel setText:self.topic];
    
    if(self.isFromHistory)
    {
        self.title = [self.topicDay componentsSeparatedByString:@" "][0];

    }else
    {
        self.title = @"今日话题";

        [[NSUserDefaults standardUserDefaults] setObject:self.topicDay forKey:@"topicDay"];
        self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];

    }
    
    [self.imgDelegate cancelNewImg];
    
    self.commentsArray = [[NSMutableArray alloc] init];
    
    
    self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-50-64,SCREEN_WIDTH, 50)];
    self.bannerView.delegate = self;
    self.bannerView.adUnitID =ADMOB_ID;
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    
    
    [self.bannerView loadRequest:request];
    [self.view addSubview:self.bannerView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestComments];

}


- (UIBarButtonItem *)rightMenuBarButtonItem {
    
    
    UIButton *btnNext1 =[[UIButton alloc] init];
    [btnNext1 setTitle:@"往期话题" forState:UIControlStateNormal];
    [btnNext1 setTitleColor:[UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    btnNext1.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    
    btnNext1.frame = CGRectMake(15, SCREEN_WIDTH-85, 70, 35);
    UIBarButtonItem *btnNext =[[UIBarButtonItem alloc] initWithCustomView:btnNext1];
    btnNext1.tag = 0;
    [btnNext1 addTarget:self action:@selector(topicHistory) forControlEvents:UIControlEventTouchUpInside];
    
    return btnNext;
    
    
}

-(void)topicHistory
{
    topicHistoryViewController *topicHistory = [[topicHistoryViewController alloc] initWithNibName:@"topicHistoryViewController" bundle:nil];
    [self.navigationController pushViewController:topicHistory animated:YES];
}


-(void)requestComments
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
    
    if (!self.topicDay) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"网络请求失败,请稍后重试";
        [hud hide:YES afterDelay:1.2];
        return;
        
    }
    
    NSDictionary *parameters = @{@"tag": @"fetchComments",@"topicDate":self.topicDay};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:20];  //Time out after 25 seconds
    
    
    [manager POST:commentURL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"comment Json: %@", responseObject);
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"comments"]];
        
        
        self.commentsArray = [NSMutableArray arrayWithArray:[self sortArray:tempArray]];
        
        //fetch comment and ups OK.........to be continue!!!
        
        [self.commentCountLabel setText:[NSString stringWithFormat:@"%lu个见解",self.commentsArray.count]];
        [self.commentTable reloadData];
        
        [hud hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"comment JsonError: %@", error.localizedDescription);
        NSLog(@"comment Json ERROR: %@",  operation.responseString);
        
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"网络请求失败,请稍后重试";
        [hud hide:YES afterDelay:1.2];
        
        
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark Table view data source


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentsArray.count;
}
// Customize the appearance of table view cells.
- (commentTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *commentDic = self.commentsArray[indexPath.row];
    
    commentTableViewCell *cell =(commentTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"commentTableViewCell" owner:self options:nil] objectAtIndex:0];//加载nib文件
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.backgroundColor = [UIColor clearColor];
    
    [cell.commentLabel setText:[commentDic objectForKey:@"comment_content"]];
    cell.commentID = [commentDic objectForKey:@"comment_id"];
    [cell.usernameLabel setText:[commentDic objectForKey:@"comment_user"]];
    cell.userBtn.username = [commentDic objectForKey:@"comment_user"];
    [cell.likeCountLabel setText:[NSString stringWithFormat:@"赞:%@",[commentDic objectForKey:@"upsCount"]]];
    
    NSString *headPath = [NSString stringWithFormat:@"%@%@.png",imagePath,[commentDic objectForKey:@"comment_user"]];

    NSURL *url = [NSURL URLWithString:[headPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [cell.headIMG setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultHead.png"]];
    

    [cell.userBtn addTarget:self action:@selector(userDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *commentDic = self.commentsArray[indexPath.row];
    
    commentTableViewCell *cell =(commentTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    
    commentDetailViewController *commentDetail = [[commentDetailViewController alloc] initWithNibName:@"commentDetailViewController" bundle:nil];
    commentDetail.username = [commentDic objectForKey:@"comment_user"];
    commentDetail.likeCount = cell.likeCountLabel.text;
    commentDetail.commentContent = [commentDic objectForKey:@"comment_content"];
    commentDetail.commentID = [commentDic objectForKey:@"comment_id"];

    
    
    [self.navigationController pushViewController:commentDetail animated:YES];

    
}

- (BOOL)shouldAutorotate {
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}





- (IBAction)checkMyComment:(id)sender {
}

- (IBAction)addComment:(id)sender {
    
    if ([[DataCenter sharedDataCenter] isGuest]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"仅限注册用户发表见解";
        [hud hide:YES afterDelay:1.2];
        return;
    }
    
    addCommentViewController *addCommentVc = [[addCommentViewController alloc] initWithNibName:@"addCommentViewController" bundle:nil];
    

    addCommentVc.topicDay = self.topicDay;

    [self.navigationController pushViewController:addCommentVc animated:YES];

}


-(void)userDetail:(userButton *)sender
{
    
    playerPageViewController *playInfo = [[playerPageViewController alloc] initWithNibName:@"playerPageViewController" bundle:nil];
    
    playInfo.playerName =  sender.username;
    
    playInfo.distance = -1;
    
    [self.navigationController pushViewController:playInfo animated:YES];
}

- (NSArray *)sortArray:(NSMutableArray *)orignalArray
{
    NSSortDescriptor *sortDescriptor;
    NSArray *sortedArray;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"upsCount"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    sortedArray = [orignalArray sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
    
}



-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; // your own style
}

- (BOOL)prefersStatusBarHidden {
    return NO; // your own visibility code
}
@end
