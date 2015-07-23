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
    
    
    [manager POST:playerInfoService parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        [hud hide:YES];

        NSLog(@"JSON: %@", responseObject);
        
        [self setupPageWithDic:responseObject];
        


        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        [hud hide:YES];

        
    }];
    

}


-(void)setupPageWithDic:(NSDictionary *)dic
{
    NSString *headPath = [imagePath stringByAppendingString:self.playerName];
    
    NSURL *url = [NSURL URLWithString:headPath];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img;
    if (data) {
        img = [[UIImage alloc] initWithData:data];
    }else
    {
        img = [UIImage imageNamed:@"defaultHead"];
    }
    [self.headImage setImage:img];
    
    [self.ageLabel setText:[dic objectForKey:@"age"]];
    [self.sexImage setImage:[UIImage imageNamed:[dic objectForKey:@"sex"]]];
    [self.distanceLabel setText:[NSString stringWithFormat:@"%ld米",self.distance]];
    
    
    if ([self.userSignature isEqualToString:@"编辑个人签名..."]) {
        self.userSignature = @"签名的力气都用去打dota了!";
    }
    [self.signatureLabel setText:self.userSignature];
    [self.gameIDLabel setText:[NSString stringWithFormat:@"ID:%@",[dic objectForKey:@"gameID"]]];
    [self.JJCLabel setText:[dic objectForKey:@"JJCscore"]];
    [self.TTLabel setText:[dic objectForKey:@"TTscore"]];
    [self.soldierLabel setText:[dic objectForKey:@"soldier"]];
    [self.ratioLabel setText:[NSString stringWithFormat:@"胜率:%@%%",[dic objectForKey:@"WinRatio"]]];
    [self.heroFirstLabel setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[dic objectForKey:@"heroFirst"] ofType:@"jpg"]]];
    [self.heroSecondLabel setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[dic objectForKey:@"heroSecond"] ofType:@"jpg"]]];
    [self.heroThirdLabel setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[dic objectForKey:@"heroThird"] ofType:@"jpg"]]];


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

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section   // fixed font style. use custom view (UILabel) if you want something different
//{
//    return @"留言板";
//}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 60, 31)];
    title.backgroundColor = [UIColor clearColor];
    title.font=[UIFont fontWithName:@"Helvetica" size:12];
    [title setText:@"留言板"];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 2, 60, 31)];
    btn.backgroundColor = [UIColor purpleColor];
    btn.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
    [btn setTitle:@"留言" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leaveMesg) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
    [sectionView setBackgroundColor:[UIColor lightGrayColor]];
    [sectionView addSubview:btn];
    [sectionView addSubview:title];

    return sectionView;
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

-(void)leaveMesg
{
    NSLog(@"tao leave message...");
    UIView *sendNoteView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [sendNoteView setBackgroundColor:[UIColor clearColor]];

    
    [self.view addSubview:sendNoteView];
    
    
    UITextView *noteText = [[UITextView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/10, SCREEN_HEIGHT*3/11, SCREEN_WIDTH*4/5, SCREEN_HEIGHT/3)];
    [noteText setBackgroundColor:[UIColor yellowColor]];
    
    [sendNoteView addSubview:noteText];
    
    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(noteText.frame.origin.x+noteText.frame.size.width-80, noteText.frame.origin.y-32, 60, 30)];
    [submit setTitle:@"提交" forState:UIControlStateNormal];
    [sendNoteView addSubview:submit];
    

    [UIView animateWithDuration:0.85 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [sendNoteView setCenter:CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT)/2)];
    } completion:^(BOOL finished) {
        
    }];
    [noteText becomeFirstResponder];

}


-(void)setupPage
{
//    //    self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    //    [self.mainScroll setBounces:NO];
//    //    [self.mainScroll setBackgroundColor:[UIColor lightGrayColor]];
//    //    [self.view addSubview:self.mainScroll];
//    
//    //    [contentView setFrame:CGRectMake((SCREEN_WIDTH-320)/2, 0, 320, SCREEN_HEIGHT)];
//    [self.mainScroll addSubview:contentView];
//    
//    [self.infoView sendSubviewToBack:self.infoBackImage];
//    
//    [contentView setBackgroundColor:[UIColor purpleColor]];
//    
//    [self.mainScroll setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
//    
    
    
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
