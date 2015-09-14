//
//  topicHistoryViewController.m
//  dotaer
//
//  Created by Eric Cao on 9/8/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "topicHistoryViewController.h"
#import "MBProgressHUD.h"
#import "AFHTTPRequestOperationManager.h"
#import "topicHistoryTableViewCell.h"
#import "topicsViewController.h"
#import "globalVar.h"

@interface topicHistoryViewController ()

@property (nonatomic, strong) NSArray *topicsArray;

@end

@implementation topicHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"往期话题";
    [self requestHistoricTopics];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)requestHistoricTopics
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
    

    
    NSDictionary *parameters = @{@"tag": @"fetchTopic"};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:20];  //Time out after 25 seconds
    
    
    [manager POST:topicURL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"comment Json: %@", responseObject);
        
        NSArray *tempArray = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"topics"]];
        
        
        self.topicsArray = tempArray;
        
        //fetch comment and ups OK.........to be continue!!!
        
        [self.topicsTable reloadData];
        
        [hud hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"comment JsonError: %@", error.localizedDescription);
        NSLog(@"comment Json ERROR: %@",  operation.responseString);
        
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"网络请求失败,请稍后重试";
        [hud hide:YES afterDelay:1.2];
        
        
    }];
    
    
}


#pragma mark -
#pragma mark Table view data source


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topicsArray.count;
}
// Customize the appearance of table view cells.
- (topicHistoryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *commentDic = self.topicsArray[indexPath.row];
    
    topicHistoryTableViewCell *cell =(topicHistoryTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"topicsCell"];
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"topicHistoryTableViewCell" owner:self options:nil] objectAtIndex:0];//加载nib文件
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.backgroundColor = [UIColor clearColor];
    NSString * date = [[commentDic objectForKey:@"topic_day"] componentsSeparatedByString:@" "][0];
    
    [cell.topicLabel setText:[commentDic objectForKey:@"topic_content"]];
    [cell.dateLabel setText:date];
    [cell.commentCountLabel setText:[NSString stringWithFormat:@"评:%@",[commentDic objectForKey:@"commentsCount"]]];

    

    return cell;
}


#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *commentDic = self.topicsArray[indexPath.row];
    NSString *date = [commentDic objectForKey:@"topic_day"];
    
    NSString *topic = [commentDic objectForKey:@"topic_content"];

//
//    commentDetailViewController *commentDetail = [[commentDetailViewController alloc] initWithNibName:@"commentDetailViewController" bundle:nil];
//    commentDetail.username = [commentDic objectForKey:@"comment_user"];
//    commentDetail.likeCount = [commentDic objectForKey:@"upsCount"];
//    commentDetail.commentContent = [commentDic objectForKey:@"comment_content"];
//    commentDetail.commentID = [commentDic objectForKey:@"comment_id"];
//    
    
    topicsViewController *topicVC = [[topicsViewController alloc] initWithNibName:@"topicsViewController" bundle:nil];
    

    topicVC.topic = topic;
    topicVC.topicDay = date;
    topicVC.isFromHistory = YES;
        

    [self.navigationController pushViewController:topicVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
   
    
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
