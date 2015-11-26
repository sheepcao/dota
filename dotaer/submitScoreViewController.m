//
//  submitScoreViewController.m
//  dotaer
//
//  Created by Eric Cao on 8/12/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "submitScoreViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "globalVar.h"
#import "DataCenter.h"
#import "popView.h"
#import "testSearchViewController.h"

@interface submitScoreViewController ()

@property (strong,nonatomic) MBProgressHUD *hudSmall;


@property (nonatomic, strong) NSString *VIEWSTATEGENERATOR ;
@property (nonatomic, strong) NSString *VIEWSTATE;
@property (nonatomic, strong) NSString *EVENTVALIDATION;
@property (nonatomic, strong) NSString *loginURL;
@end

@implementation submitScoreViewController

@synthesize loginURL;
@synthesize VIEWSTATEGENERATOR;
@synthesize VIEWSTATE;
@synthesize EVENTVALIDATION;
@synthesize hudSmall;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.roundBack.layer.cornerRadius = 7.5;
    self.blurBack.blurRadius = 3.8;
    self.submitBtn.layer.cornerRadius = 15.0f;
    
    self.roundBackIMG.layer.cornerRadius = 7.5;
    self.roundBackIMG.layer.masksToBounds = YES;
    
    [self.submitBtn setEnabled:NO];
    [self requestExtroInfo];
    
}








-(void)requestExtroInfo
{
    hudSmall = [MBProgressHUD showHUDAddedTo:self.loadingView animated:YES];
    hudSmall.margin = 5;
    hudSmall.color = [UIColor darkGrayColor];
    hudSmall.mode = MBProgressHUDModeIndeterminate;
    hudSmall.cornerRadius = 5.8f;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:37.0) Gecko/20100101 Firefox/37.0" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    [manager.requestSerializer setTimeoutInterval:12];
    
    [[DataCenter sharedDataCenter] clearRequestCache];
    
    NSString *infoURLstring = @"http://score.5211game.com/Ranking/ranking.aspx";
    
    //
    [manager GET:infoURLstring parameters:nil success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
        
        testSearchViewController * testSearchVC = [[testSearchViewController alloc] init];
        
        
        loginURL = [testSearchVC pickURL:responseObject];
        
        
        VIEWSTATEGENERATOR = [testSearchVC pickVIEWSTATEGENERATOR:responseObject];
        VIEWSTATE = [testSearchVC pickVIEWSTATE:responseObject];
        EVENTVALIDATION = [testSearchVC pickEVENTVALIDATION:responseObject];
        
        NSLog(@"VIEWSTATE--%@\nVIEWSTATEGENERATOR--%@\nEVENTVALIDATION--%@\n",VIEWSTATE,VIEWSTATEGENERATOR,EVENTVALIDATION);
        
        
        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"result------%@\n",aString);
        
        
        [self requestValidationImage];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        
        
    }];
}


-(void)requestValidationImage
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:37.0) Gecko/20100101 Firefox/37.0" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    [manager.requestSerializer setTimeoutInterval:30];
    
    
    
    NSString *infoURLstring = @"http://passport.5211game.com/ValidateCode.aspx";
    
    //
    [manager GET:infoURLstring parameters:nil success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
        
        
        UIImage *aString = [[UIImage alloc] initWithData:responseObject];
        
        [self.codeImage setBackgroundImage: aString forState:UIControlStateNormal];
        [self.submitBtn setEnabled:YES];
        
        if (hudSmall) {
            [hudSmall hide:YES];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        if (hudSmall) {
            [hudSmall hide:YES];
        }
        
    }];
}


