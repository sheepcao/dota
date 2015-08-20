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
@interface submitScoreViewController ()

@end

@implementation submitScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.roundBack.layer.cornerRadius = 7.5;
    self.blurBack.blurRadius = 3.8;
    self.submitBtn.layer.cornerRadius = 15.0f;
    
}

-(void)requestExtroInfoWithUser:(NSString *)username andPassword:(NSString *)password
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:37.0) Gecko/20100101 Firefox/37.0" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    [manager.requestSerializer setTimeoutInterval:30];


    
    NSString *infoURLstring = @"http://passport.5211game.com/t/Login.aspx?ReturnUrl=http%3a%2f%2fi.5211game.com%2flogin.aspx%3freturnurl%3d%252frating&loginUserName=";

//    [manager GET:infoURLstring parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject){} failure:^(AFHTTPRequestOperation *operation, NSError *error){}];
//    
    [manager GET:infoURLstring parameters:nil success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
       
        NSString *VIEWSTATEGENERATOR = [self pickVIEWSTATEGENERATOR:responseObject];
        NSString *VIEWSTATE = [self pickVIEWSTATE:responseObject];
        NSString *EVENTVALIDATION = [self pickEVENTVALIDATION:responseObject];
        
        NSLog(@"VIEWSTATE--%@\nVIEWSTATEGENERATOR--%@\nEVENTVALIDATION--%@\n",VIEWSTATE,VIEWSTATEGENERATOR,EVENTVALIDATION);
        
        [self requestUserID:VIEWSTATE :VIEWSTATEGENERATOR :EVENTVALIDATION :username :password];
        
        
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
     
        
    }];
}

-(NSString *)pickVIEWSTATEGENERATOR:(NSData *)responseObject
{
    NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSLog(@"response: %@", aString);
    NSError *error2;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"id=\"__VIEWSTATEGENERATOR\" value=\"(.+)\"" options:0 error:&error2];
    if (regex != nil) {
        
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:aString options:0 range:NSMakeRange(0, [aString length])];
        
        if (firstMatch) {
            
            NSRange resultRange = [firstMatch rangeAtIndex:0]; //等同于 firstMatch.range --- 相匹配的范围
            
            //从urlString当中截取数据
            
            NSString *result=[aString substringWithRange:resultRange];
            
            //输出结果
            result =  [result stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSLog(@"result-------%@",result);
            
            
            NSArray *resultArray = [result componentsSeparatedByString:@"value=\""];
            if(resultArray.count>1)
            {
                NSString *string1 = resultArray[1] ;
                NSString *resultString = [string1 componentsSeparatedByString:@"\""][0];
                
                NSLog(@"resultString = %@",resultString);
                return resultString;
            }
            
            
        }
    }

    return nil;
}


-(NSString *)pickVIEWSTATE:(NSData *)responseObject
{
    NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSLog(@"response: %@", aString);
    NSError *error2;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"id=\"__VIEWSTATE\" value=\"(.+)\"" options:0 error:&error2];
    if (regex != nil) {
        
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:aString options:0 range:NSMakeRange(0, [aString length])];
        
        if (firstMatch) {
            
            NSRange resultRange = [firstMatch rangeAtIndex:0]; //等同于 firstMatch.range --- 相匹配的范围
            
            //从urlString当中截取数据
            
            NSString *result=[aString substringWithRange:resultRange];
            
            //输出结果
            result =  [result stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSLog(@"result-------%@",result);
            
            
            NSArray *resultArray = [result componentsSeparatedByString:@"value=\""];
            if(resultArray.count>1)
            {
                NSString *string1 = resultArray[1] ;
                NSString *resultString = [string1 componentsSeparatedByString:@"\""][0];
                
                NSLog(@"resultString = %@",resultString);
                return resultString;

            }
            
            
        }
    }
 
    return nil;
}

