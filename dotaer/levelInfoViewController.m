//
//  levelInfoViewController.m
//  dotaer
//
//  Created by Eric Cao on 7/21/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "levelInfoViewController.h"
#import "globalVar.h"
#import "AFHTTPRequestOperationManager.h"

@interface levelInfoViewController ()<UIAlertViewDelegate,NSURLConnectionDelegate>
@property (strong,nonatomic) NSURLConnection *theConnection;
@property (strong,nonatomic) NSMutableData *aData;
@property (strong,nonatomic) NSString *gameID;
@property (strong,nonatomic) NSString *gameName;

@end

@implementation levelInfoViewController
@synthesize  theConnection;
@synthesize aData;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"实力认证";
    

    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://passport.5211game.com/t/Login.aspx?ReturnUrl=http%3a%2f%2fi.5211game.com%2flogin.aspx%3freturnurl%3d%252frating&loginUserName="]];
    [self.levelWebview loadRequest:request];
    self.levelWebview.delegate = self;
    self.levelWebview.scalesPageToFit = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
//    NSString *URLString = [NSString stringWithFormat:@"%@", [webView.request URL]] ;
//    
//    NSArray *seperateByMID = [URLString componentsSeparatedByString:@"Login"];
//    if (seperateByMID.count>1) {
//        
//        
//        
//    }else
//    {
//        UIImageView *juggIMG = [[UIImageView alloc] initWithFrame:self.levelWebview.frame];
//        [juggIMG setImage:[UIImage imageNamed:@"juggBACK.png"]];
//        [self.view addSubview:juggIMG];
//        
//    }

}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    
    NSString  *html = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
    NSLog(@"html:%@",html);
    NSError *error;
    
  
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"YY.d.u = (.+)" options:0 error:&error];
    
    if (regex != nil) {
        
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:html options:0 range:NSMakeRange(0, [html length])];
        
        if (firstMatch) {
            
            NSRange resultRange = [firstMatch rangeAtIndex:0]; //等同于 firstMatch.range --- 相匹配的范围
            
            //从urlString当中截取数据
            
            NSString *result=[html substringWithRange:resultRange];
            
            //输出结果
            result =  [result stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSLog(@"result-------%@",result);
            
            NSArray *resultArray = [result componentsSeparatedByString:@","];
            if(resultArray.count>2)
            {
                NSString *first = [resultArray[0] componentsSeparatedByString:@"="][1];
                NSString *second = [resultArray[1] componentsSeparatedByString:@"="][1];
                second = [second stringByReplacingOccurrencesOfString:@"'" withString:@""];
             
                NSLog(@"first:%@  and second :%@",first,second);
                self.gameID = first;
                self.gameName = second;
            }
            
        }
    }
    
    NSString *URLString = [NSString stringWithFormat:@"%@", [webView.request URL]] ;
    
    NSArray *seperateByMID = [URLString componentsSeparatedByString:@"Login"];
    if (seperateByMID.count>1) {
        
        
    }else
    {
        
      
        
//        [self.levelWebview setHidden:YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [manager.requestSerializer setTimeoutInterval:30];
        
        NSTimeInterval stamp = [[NSDate date] timeIntervalSince1970];

        NSString *infoURLstring = [NSString stringWithFormat:@"http://i.5211game.com/request/rating/?r=%.0f",stamp*1000];
        
        NSDictionary *parameters = @{@"method": @"getrating",@"u":self.gameID,@"t":@"10001"};

        [manager POST:infoURLstring parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            
            NSLog(@"JSON: %@", responseObject);

            [self submitLevel:responseObject];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error.localizedDescription);
            NSLog(@"JSON ERROR: %@",  operation.responseString);
        }];
    }
    
    
}



- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError:%@", error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //eric:
    NSLog(@"request URL = %@", [request URL]);
    NSString *URLString = [NSString stringWithFormat:@"%@", [request URL]] ;
    
    NSArray *seperateByMID = [URLString componentsSeparatedByString:@"Login"];
    if (seperateByMID.count>1) {
       
   
        
    }else
    {
        UIImageView *juggIMG = [[UIImageView alloc] initWithFrame:self.levelWebview.frame];
        [juggIMG setImage:[UIImage imageNamed:@"juggBACK.png"]];
        [self.view addSubview:juggIMG];
        [self.levelWebview setHidden:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.tag = 123;
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"战绩读取中...";
        hud.dimBackground = YES;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];

    }
//
    

    return YES;
}

-(UIImage *)getImageFromView:(UIView *)view{
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(view.bounds.size);
    //获取图像
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
    
}
//- (IBAction)uploadLevel:(UIButton *)sender {
//    
//    if (sender.tag == 10) {
//        UIAlertView *notAllowAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未登录，无法上传战绩." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [notAllowAlert show];
//    }else if (sender.tag == 11)
//    {
//        NSLog(@"upload tap!!!");
//        UIImage *levelImage = [self getImageFromView:self.levelWebview];
//
//        [self doUpload:levelImage];
//    }
//}


-(void)submitLevel:(NSDictionary *)dic
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
        
