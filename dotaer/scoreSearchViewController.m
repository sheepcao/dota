//
//  scoreSearchViewController.m
//  dotaer
//
//  Created by Eric Cao on 9/12/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//
#import <GoogleMobileAds/GoogleMobileAds.h>

#import "scoreSearchViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "globalVar.h"
#import "heroDetailTableViewCell.h"
#import "testSearchViewController.h"

@interface scoreSearchViewController ()<GADBannerViewDelegate>

@property (nonatomic ,strong) NSArray *heroInfosArray;
@property (nonatomic ,strong) NSArray *TTheroInfosArray;
@property (nonatomic ,strong) NSArray *JJCheroInfosArray;
@property (nonatomic ,strong) NSDictionary *playerInfosDic;

@property (nonatomic ,strong) NSString *userID;

@end

@implementation scoreSearchViewController

bool mainScoreFinish;
bool TTHeroScoreFinish;
bool JJCHeroScoreFinish;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title =self.keyword;
    self.heroInfosArray = [[NSArray alloc] init];
    
    mainScoreFinish = NO;
    TTHeroScoreFinish = NO;
    JJCHeroScoreFinish = NO;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.tag = 123;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在查询";
    hud.dimBackground = YES;
    
    
    //    [self requestExtroInfoWithUser:self.keyword];
    
    [self requestGamerID:self.keyword];
    
    [self.TTScores setEnabled:NO];
    [self.JJCScores setEnabled:YES];
    [self.TTScores setSelected:YES];
    [self.JJCScores setSelected:NO];
    
    [self.TTScores setTitleColor:[UIColor colorWithRed:201/255.0f green:115/255.0f blue:17/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.JJCScores setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem=newBackButton;
    
    self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-64-50,SCREEN_WIDTH, 50)];
    self.bannerView.delegate = self;
    self.bannerView.adUnitID =ADMOB_ID;
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    
    
    [self.bannerView loadRequest:request];
    [self.view addSubview:self.bannerView];
    
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    for (NSLayoutConstraint *c in self.view.constraints) {
        [self.view removeConstraint:c];
        
    }
    
    NSLog(@"disappear!!!!!");
}


-(void)requestGamerID:(NSString *)username
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:37.0) Gecko/20100101 Firefox/37.0" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    [manager.requestSerializer setTimeoutInterval:30];
    
    NSURL *url = [NSURL URLWithString: [username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *infoURLstring =[NSString stringWithFormat: @"http://score.5211game.com/RecordCenter/?u=%@&t=10001",url];
    NSLog(@"infoURLstring-----%@",infoURLstring);
    
    
    //
    [manager GET:infoURLstring parameters:nil success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
        
        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"response: %@", aString);
        
        testSearchViewController *searVC = [[testSearchViewController alloc] init];
        NSString *gamerID = [searVC pickGamerID:responseObject];
        
        NSLog(@"gamerID----:%@",gamerID);
        if (gamerID) {
            [self requestScores:gamerID];
            [self requestTTHeroScores:gamerID];
        }else
        {
            MBProgressHUD *hud =(MBProgressHUD *)[self.view viewWithTag:123];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请重新输入验证码";
            if (hud) {
                [hud hide:YES afterDelay:0.85];
            }
        }
  

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        
        
    }];
    
}





-(void)requestScores:(NSString *)userID
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30];
    
    
    NSString *infoURLstring = @"http://score.5211game.com/RecordCenter/request/record";
    
    NSDictionary *parameters = @{@"method": @"getrecord",@"u":userID,@"t":@"10001"};
    
    
    
    [manager POST:infoURLstring parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        NSLog(@"Scores: %@", responseObject);
        
         mainScoreFinish = YES;
        self.playerInfosDic = [NSDictionary dictionaryWithDictionary:responseObject];
        
        [self setupTTinfosWithDic:self.playerInfosDic];


        
        if (TTHeroScoreFinish) {
            
            MBProgressHUD *hud =(MBProgressHUD *)[self.view viewWithTag:123];
            
            if (hud) {
                [hud hide:YES afterDelay:0.5];
            }
            
        }
  
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"Scores ERROR: %@",  operation.responseString);
        
        MBProgressHUD *hud =(MBProgressHUD *)[self.view viewWithTag:123];
        
        if (hud) {
            [hud hide:YES afterDelay:0.5];
        }
        
        
    }];
    
}



