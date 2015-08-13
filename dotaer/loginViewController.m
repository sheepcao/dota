//
//  loginViewController.m
//  dotaer
//
//  Created by Eric Cao on 7/6/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "loginViewController.h"
#import "FXBlurView.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLSessionManager.h"
#import "globalVar.h"
#import "DataCenter.h"
//#import "levelInfoViewController.h"
#import "userAgreementViewController.h"

@interface loginViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet FXBlurView *blurView;

@property (strong,nonatomic) NSString *sexInfo;
@end


@implementation loginViewController

bool emailOK;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DataCenter sharedDataCenter] setIsGuest:NO];

    emailOK = NO;
    self.sexInfo = @"";
    
    // Do any additional setup after loading the view from its nib.
    self.blurView.blurRadius = 3.8;
    self.roundBack.layer.cornerRadius = 7.5;
    self.loginBtn.layer.cornerRadius = 15.0f;
    self.submitBtn.layer.cornerRadius = 15.0f;
    [self disableSubmitBtn];
    [self disableLoginBtn];

    
    self.headImg.layer.cornerRadius = 65.0f;
    self.headImg.layer.masksToBounds = YES;

    [self.midView setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-30)];
    [self.view addSubview:self.midView];
    
    [self.loginPart setCenter:CGPointMake(self.midView.frame.size.width/2, self.midView.frame.size.height/2-50)];
    [self.registerView setCenter:CGPointMake(self.midView.frame.size.width/2, self.midView.frame.size.height/2)];
    
    [self.midView addSubview:self.loginPart];
    
  

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)judgeWordCount:(UITextField *)textField
{
    if (textField.tag ==100) {
        
        
        CGSize textSize = [textField.text sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Thin" size:13.0] }];
        if (textSize.width>=textField.frame.size.width) {
            textField.text = @"";
            NSLog(@"too many words");
            UIAlertView *wordMaxAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"太长了...您的昵称太长了..." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [wordMaxAlert show];
        }
    }else if (textField.tag == 200 )
    {
       
        if ([self validateEmail:textField.text]) {
            emailOK = YES;
        }else
        {
            emailOK = NO;
            if (![textField.text isEqualToString:@""]) {
                UIAlertView *emailAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入正确的email格式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [emailAlert show];
            }
 
        }
    }
        

}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
 
    if (textField == self.passwordField || textField == self.confirmPasswordField) {
        [UIView animateWithDuration:0.45 animations:^{
            
            [self.registerView setCenter:CGPointMake(self.midView.frame.size.width/2, self.midView.frame.size.height/2 - 45)];
        }];
    }else
    {
        [UIView animateWithDuration:0.45 animations:^{
            
            [self.registerView setCenter:CGPointMake(self.midView.frame.size.width/2, self.midView.frame.size.height/2)];
        }];
    }
    
    

    
    return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
   
    
    [self judgeWordCount:textField];
    [self isInfoComplete];
    
    
    if (textField == self.passwordField || textField == self.confirmPasswordField) {
        [UIView animateWithDuration:0.45 animations:^{
            
            [self.registerView setCenter:CGPointMake(self.midView.frame.size.width/2, self.midView.frame.size.height/2)];
        }];
    }
    
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    

    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}



- (IBAction)uploadHead:(UIButton *)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
#pragma mark image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
    

//    UIImageView *imageTemp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    [imageTemp setImage:image];
    
    [self.haedBtn setTitle:@"" forState:UIControlStateNormal];
    [self.headImg setImage:image];
    [self.headUploadTip setHidden:YES];
    
    [picker dismissViewControllerAnimated:YES completion:^{



    }];
}

