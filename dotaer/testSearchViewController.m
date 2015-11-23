//
//  testSearchViewController.m
//  dotaer
//
//  Created by Eric Cao on 11/23/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "testSearchViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "globalVar.h"
#import "heroDetailTableViewCell.h"
@interface testSearchViewController ()


@property (nonatomic, strong) NSString *loginURL;

@property (nonatomic, strong) NSString *VIEWSTATEGENERATOR ;
@property (nonatomic, strong) NSString *VIEWSTATE;
@property (nonatomic, strong) NSString *EVENTVALIDATION;
@end

@implementation testSearchViewController
@synthesize loginURL;
@synthesize VIEWSTATEGENERATOR;
@synthesize VIEWSTATE;
@synthesize EVENTVALIDATION;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    

    [self requestExtroInfoWithUser:@"宝贝拼吧"];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)requestExtroInfoWithUser:(NSString *)username
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:37.0) Gecko/20100101 Firefox/37.0" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    [manager.requestSerializer setTimeoutInterval:30];
    
    
    
    NSString *infoURLstring = @"http://score.5211game.com/Ranking/ranking.aspx";
    
    //
    [manager GET:infoURLstring parameters:nil success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
        
        loginURL = [self pickURL:responseObject];

        
        VIEWSTATEGENERATOR = [self pickVIEWSTATEGENERATOR:responseObject];
        VIEWSTATE = [self pickVIEWSTATE:responseObject];
        EVENTVALIDATION = [self pickEVENTVALIDATION:responseObject];
        
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
        
        [self.validCode setImage:aString];
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        
        
    }];
}




-(NSString *)pickVIEWSTATEGENERATOR:(NSData *)responseObject
{
    NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
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



-(NSString *)pickURL:(NSData *)responseObject
{
    NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSError *error2;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"form method=\"post\" action=\"(.+)\"" options:0 error:&error2];
    if (regex != nil) {
        
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:aString options:0 range:NSMakeRange(0, [aString length])];
        
        if (firstMatch) {
            
            NSRange resultRange = [firstMatch rangeAtIndex:0]; //等同于 firstMatch.range --- 相匹配的范围
            
            //从urlString当中截取数据
            
            NSString *result=[aString substringWithRange:resultRange];
            
            //输出结果
            result =  [result stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSLog(@"all-------%@",result);
            
            
            NSArray *resultArray = [result componentsSeparatedByString:@"action=\"."];
            if(resultArray.count>1)
            {
                NSString *string1 = resultArray[1] ;
                NSString *resultString = [string1 componentsSeparatedByString:@"\""][0];
                
                
                resultString =  [resultString stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
                NSLog(@"url = %@",resultString);

                return resultString;
            }
            
            
        }
    }
    
    return nil;
}



-(NSString *)pickVIEWSTATE:(NSData *)responseObject
{
    NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
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


-(NSString *)pickUserID:(NSData *)responseObject
{
    NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSError *error2;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"UserId = \"(.+)\"" options:0 error:&error2];
    if (regex != nil) {
        
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:aString options:0 range:NSMakeRange(0, [aString length])];
        
        if (firstMatch) {
            
            NSRange resultRange = [firstMatch rangeAtIndex:0]; //等同于 firstMatch.range --- 相匹配的范围
            
            //从urlString当中截取数据
            
            NSString *result=[aString substringWithRange:resultRange];
            
            //输出结果
            result =  [result stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSLog(@"result-------%@",result);
            
            
            NSArray *resultArray = [result componentsSeparatedByString:@"=\""];
            if(resultArray.count>1)
            {
                NSString *string1 = resultArray[1] ;
                NSString *resultString = [string1 componentsSeparatedByString:@"\""][0];
                
                NSLog(@"user id = %@",resultString);
                return resultString;
            }
            
            
        }
    }
    
    return nil;
}



-(void)requestUserID:(NSString *)VIEWSTATE :(NSString *)VIEWSTATEGENERATOR :(NSString *)EVENTVALIDATION :(NSString *)username :(NSString *)password :(NSString *)searchName
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
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
    }];
    
    
    
}



- (IBAction)refreshCode:(UIButton *)sender {
    
    [self requestValidationImage];
    
}
- (IBAction)login:(id)sender {
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:37.0) Gecko/20100101 Firefox/37.0" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    [manager.requestSerializer setTimeoutInterval:30];
    
    
    
    NSString *infoURLstring = [NSString stringWithFormat:@"http://passport.5211game.com%@",loginURL];
    
      NSDictionary *parameters = @{@"__VIEWSTATE":VIEWSTATE,@"__VIEWSTATEGENERATOR":VIEWSTATEGENERATOR,@"__EVENTVALIDATION":EVENTVALIDATION,@"txtAccountName":@"宝贝拼吧",@"txtPassWord":@"xuechan99",@"txtValidateCode":self.codeTextField.text,@"ImgButtonLogin.x":@65,@"ImgButtonLogin.y":@13};
    
    [manager POST:infoURLstring parameters:parameters success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
        
        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"login success:%@",aString);
        
        NSString *userID = [self pickUserID:responseObject];
        [self requestScores:userID];
        
        
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
        
        
//        self.AllinfoDic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
//        
//        
//        self.JJCinfoDic = [responseObject objectForKey:@"jjcInfos"];
//        self.TTinfoDic = [responseObject objectForKey:@"ttInfos"];
//        self.MJinfoDic = [responseObject objectForKey:@"mjInfos"];
//        [self.infoTableView reloadData];
        
        
        
        MBProgressHUD *hud =(MBProgressHUD *)[self.view viewWithTag:123];
        
        if (hud) {
            [hud hide:YES afterDelay:0.5];
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



@end