//-(void)requestScores:(NSString *)userID
//{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//    [manager.requestSerializer setTimeoutInterval:30];
//    
//    NSTimeInterval stamp = [[NSDate date] timeIntervalSince1970];
//    
//    NSString *infoURLstring = [NSString stringWithFormat:@"http://i.5211game.com/request/rating/?r=%.0f",stamp*1000];
//    
//    NSDictionary *parameters = @{@"method": @"getrating",@"u":userID,@"t":@"10001"};
//    
//    
//    
//    [manager POST:infoURLstring parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//        
//        mainScoreFinish = YES;
//        NSLog(@"Scores: %@", responseObject);
//        
//        self.playerInfosDic = [NSDictionary dictionaryWithDictionary:responseObject];
//        
//        [self setupTTinfosWithDic:self.playerInfosDic];
//        
//        if (JJCHeroScoreFinish && TTHeroScoreFinish) {
//            
//            MBProgressHUD *hud =(MBProgressHUD *)[self.view viewWithTag:123];
//            
//            if (hud) {
//                [hud hide:YES];
//            }
//            
//            NSHTTPCookie *cookie;
//            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//            for (cookie in [storage cookies])
//            {
//                [storage deleteCookie:cookie];
//            }
//        }
//        
//        
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error.localizedDescription);
//        NSLog(@"Scores ERROR: %@",  operation.responseString);
//        
//        MBProgressHUD *hud =(MBProgressHUD *)[self.view viewWithTag:123];
//        
//        if (hud) {
//            [hud hide:YES afterDelay:0.5];
//        }
//        
//        NSHTTPCookie *cookie;
//        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        for (cookie in [storage cookies])
//        {
//            [storage deleteCookie:cookie];
//        }
//    }];
//    
//}


-(void)requestTTHeroScores:(NSString *)userID
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30];
    
    
    NSString *infoURLstring = @"http://score.5211game.com/RecordCenter/request/record";
    
    NSDictionary *parameters = @{@"method": @"ladderheros",@"u":userID,@"t":@"10001"};
    
    
    
    [manager POST:infoURLstring parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        TTHeroScoreFinish = YES;
        NSLog(@"TTHeroScores: %@", responseObject);
        
        self.TTheroInfosArray = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"ratingHeros"]];
        self.TTheroInfosArray = [self sortArray:self.TTheroInfosArray];
        
        self.heroInfosArray = [NSArray arrayWithArray:self.TTheroInfosArray];
        
        NSLog(@"heroInfosArray: %@", self.heroInfosArray);
        [self.heroInfoTable reloadData];
        
        
        if (mainScoreFinish) {
            
            MBProgressHUD *hud =(MBProgressHUD *)[self.view viewWithTag:123];
            
            if (hud) {
                [hud hide:YES afterDelay:0.5];
            }
            
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"Scores ERROR: %@",  operation.responseString);
        
        MBProgressHUD *hud =(MBProgressHUD *)[self.view viewWithTag:123];
        
        if (hud) {
            [hud hide:YES afterDelay:0.5];
        }
        
      
    }];
    
}

-(void)requestJJCHeroScores:(NSString *)userID
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30];
    
    NSTimeInterval stamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *infoURLstring = [NSString stringWithFormat:@"http://i.5211game.com/request/rating/?r=%.0f",stamp*1000];
    
    NSDictionary *parameters = @{@"method": @"ladderheros",@"u":userID,@"t":@"10032"};
    
    
    
    [manager POST:infoURLstring parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        JJCHeroScoreFinish = YES;
        
        
        NSLog(@"JJCHeroScores: %@", responseObject);
        self.JJCheroInfosArray = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"ratingHeros"]];
        
        self.JJCheroInfosArray = [self sortArray:self.JJCheroInfosArray];
        
        
        //        self.heroInfosArray = [NSArray arrayWithArray:self.JJCheroInfosArray];
        
        NSLog(@"heroInfosArray: %@", self.heroInfosArray);
        //        [self.heroInfoTable reloadData];
        
        
        if (mainScoreFinish && TTHeroScoreFinish) {
            
            MBProgressHUD *hud =(MBProgressHUD *)[self.view viewWithTag:123];
            
            if (hud) {
                [hud hide:YES afterDelay:0.5];
            }
            NSHTTPCookie *cookie;
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (cookie in [storage cookies])
            {
                [storage deleteCookie:cookie];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"Scores ERROR: %@",  operation.responseString);
        
        MBProgressHUD *hud =(MBProgressHUD *)[self.view viewWithTag:123];
        
        if (hud) {
            [hud hide:YES afterDelay:0.5];
        }
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            [storage deleteCookie:cookie];
        }
    }];
    
}