-(UIImage *)cutImgaeCenter:(UIImageView *)imageview
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(imageview.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(imageview.bounds.size);
    //获取图像
    
    [imageview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (IBAction)selectSex:(UIButton *)sender {
    [sender setSelected:YES];
    if ([sender isEqual:self.maleBtn]) {
        [self.femaleBtn setSelected:NO];
        self.sexInfo = @"male";

    }else
    {
        [self.maleBtn setSelected:NO];
        self.sexInfo = @"female";

    }
    [self isInfoComplete];
}

- (IBAction)changePage:(UIButton *)sender {
    NSLog(@"title:%@",sender.titleLabel.text);
    if ([sender.titleLabel.text isEqualToString:@"前往注册"]) {
        


        [UIView transitionFromView:self.loginPart
                            toView:self.registerView
                          duration:0.8
                           options:UIViewAnimationOptionTransitionFlipFromLeft                        completion:^(BOOL finished){
                          
                               [sender setTitle:@"前往登录" forState:UIControlStateNormal];

                               /* do something on animation completion */
                           }];
//        [self.loginPart setHidden:YES];
//        [self.registerView setHidden:NO];
        NSLog(@"registerView:%@",self.registerView);
        NSLog(@"fatherView:%@",[self.registerView superview]);



    }else
    {

        [UIView transitionFromView:self.registerView
                            toView:self.loginPart
                          duration:0.8
                           options:UIViewAnimationOptionTransitionFlipFromLeft                        completion:^(BOOL finished){
                             
                               [sender setTitle:@"前往注册" forState:UIControlStateNormal];

                               /* do something on animation completion */
                           }];

        NSLog(@"loginPart:%@",self.loginPart);
    }
}
- (IBAction)beGuest:(UIButton *)sender {
    
    NSLog(@"set guest!!!");
    [[DataCenter sharedDataCenter] setIsGuest:YES];
    self.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)enableSubmitBtn
{
    [self.submitBtn setEnabled:YES];
    [self.submitBtn setBackgroundColor:[UIColor colorWithRed:230/255.0f green:196/255.0f blue:19/255.0f alpha:1.0]];

}
-(void)disableSubmitBtn
{
    [self.submitBtn setEnabled:NO];
    [self.submitBtn setBackgroundColor:[UIColor colorWithRed:239/255.0f green:227/255.0f blue:198/255.0f alpha:1.0]];
    
}

-(void)enableLoginBtn
{
    [self.loginBtn setEnabled:YES];
    [self.loginBtn setBackgroundColor:[UIColor colorWithRed:230/255.0f green:196/255.0f blue:19/255.0f alpha:1.0]];
    
}
-(void)disableLoginBtn
{
    [self.loginBtn setEnabled:NO];
    [self.loginBtn setBackgroundColor:[UIColor colorWithRed:239/255.0f green:227/255.0f blue:198/255.0f alpha:1.0]];
    
}


-(void)isInfoComplete
{
    if (![self.usernameField.text isEqualToString:@""] && ![self.ageField.text isEqualToString:@""] && ![self.emailField.text isEqualToString:@""] && ![self.passwordField.text  isEqualToString:@""] && ![self.confirmPasswordField.text  isEqualToString:@""]&& (self.maleBtn.selected || self.femaleBtn.selected)) {
        
        [self enableSubmitBtn];
    }else
    {
        [self disableSubmitBtn];
    }
    
    if (![self.userLoginField.text isEqualToString:@""] && ![self.passwordLoginField.text isEqualToString:@""]) {
        
        [self enableLoginBtn];
    }else
    {
        [self disableLoginBtn];
    }
    
}
-(BOOL)validateInfos
{
    if (![self.confirmPasswordField.text isEqualToString:self.passwordField.text])
    {
        UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"两次输入密码不一致!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [passwordAlert show];
        return false;
    }else if (!emailOK)
    {
        UIAlertView *emailAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入正确的email格式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [emailAlert show];
        
        return false;
    }
    return true;
    
}

- (IBAction)submitRegister:(id)sender {
    
    [self.view endEditing:YES];// this will do the trick

    
    if (![self validateInfos]) {
        return;
    }else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = @"Uploading";
        hud.dimBackground = YES;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        
        NSDictionary *parameters = @{@"tag": @"register",@"name":self.usernameField.text,@"email":self.emailField.text,@"password":self.passwordField.text,@"age":self.ageField.text,@"sex":self.sexInfo};
        
  
        //upload head image
        UIImage *image = self.headImg.image;
        
        UIImage *lowImg = [[DataCenter sharedDataCenter] compressImage:image];
        NSData *imageData = UIImageJPEGRepresentation(lowImg, 0.5);

        AFHTTPRequestOperationManager *manager2 = [AFHTTPRequestOperationManager manager];
        [manager2 setRequestSerializer:[AFHTTPRequestSerializer serializer]];
        [manager2.requestSerializer setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
        manager2.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [manager2.requestSerializer setTimeoutInterval:30];  //Time out after 25 seconds


        
        AFHTTPRequestOperation *op = [manager2 POST:registerService parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            if (imageData) {
                NSString *fileName = [NSString stringWithFormat:@"%@.png",self.usernameField.text];
                
                [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
            }

            
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"Completed";
            [hud hide:YES afterDelay:1.0];
            
            [self performSelector:@selector(successLogin:) withObject:responseObject afterDelay:1.01];

            [[DataCenter sharedDataCenter] setNeedConfirmLevelInfo:YES];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"Error";
            [hud hide:YES afterDelay:1.5];
            
            NSLog(@"Error: %@ ***** %@", operation.responseString, error);
            if ([operation.responseString containsString:@"User already existed"]) {
                UIAlertView *userNameAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"您输入的用户名已存在，换一个吧" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [userNameAlert show];
            }else
            {
                UIAlertView *registerFailedAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"注册失败，请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [registerFailedAlert show];
            }
            
        }];
        
        
        [op setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                            long long totalBytesWritten,
                                            long long totalBytesExpectedToWrite) {

           
            hud.progress = totalBytesWritten/totalBytesExpectedToWrite;
      
            NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
        }];
        
        [op start];
        
        
        
        
    }

}

- (IBAction)userAgreement:(id)sender {
    
    userAgreementViewController *userAgree = [[userAgreementViewController alloc] initWithNibName:@"userAgreementViewController" bundle:nil];
    [self presentViewController:userAgree animated:YES completion:nil];
    
    
}
- (IBAction)userLogin:(UIButton *)sender {
    
    [self.view endEditing:YES];// this will do the trick

    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Sending";
    hud.dimBackground = YES;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    NSDictionary *parameters = @{@"tag": @"login",@"name":self.userLoginField.text,@"password":self.passwordLoginField.text};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30];  //Time out after 25 seconds

    
    [manager POST:registerService parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"登录成功";
        

        [hud hide:YES afterDelay:1.0];
        [self performSelector:@selector(successLogin:) withObject:responseObject afterDelay:1.01];
        
        
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"Error";
        [hud hide:YES afterDelay:1.5];
        
        
        if ([operation.responseString containsString:@"Incorrect username or password!"]) {
            UIAlertView *userNameAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"您输入的用户名或密码有误，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [userNameAlert show];
        }else
        {
            UIAlertView *registerFailedAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"登录失败，请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [registerFailedAlert show];
        }

        
        
    }];
    
    
    
    
    
    
}

-(void)successLogin:(NSDictionary *)userInfoDic
{
    
    [[DataCenter sharedDataCenter] setIsGuest:NO];

    NSString *isReviewed = @"yes";
    NSString *TTscore = [userInfoDic objectForKey:@"TTscore"];

    NSLog(@"userinfoDic:%@",userInfoDic);
    NSLog(@"age:%@",[userInfoDic objectForKey:@"age"]);
    if ([[userInfoDic objectForKey:@"isReviewed"] isKindOfClass:[NSNull class]] || [[userInfoDic objectForKey:@"isReviewed"] isEqualToString:@"no"]) {
        isReviewed = @"no";
        TTscore = @"0";
    }
    
    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [userInfoDic objectForKey:@"username"],@"username",
                             [userInfoDic objectForKey:@"age"],@"age",
                             [userInfoDic objectForKey:@"email"],@"email",
                             [userInfoDic objectForKey:@"sex"],@"sex",
                             isReviewed,@"isReviewed",
                             TTscore,@"TTscore",
                             [userInfoDic objectForKey:@"created"],@"created",
                             nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:@"userInfoDic"];
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"haveDefaultUser"];

    self.modalTransitionStyle   = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];

}


@end
