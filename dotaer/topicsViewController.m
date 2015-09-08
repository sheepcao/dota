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

@interface topicsViewController ()

@property (nonatomic,strong) NSMutableArray *commentsArray;

@end

@implementation topicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.topicLabel setText:self.topic];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.topicDay forKey:@"topicDay"];
    [self.imgDelegate cancelNewImg];
    
    self.commentsArray = [[NSMutableArray alloc] init];
    [self requestComments];
}

-(void)requestComments
{
    NSDictionary *parameters = @{@"tag": @"fetchComments",@"topicDate":self.topicDay};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:20];  //Time out after 25 seconds
    
    
    [manager POST:@"http://localhost/~ericcao/comments.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"comment Json: %@", responseObject);
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"comments"]];
        
        
        self.commentsArray = [NSMutableArray arrayWithArray:[self sortArray:tempArray]];
        
        //fetch comment and ups OK.........to be continue!!!
        
        [self.commentCountLabel setText:[NSString stringWithFormat:@"%lu条评论",self.commentsArray.count]];
        [self.commentTable reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"comment JsonError: %@", error.localizedDescription);
        NSLog(@"comment Json ERROR: %@",  operation.responseString);
        
        
        
        
        
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
    [cell.likeCountLabel setText:[NSString stringWithFormat:@"%@",[commentDic objectForKey:@"upsCount"]]];
    
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
@end