- (void)prepareCociesWith:(MBProgressHUD *)hud{
    
    [self.codeField resignFirstResponder];
    

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:37.0) Gecko/20100101 Firefox/37.0" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    [manager.requestSerializer setTimeoutInterval:30];
    
    
    
    NSString *infoURLstring = [NSString stringWithFormat:@"http://passport.5211game.com%@",loginURL];
    NSString *code = @"000000";
    if (![self.codeField.text isEqualToString:@""]) {
        code= self.codeField.text;
        
    }
    
    if(!loginURL||!VIEWSTATE||!EVENTVALIDATION||!VIEWSTATEGENERATOR)
    {
        
        hud.labelText = @"网络读取失败，请重试";
        [hud hide:YES afterDelay:1.0f];
        
        return ;
    }
    

    if (!self.username.text || [self.username.text isEqualToString:@""] || !self.password.text || [self.password.text isEqualToString:@""] || !self.codeField.text || [self.codeField.text isEqualToString:@""])
    {
        hud.labelText = @"请完整填写绑定信息";
        [hud hide:YES afterDelay:1.0f];
        return ;

    }
    
    NSDictionary *parameters = @{@"__VIEWSTATE":VIEWSTATE,@"__VIEWSTATEGENERATOR":VIEWSTATEGENERATOR,@"__EVENTVALIDATION":EVENTVALIDATION,@"txtAccountName":self.username.text,@"txtPassWord":self.password.text,@"txtValidateCode":code,@"ImgButtonLogin.x":@65,@"ImgButtonLogin.y":@13};
    
    [manager POST:infoURLstring parameters:parameters success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
        
        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"login success:%@",aString);
      
        testSearchViewController * testSearchVC = [[testSearchViewController alloc] init];
        
        NSString *userID = [testSearchVC pickUserID:responseObject];
        if (userID) {
            
            [self requestScores:userID andUserName:self.username.text andPassword:self.password.text];
        }else
        {
            [self changeCode:nil];
            [self.codeField setText:@""];
            
            hud.labelText = @"验证码输入错误";
            [hud hide:YES afterDelay:1.0f];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        hud.labelText = @"网络读取失败，请重试";
        [hud hide:YES afterDelay:1.0f];
        
    }];
    
    
    
}






