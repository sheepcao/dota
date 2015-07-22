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

@interface levelInfoViewController ()<UIAlertViewDelegate>

@end

@implementation levelInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"实力认证";
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://passport.5211game.com/t/Login.aspx?ReturnUrl=http%3a%2f%2fi.5211game.com%2flogin.aspx%3freturnurl%3d%252frating&loginUserName="]];
    [self.levelWebview loadRequest:request];
    self.levelWebview.delegate = self;
    self.levelWebview.scalesPageToFit = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
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
       
        [self.uploadBtn setTag:10];
    }else
    {
        [self.uploadBtn setTag:11];

    }
    
    

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
- (IBAction)uploadLevel:(UIButton *)sender {
    
    if (sender.tag == 10) {
        UIAlertView *notAllowAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未登录，无法上传战绩." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [notAllowAlert show];
    }else if (sender.tag == 11)
    {
        NSLog(@"upload tap!!!");
        UIImage *levelImage = [self getImageFromView:self.levelWebview];

        [self doUpload:levelImage];
    }
}

-(void)doUpload:(UIImage *)levelImage
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Uploading";
    hud.dimBackground = YES;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    NSString *username = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"userInfoDic"] objectForKey:@"username"];

    
    NSDictionary *parameters = @{@"tag": @"uploadLevel",@"username":username};
    
    
    //upload head image
    UIImage *image = levelImage;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    
    AFHTTPRequestOperation *op = [manager POST:registerService parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        

        
        NSString *fileName = [NSString stringWithFormat:@"%@_result.png",username];
        
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"Completed";
        [hud hide:YES afterDelay:1.0];
        
        [self performSelector:@selector(successUploadAlert) withObject:nil afterDelay:1.1];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"Error";
        [hud hide:YES afterDelay:1.5];
        
        NSLog(@"Error: %@ ***** %@", operation.responseString, error.localizedDescription);

            UIAlertView *registerFailedAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"上传失败，请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [registerFailedAlert show];
        
        
    }];
    
    
    [op setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                 long long totalBytesWritten,
                                 long long totalBytesExpectedToWrite) {
        
        
        hud.progress = totalBytesWritten/totalBytesExpectedToWrite;
        
        NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    [op start];

}

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