//        NSMutableArray *JJCheroIDs = [NSMutableArray arrayWithObject:[JJCdetail objectForKey:@"AdeptHero1"]];
//        
//        if ([JJCdetail objectForKey:@"AdeptHero2"]) {
//            [JJCheroIDs addObject:[JJCdetail objectForKey:@"AdeptHero2"]];
//        }
//        if ([JJCdetail objectForKey:@"AdeptHero3"]) {
//            [JJCheroIDs addObject:[JJCdetail objectForKey:@"AdeptHero3"]];
//        }
//        
//        NSLog(@"JJC info:%@  heroIDs:--%@",JJCinfoFull,JJCheroIDs);

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
        
//        NSMutableArray *TTheroIDs = [NSMutableArray arrayWithObject:[TTdetail objectForKey:@"AdeptHero1"]];
//        
//        if ([TTdetail objectForKey:@"AdeptHero2"]) {
//            [TTheroIDs addObject:[TTdetail objectForKey:@"AdeptHero2"]];
//        }
//        if ([TTdetail objectForKey:@"AdeptHero3"]) {
//            [TTheroIDs addObject:[TTdetail objectForKey:@"AdeptHero3"]];
//        }
//        
//        NSLog(@"TT info:%@  heroIDs:--%@",TTinfoFull,TTheroIDs);
        
        

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
        
//        NSMutableArray *MJheroIDs = [NSMutableArray arrayWithObject:[MJdetail objectForKey:@"AdeptHero1"]];
//        
//        if ([MJdetail objectForKey:@"AdeptHero2"]) {
//            [MJheroIDs addObject:[MJdetail objectForKey:@"AdeptHero2"]];
//        }
//        if ([MJdetail objectForKey:@"AdeptHero3"]) {
//            [MJheroIDs addObject:[MJdetail objectForKey:@"AdeptHero3"]];
//        }
//        
//        NSLog(@"JJC info:%@  heroIDs:--%@",MJinfoFull,MJheroIDs);
        
        
    }
  
    
    
    
    NSDictionary *para = @{@"tag": @"confirmLevel",@"username":username,@"gameID":self.gameID,@"gameName":self.gameName};
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
    
    
    MBProgressHUD *hud = (MBProgressHUD *)[self.view viewWithTag:123];
    [hud hide:YES];

    NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:paraTemp];
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30];

    
    [manager POST:confirmLevel parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"战绩认证成功";
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];

        [hud hide:YES afterDelay:1.5];
    

        NSLog(@"JSON: %@", responseObject);
        
        [self.TTscoreDelegate fillTTScore:[[responseObject objectForKey:@"TTinfo"] objectForKey:@"TTscore"]];
        
        NSLog(@"JJCheroFirst: %@", [[responseObject objectForKey:@"JJCinfo"] objectForKey:@"JJCheroFirst"]);
        
        [self performSelector:@selector(backToSelfInfo) withObject:nil afterDelay:3];
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"认证失败，请检查网络.";
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        
        [hud hide:YES afterDelay:1.5];


        
        
    }];
}


-(void)backToSelfInfo
{
    [self.navigationController popViewControllerAnimated:YES];

}

//
//-(void)doUpload:(UIImage *)levelImage
//{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.mode = MBProgressHUDModeAnnularDeterminate;
//    hud.labelText = @"Uploading";
//    hud.dimBackground = YES;
//    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
//    NSString *username = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"userInfoDic"] objectForKey:@"username"];
//
//    
//    NSDictionary *parameters = @{@"tag": @"uploadLevel",@"username":username};
//    
//    
//    //upload head image
//    UIImage *image = levelImage;
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
//    [manager.requestSerializer setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//    
//    
//    AFHTTPRequestOperation *op = [manager POST:registerService parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//
//        
//        NSString *fileName = [NSString stringWithFormat:@"%@_result.png",username];
//        
//        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
//        
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
//        hud.mode = MBProgressHUDModeCustomView;
//        hud.labelText = @"Completed";
//        [hud hide:YES afterDelay:1.0];
//        
//        [self performSelector:@selector(successUploadAlert) withObject:nil afterDelay:1.1];
//        
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        hud.mode = MBProgressHUDModeCustomView;
//        hud.labelText = @"Error";
//        [hud hide:YES afterDelay:1.5];
//        
//        NSLog(@"Error: %@ ***** %@", operation.responseString, error.localizedDescription);
//
//            UIAlertView *registerFailedAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"上传失败，请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [registerFailedAlert show];
//        
//        
//    }];
//    
//    
//    [op setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
//                                 long long totalBytesWritten,
//                                 long long totalBytesExpectedToWrite) {
//        
//        
//        hud.progress = totalBytesWritten/totalBytesExpectedToWrite;
//        
//        NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
//    }];
//    
//    [op start];
//
//}

-(void)successUploadAlert
{
    UIAlertView *registerSuccessAlert = [[UIAlertView alloc] initWithTitle:@"恭喜" message:@"您已成功上传您的战绩，我们将2小时之内审核您的认证信息，请耐心等待。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [registerSuccessAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