#pragma mark -
#pragma mark Table view data source


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.heroInfosArray.count;
}
// Customize the appearance of table view cells.
- (heroDetailTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    heroDetailTableViewCell *cell =(heroDetailTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"heroCell"];
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"heroDetailTableViewCell" owner:self options:nil] objectAtIndex:0];//加载nib文件
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *heroInfoDic = self.heroInfosArray[indexPath.row];
    
    [cell.heroScore setText:[NSString stringWithFormat:@"%d",[[heroInfoDic objectForKey:@"score"] intValue]]];
    [cell.headIMG setImageWithURL:[self loadheroImg:[heroInfoDic objectForKey:@"heroId"]]];
    
    [cell.gameTotal setText:[NSString stringWithFormat:@"%d",[[heroInfoDic objectForKey:@"total"] intValue]]];
    [cell.winningRate setText:[heroInfoDic objectForKey:@"r_win"]];
    [cell.MVPCount setText:[NSString stringWithFormat:@"%d",[[heroInfoDic objectForKey:@"mvp"] intValue]]];
    [cell.killCount setText:[NSString stringWithFormat:@"%d",[[heroInfoDic objectForKey:@"herokill"] intValue]]];
    
    
    
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *tet = [[UIView alloc] initWithFrame:CGRectMake(0, 0,tableView.frame.size.width, 1.5)];
    
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"blackBack.png"]];
    
    [backImg setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [tet addSubview:backImg];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 60, 30)];
    title.backgroundColor = [UIColor clearColor];
    title.font=[UIFont fontWithName:@"Helvetica-Bold" size:14.5];
    title.textColor = [UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0];
    [title setText:@"战斗详情"];
    [tet addSubview:title];
    
    
    return tet;
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 38;
}



-(NSURL *)loadheroImg:(NSString *)ImgName
{
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"http://i.5211game.com/img/dota/hero/%@.jpg",ImgName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    return url;
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

-(void)setupTTinfosWithDic:(NSDictionary *)dic
{
    NSDictionary *TTDic = [dic objectForKey:@"ttInfos"];
    if (![TTDic isKindOfClass:[NSNull class]] && TTDic.count>0) {
        [self.ScoreLabel setText:[NSString stringWithFormat:@"%d",[[dic objectForKey:@"rating"] intValue]]];
        [self.totalGameLabel setText:[NSString stringWithFormat:@"%d",[[TTDic objectForKey:@"Total"] intValue]]];
        [self.winningLabel setText:[TTDic objectForKey:@"R_Win"]];
        [self.MVPsLabel setText:[NSString stringWithFormat:@"%d",[[TTDic objectForKey:@"MVP"] intValue]]];
    }else
    {
        [self.ScoreLabel setText:@"0"];
        [self.totalGameLabel setText:@"0"];
        [self.winningLabel setText:@"0"];
        [self.MVPsLabel setText:@"0"];
    }
    
}

-(void)setupJJCinfosWithDic:(NSDictionary *)dic
{
    
    NSDictionary *JJCDic = [dic objectForKey:@"jjcInfos"];
    if (![JJCDic isKindOfClass:[NSNull class]] && JJCDic.count>0) {
        [self.ScoreLabel setText:[NSString stringWithFormat:@"%d",[[dic objectForKey:@"jjcRating"] intValue]]];
        [self.totalGameLabel setText:[NSString stringWithFormat:@"%d",[[JJCDic objectForKey:@"Total"] intValue]]];
        [self.winningLabel setText:[JJCDic objectForKey:@"R_Win"]];
        [self.MVPsLabel setText:[NSString stringWithFormat:@"%d",[[JJCDic objectForKey:@"MVP"] intValue]]];
    }else
    {
        [self.ScoreLabel setText:@"0"];
        [self.totalGameLabel setText:@"0"];
        [self.winningLabel setText:@"0"];
        [self.MVPsLabel setText:@"0"];
    }
    
}



- (IBAction)TTtapped:(UIButton *)sender {
    
    [self.TTScores setEnabled:NO];
    [self.JJCScores setEnabled:YES];
    [self.TTScores setSelected:YES];
    [self.JJCScores setSelected:NO];
    
    [self.TTScores setTitleColor:[UIColor colorWithRed:201/255.0f green:115/255.0f blue:17/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.JJCScores setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self setupTTinfosWithDic:self.playerInfosDic];
    
    
    self.heroInfosArray = self.TTheroInfosArray;
    [self.heroInfoTable reloadData];
    
    
    
}

- (IBAction)JJCTapped:(id)sender {
    
    [self.TTScores setEnabled:YES];
    [self.JJCScores setEnabled:NO];
    [self.TTScores setSelected:NO];
    [self.JJCScores setSelected:YES];
    
    [self.JJCScores setTitleColor:[UIColor colorWithRed:201/255.0f green:115/255.0f blue:17/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.TTScores setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self setupJJCinfosWithDic:self.playerInfosDic];
    
    self.heroInfosArray = self.JJCheroInfosArray;
    
    [self.heroInfoTable reloadData];
    
    
}


- (NSArray *)sortArray:(NSArray *)orignalArray
{
    NSSortDescriptor *sortDescriptor;
    NSArray *sortedArray;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Total"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    sortedArray = [orignalArray sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
    
}



@end
