//
//  playerPageViewController.m
//  dotaer
//
//  Created by Eric Cao on 7/16/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "playerPageViewController.h"
#import "globalVar.h"
#import "noteTableViewCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLSessionManager.h"

@interface playerPageViewController ()

@end

@implementation playerPageViewController

@synthesize contentView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationItem.backBarButtonItem setTitle:@"附近"];
    self.title = self.playerName;
    NSString *headPath = [imagePath stringByAppendingString:self.playerName];
    
    NSURL *url = [NSURL URLWithString:headPath];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    
    [self requestPlayerInfo];
}

-(void)requestPlayerInfo
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
    
    NSDictionary *parameters = @{@"tag": @"playerInfo",@"name":self.playerName};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //    [manager.requestSerializer setTimeoutInterval:25];  //Time out after 25 seconds
    
    
    [manager POST:playerInfoService parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [hud hide:YES];

        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        [hud hide:YES];

        
    }];
    
    


}

#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView             // Default is 1 if not implemented
{
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section   // fixed font style. use custom view (UILabel) if you want something different
{
    return @"留言板";
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    noteTableViewCell *cell =(noteTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"noteCell"];
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"noteTableViewCell" owner:self options:nil] objectAtIndex:0];//加载nib文件
    }
    cell.backgroundColor = [UIColor clearColor];
    
    cell.usernameLabel.text = @"小白";
    cell.noteTextLabel.text = @"好崇拜你啊";
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



-(void)setupPage
{
    //    self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //    [self.mainScroll setBounces:NO];
    //    [self.mainScroll setBackgroundColor:[UIColor lightGrayColor]];
    //    [self.view addSubview:self.mainScroll];
    
    //    [contentView setFrame:CGRectMake((SCREEN_WIDTH-320)/2, 0, 320, SCREEN_HEIGHT)];
    [self.mainScroll addSubview:contentView];
    
    [self.infoView sendSubviewToBack:self.infoBackImage];
    
    [contentView setBackgroundColor:[UIColor purpleColor]];
    
    [self.mainScroll setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    
    
    //    [self.contentView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 700)];
    
    //    [self.achieveView setFrame:CGRectMake((SCREEN_WIDTH-320)/2, 200, 320, 107)];
    //    [self.infoView setFrame:CGRectMake((SCREEN_WIDTH-320)/2, 0, 320, 200)];
    //    UIView * content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 700)];
    //    [content addSubview:self.infoView];
    //    [content addSubview:self.achieveView];
    //    [self.mainScroll addSubview: content];
    //    [self.infoView setBackgroundColor:[UIColor blueColor]];
    //    [self.infoView sendSubviewToBack:self.infoBackImage];
    //
    //    [self.contentView addSubview: self.infoView];
    //    [contentView addSubview: self.achieveView];
    
    
    //    UIView *contentView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.self.mainScroll.contentSize.width, self.mainScroll.contentSize.height/2)];
    //    [contentView1 setBackgroundColor:[UIColor greenColor]];
    
    
}

@end