-(NSString *)pickEVENTVALIDATION:(NSData *)responseObject
{
    NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSLog(@"response: %@", aString);
    NSError *error2;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"id=\"__EVENTVALIDATION\" value=\"(.+)\"" options:0 error:&error2];
    if (regex != nil) {
        
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:aString options:0 range:NSMakeRange(0, [aString length])];
        
        if (firstMatch) {
            
            NSRange resultRange = [firstMatch rangeAtIndex:0]; //等同于 firstMatch.range --- 相匹配的范围
            
            //从urlString当中截取数据
            
            NSString *result=[aString substringWithRange:resultRange];
            
            //输出结果
            result =  [result stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSLog(@"result-------%@",result);
            
            
            NSArray *resultArray = [result componentsSeparatedByString:@"value=\""];
            if(resultArray.count>1)
            {
                NSString *string1 = resultArray[1] ;
                NSString *resultString = [string1 componentsSeparatedByString:@"\""][0];
                
                NSLog(@"resultString = %@",resultString);
                return resultString;
            }
            
            
        }
    }
    
    return nil;
}


-(void)requestUserID:(NSString *)VIEWSTATE :(NSString *)VIEWSTATEGENERATOR :(NSString *)EVENTVALIDATION :(NSString *)username :(NSString *)password
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:37.0) Gecko/20100101 Firefox/37.0" forHTTPHeaderField:@"User-Agent"];

     [manager.requestSerializer setValue:@"zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    
    [manager.requestSerializer setValue:@"http://passport.5211game.com/t/Login.aspx?ReturnUrl=http%3a%2f%2fi.5211game.com%2flogin.aspx%3freturnurl%3d%252frating&loginUserName=" forHTTPHeaderField:@"Referer"];
    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    
    

    [manager.requestSerializer setTimeoutInterval:30];
    
    
    NSString *infoURLstring = @"http://passport.5211game.com/t/Login.aspx?ReturnUrl=http%3a%2f%2fi.5211game.com%2flogin.aspx%3freturnurl%3d%252frating&loginUserName=";
    
    NSDictionary *parameters = @{@"__VIEWSTATE":VIEWSTATE,@"__VIEWSTATEGENERATOR":VIEWSTATEGENERATOR,@"__EVENTVALIDATION":EVENTVALIDATION,@"txtUser":username,@"txtPassWord":password,@"butLogin":@"登录"};
    
    NSLog(@"parameters:%@",parameters);
    
    [manager POST:infoURLstring parameters:parameters success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"result: %@", result);
        

        
        NSArray *resultArray = [result componentsSeparatedByString:@"YY.d.u = "];
        
        NSLog(@"resultArray.count = %ld",resultArray.count);
        if (resultArray.count>1) {
            NSString *resultString = [resultArray[1]componentsSeparatedByString:@",YY.d.n"][0];
            NSLog(@"userID:%@",resultString);
            
            [self requestScores:resultString andUserName:username andPassword:password];
            
        }else
        {
            MBProgressHUD *hud = (MBProgressHUD *)[self.view viewWithTag:123];
            [hud hide:YES];
            
            if([result containsString:@"密码错误"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"用户名或密码错误，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"绑定请求出错，请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
    }];


    
}


-(void)requestScores:(NSString *)userID andUserName:(NSString *)username andPassword:(NSString *)password
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30];
    
    NSTimeInterval stamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *infoURLstring = [NSString stringWithFormat:@"http://i.5211game.com/request/rating/?r=%.0f",stamp*1000];
    
    NSDictionary *parameters = @{@"method": @"getrating",@"u":userID,@"t":@"10001"};
    
    [manager POST:infoURLstring parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        NSLog(@"Scores: %@", responseObject);
        

        
        [self submitLevel:responseObject ForUserID:userID ForUserName:username AndPassword:password];

        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            [storage deleteCookie:cookie];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"Scores ERROR: %@",  operation.responseString);

        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            [storage deleteCookie:cookie];
        }
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

        

        
        [self requestExtroInfoWithUser:self.username.text andPassword:self.password.text];
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
        
        
        NSLog(@"JSON: %@", responseObject);
        
        [self.TTscoreDelegate fillTTScore:[[responseObject objectForKey:@"TTinfo"] objectForKey:@"TTscore"]];
        
        NSLog(@"JJCheroFirst: %@", [[responseObject objectForKey:@"JJCinfo"] objectForKey:@"JJCheroFirst"]);
        
        [self performSelector:@selector(backToSelfInfo) withObject:nil afterDelay:2];
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        MBProgressHUD *hud1 = (MBProgressHUD *)[self.view viewWithTag:123];
        if (hud1) {
            [hud1 hide:YES];
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"认证失败，请检查网络.";
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        
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

@end