-(void)requestScores:(NSString *)userID andUserName:(NSString *)username andPassword:(NSString *)password
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30];
    
    
    NSString *infoURLstring = @"http://score.5211game.com/RecordCenter/request/record";
    
    NSDictionary *parameters = @{@"method": @"getrecord",@"u":userID,@"t":@"10001"};
    
    [manager POST:infoURLstring parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        
        [self submitLevel:responseObject ForUserID:userID ForUserName:username AndPassword:password];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);

        MBProgressHUD *hud1 = (MBProgressHUD *)[self.view viewWithTag:123];
        if (hud1) {
            [hud1 hide:YES];
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"认证失败，请检查网络.";
        
        [hud hide:YES afterDelay:1.5];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)submit:(id)sender {
    
    [self.view endEditing:YES];// this will do the trick

    
    if (![self.username.text isEqualToString:@""] && ![self.password.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.tag = 123;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"战绩读取中...";
        hud.dimBackground = YES;

        
        [self prepareCociesWith:hud];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"用户名或密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}



-(void)submitLevel:(NSDictionary *)dic ForUserID:(NSString *)userID ForUserName:(NSString *)gameName AndPassword:(NSString *)passwrod
{
    
    
    
    NSString *username = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"userInfoDic"] objectForKey:@"username"];
    
    
    //------------setup JJC info
    NSMutableDictionary *JJCinfoFull = [NSMutableDictionary dictionaryWithObject:@"no" forKey:@"haveScore"];
    NSDictionary *JJCdetail = [dic objectForKey:@"jjcInfos"];
    if (![JJCdetail isKindOfClass:[NSNull class]]) {
        NSDictionary *JJCinfo = @{
                                  @"haveScore":@"yes",
                                  @"JJCscore":[dic objectForKey:@"jjcRating"],
                                  @"JJCtotal":[JJCdetail objectForKey:@"Total"],
                                  @"JJCmvp":[JJCdetail objectForKey:@"MVP"],
                                  @"JJCPianJiang":[JJCdetail objectForKey:@"PianJiang"],
                                  @"JJCPoDi":[JJCdetail objectForKey:@"PoDi"],
                                  @"JJCPoJun":[JJCdetail objectForKey:@"PoJun"],
                                  @"JJCYingHun":[JJCdetail objectForKey:@"YingHun"],
                                  @"JJCBuWang":[JJCdetail objectForKey:@"BuWang"],
                                  @"JJCFuHao":[JJCdetail objectForKey:@"FuHao"],
                                  @"JJCDoubleKill":[JJCdetail objectForKey:@"DoubleKill"],
                                  @"JJCTripleKill":[JJCdetail objectForKey:@"TripleKill"],
                                  @"JJCWinRatio":[JJCdetail objectForKey:@"R_Win"],
                                  @"JJCheroFirst":[JJCdetail objectForKey:@"AdeptHero1"]
                                  };
        
        JJCinfoFull = [NSMutableDictionary dictionaryWithDictionary:JJCinfo];
        if ([JJCdetail objectForKey:@"AdeptHero2"]) {
            [JJCinfoFull setObject:[JJCdetail objectForKey:@"AdeptHero2"] forKey:@"JJCheroSecond"];
        }else
        {
            [JJCinfoFull setObject:@"none" forKey:@"JJCheroSecond"];
            
        }
        if ([JJCdetail objectForKey:@"AdeptHero3"]) {
            [JJCinfoFull setObject:[JJCdetail objectForKey:@"AdeptHero3"] forKey:@"JJCheroThird"];
        }else
        {
            [JJCinfoFull setObject:@"none" forKey:@"JJCheroThird"];
            
        }
        
       
    }
    
    
    //------------setup TT info
    NSDictionary *TTdetail = [dic objectForKey:@"ttInfos"];
    NSMutableDictionary *TTinfoFull = [NSMutableDictionary dictionaryWithObject:@"no" forKey:@"haveScore"];
    if (![TTdetail isKindOfClass:[NSNull class]]) {
        
        
        NSDictionary *TTinfo = @{
                                 @"haveScore":@"yes",
                                 @"TTscore":[dic objectForKey:@"rating"],
                                 @"TTtotal":[TTdetail objectForKey:@"Total"],
                                 @"TTmvp":[TTdetail objectForKey:@"MVP"],
                                 @"TTPianJiang":[TTdetail objectForKey:@"PianJiang"],
                                 @"TTPoDi":[TTdetail objectForKey:@"PoDi"],
                                 @"TTPoJun":[TTdetail objectForKey:@"PoJun"],
                                 @"TTYingHun":[TTdetail objectForKey:@"YingHun"],
                                 @"TTBuWang":[TTdetail objectForKey:@"BuWang"],
                                 @"TTFuHao":[TTdetail objectForKey:@"FuHao"],
                                 @"TTDoubleKill":[TTdetail objectForKey:@"DoubleKill"],
                                 @"TTTripleKill":[TTdetail objectForKey:@"TripleKill"],
                                 @"TTWinRatio":[TTdetail objectForKey:@"R_Win"],
                                 @"TTheroFirst":[TTdetail objectForKey:@"AdeptHero1"]
                                 };
        
        TTinfoFull = [NSMutableDictionary dictionaryWithDictionary:TTinfo];
        if ([TTdetail objectForKey:@"AdeptHero2"]) {
            [TTinfoFull setObject:[TTdetail objectForKey:@"AdeptHero2"] forKey:@"TTheroSecond"];
        }else
        {
            [TTinfoFull setObject:@"none" forKey:@"TTheroSecond"];
            
        }
        
        if ([TTdetail objectForKey:@"AdeptHero3"]) {
            [TTinfoFull setObject:[TTdetail objectForKey:@"AdeptHero3"] forKey:@"TTheroThird"];
        }else
        {
            [TTinfoFull setObject:@"none" forKey:@"TTheroThird"];
            
        }
        
     
        
    }
    
    
    //------------setup MJ info
    NSDictionary *MJdetail = [dic objectForKey:@"mjInfos"];
    NSMutableDictionary *MJinfoFull = [NSMutableDictionary dictionaryWithObject:@"no" forKey:@"MJhaveScore"];
    if (![MJdetail isKindOfClass:[NSNull class]]) {
        NSDictionary *MJinfo = @{
                                 @"MJhaveScore":@"yes",
                                 @"MJscore":[MJdetail objectForKey:@"MingJiang"],
                                 @"MJtotal":[MJdetail objectForKey:@"Total"],
                                 @"MJmvp":[MJdetail objectForKey:@"MVP"],
                                 @"MJPianJiang":[MJdetail objectForKey:@"PianJiang"],
                                 @"MJPoDi":[MJdetail objectForKey:@"PoDi"],
                                 @"MJPoJun":[MJdetail objectForKey:@"PoJun"],
                                 @"MJYingHun":[MJdetail objectForKey:@"YingHun"],
                                 @"MJBuWang":[MJdetail objectForKey:@"BuWang"],
                                 @"MJFuHao":[MJdetail objectForKey:@"FuHao"],
                                 @"MJDoubleKill":[MJdetail objectForKey:@"DoubleKill"],
                                 @"MJTripleKill":[MJdetail objectForKey:@"TripleKill"],
                                 @"MJWinRatio":[MJdetail objectForKey:@"R_Win"],
                                 @"MJheroFirst":[MJdetail objectForKey:@"AdeptHero1"]
                                 };
        
        MJinfoFull = [NSMutableDictionary dictionaryWithDictionary:MJinfo];
        if ([MJdetail objectForKey:@"AdeptHero2"]) {
            [MJinfoFull setObject:[MJdetail objectForKey:@"AdeptHero2"] forKey:@"MJheroSecond"];
        }else
        {
            [MJinfoFull setObject:@"none" forKey:@"MJheroSecond"];
            
        }
        
        if ([MJdetail objectForKey:@"AdeptHero3"]) {
            [MJinfoFull setObject:[MJdetail objectForKey:@"AdeptHero3"] forKey:@"MJheroThird"];
        }else
        {
            [MJinfoFull setObject:@"none" forKey:@"MJheroThird"];
            
        }
        
        
    }
    
    
    
    
    NSDictionary *para = @{@"tag": @"confirmLevel",@"username":username,@"gameID":userID,@"gameName":gameName,@"password":passwrod};
    NSMutableDictionary *paraTemp = [NSMutableDictionary dictionaryWithDictionary:para];
    if (JJCinfoFull.count>1) {
        [paraTemp setObject:[JJCinfoFull objectForKey:@"haveScore"] forKey:@"JJChaveScore"];
        [paraTemp setObject:[JJCinfoFull objectForKey:@"JJCscore"] forKey:@"JJCscore"];
        [paraTemp setObject:[JJCinfoFull objectForKey:@"JJCtotal"] forKey:@"JJCtotal"];
        [paraTemp setObject:[JJCinfoFull objectForKey:@"JJCmvp"] forKey:@"JJCmvp"];
        [paraTemp setObject:[JJCinfoFull objectForKey:@"JJCPianJiang"] forKey:@"JJCPianJiang"];
        [paraTemp setObject:[JJCinfoFull objectForKey:@"JJCPoDi"] forKey:@"JJCPoDi"];
        [paraTemp setObject:[JJCinfoFull objectForKey:@"JJCPoJun"] forKey:@"JJCPoJun"];
        [paraTemp setObject:[JJCinfoFull objectForKey:@"JJCYingHun"] forKey:@"JJCYingHun"];
        [paraTemp setObject:[JJCinfoFull objectForKey:@"JJCBuWang"] forKey:@"JJCBuWang"];
        [paraTemp setObject:[JJCinfoFull objectForKey:@"JJCFuHao"] forKey:@"JJCFuHao"];
        [paraTemp setObject:[JJCinfoFull objectForKey:@"JJCDoubleKill"] forKey:@"JJCDoubleKill"];
        [paraTemp setObject:[JJCinfoFull objectForKey:@"JJCTripleKill"] forKey:@"JJCTripleKill"];
        [paraTemp setObject:[JJCinfoFull objectForKey:@"JJCWinRatio"] forKey:@"JJCWinRatio"];
        [paraTemp setObject:[JJCinfoFull objectForKey:@"JJCheroFirst"] forKey:@"JJCheroFirst"];
        [paraTemp setObject:[JJCinfoFull objectForKey:@"JJCheroSecond"] forKey:@"JJCheroSecond"];
        [paraTemp setObject:[JJCinfoFull objectForKey:@"JJCheroThird"] forKey:@"JJCheroThird"];
        
    }
    
    if (TTinfoFull.count>1) {
        [paraTemp setObject:[TTinfoFull objectForKey:@"haveScore"] forKey:@"TThaveScore"];
        [paraTemp setObject:[TTinfoFull objectForKey:@"TTscore"] forKey:@"TTscore"];
        [paraTemp setObject:[TTinfoFull objectForKey:@"TTtotal"] forKey:@"TTtotal"];
        [paraTemp setObject:[TTinfoFull objectForKey:@"TTmvp"] forKey:@"TTmvp"];
        [paraTemp setObject:[TTinfoFull objectForKey:@"TTPianJiang"] forKey:@"TTPianJiang"];
        [paraTemp setObject:[TTinfoFull objectForKey:@"TTPoDi"] forKey:@"TTPoDi"];
        [paraTemp setObject:[TTinfoFull objectForKey:@"TTPoJun"] forKey:@"TTPoJun"];
        [paraTemp setObject:[TTinfoFull objectForKey:@"TTYingHun"] forKey:@"TTYingHun"];
        [paraTemp setObject:[TTinfoFull objectForKey:@"TTBuWang"] forKey:@"TTBuWang"];
        [paraTemp setObject:[TTinfoFull objectForKey:@"TTFuHao"] forKey:@"TTFuHao"];
        [paraTemp setObject:[TTinfoFull objectForKey:@"TTDoubleKill"] forKey:@"TTDoubleKill"];
        [paraTemp setObject:[TTinfoFull objectForKey:@"TTTripleKill"] forKey:@"TTTripleKill"];
        [paraTemp setObject:[TTinfoFull objectForKey:@"TTWinRatio"] forKey:@"TTWinRatio"];
        [paraTemp setObject:[TTinfoFull objectForKey:@"TTheroFirst"] forKey:@"TTheroFirst"];
        [paraTemp setObject:[TTinfoFull objectForKey:@"TTheroSecond"] forKey:@"TTheroSecond"];
        [paraTemp setObject:[TTinfoFull objectForKey:@"TTheroThird"] forKey:@"TTheroThird"];
        
    }
    
    if (MJinfoFull.count>1) {
        [paraTemp setObject:[MJinfoFull objectForKey:@"MJhaveScore"] forKey:@"MJhaveScore"];
        
        [paraTemp setObject:[MJinfoFull objectForKey:@"MJscore"] forKey:@"MJscore"];
        [paraTemp setObject:[MJinfoFull objectForKey:@"MJtotal"] forKey:@"MJtotal"];
        [paraTemp setObject:[MJinfoFull objectForKey:@"MJmvp"] forKey:@"MJmvp"];
        [paraTemp setObject:[MJinfoFull objectForKey:@"MJPianJiang"] forKey:@"MJPianJiang"];
        [paraTemp setObject:[MJinfoFull objectForKey:@"MJPoDi"] forKey:@"MJPoDi"];
        [paraTemp setObject:[MJinfoFull objectForKey:@"MJPoJun"] forKey:@"MJPoJun"];
        [paraTemp setObject:[MJinfoFull objectForKey:@"MJYingHun"] forKey:@"MJYingHun"];
        [paraTemp setObject:[MJinfoFull objectForKey:@"MJBuWang"] forKey:@"MJBuWang"];
        [paraTemp setObject:[MJinfoFull objectForKey:@"MJFuHao"] forKey:@"MJFuHao"];
        [paraTemp setObject:[MJinfoFull objectForKey:@"MJDoubleKill"] forKey:@"MJDoubleKill"];
        [paraTemp setObject:[MJinfoFull objectForKey:@"MJTripleKill"] forKey:@"MJTripleKill"];
        [paraTemp setObject:[MJinfoFull objectForKey:@"MJWinRatio"] forKey:@"MJWinRatio"];
        [paraTemp setObject:[MJinfoFull objectForKey:@"MJheroFirst"] forKey:@"MJheroFirst"];
        [paraTemp setObject:[MJinfoFull objectForKey:@"MJheroSecond"] forKey:@"MJheroSecond"];
        [paraTemp setObject:[MJinfoFull objectForKey:@"MJheroThird"] forKey:@"MJheroThird"];
        
    }
    
    

    
    NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:paraTemp];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30];
    
    
    [manager POST:confirmLevel parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        MBProgressHUD *hud1 = (MBProgressHUD *)[self.view viewWithTag:123];
        if (hud1) {
            [hud1 hide:YES];
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"战绩认证成功";
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        
        [hud hide:YES afterDelay:1.5];
        
        
        NSDictionary *userGameAccount = @{@"gameName":gameName,@"gamePassword":passwrod};
        
        [[NSUserDefaults standardUserDefaults] setObject:userGameAccount forKey:username];
        
        
//        NSLog(@"JSON: %@", responseObject);
        
        [self.TTscoreDelegate fillTTScore:[[responseObject objectForKey:@"TTinfo"] objectForKey:@"TTscore"]];
        
        
        [self performSelector:@selector(backToSelfInfo) withObject:nil afterDelay:2];
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        MBProgressHUD *hud1 = (MBProgressHUD *)[self.view viewWithTag:123];
        if (hud1) {
            [hud1 hide:YES];
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"认证失败，请检查网络.";
        
        [hud hide:YES afterDelay:1.5];
        
        [self performSelector:@selector(backToSelfInfo) withObject:nil afterDelay:2];
        
        
        
    }];
}

-(void)backToSelfInfo
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
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
- (IBAction)changeCode:(UIButton *)sender {
    
    [self requestValidationImage];

}
@end
