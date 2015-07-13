//
//  loginViewController.m
//  dotaer
//
//  Created by Eric Cao on 7/6/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "loginViewController.h"
#import "FXBlurView.h"
#import "globalVar.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLSessionManager.h"

@interface loginViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet FXBlurView *blurView;

@property (strong,nonatomic) NSString *sexInfo;
@end


@implementation loginViewController

bool emailOK;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    emailOK = NO;
    self.sexInfo = @"";
    
    // Do any additional setup after loading the view from its nib.
    self.blurView.blurRadius = 7;
    self.roundBack.layer.cornerRadius = 7.5;
    self.loginBtn.layer.cornerRadius = 15.0f;
    self.submitBtn.layer.cornerRadius = 15.0f;
    [self disableSubmitBtn];

    
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
            UIAlertView *emailAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入正确的email格式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [emailAlert show];
        }
    }
        

}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
   
    
    [self judgeWordCount:textField];
    [self isInfoComplete];
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
    

    [self.haedBtn setTitle:@"" forState:UIControlStateNormal];
    [self.headImg setImage:image];
    [self.headUploadTip setHidden:YES];
    
    [picker dismissViewControllerAnimated:YES completion:^{



    }];
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
    if ([sender.titleLabel.text isEqualToString:@"注册"]) {
        


        [UIView transitionFromView:self.loginPart
                            toView:self.registerView
                          duration:0.8
                           options:UIViewAnimationOptionTransitionFlipFromLeft                        completion:^(BOOL finished){
                          
                               [sender setTitle:@"登录" forState:UIControlStateNormal];

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
                             
                               [sender setTitle:@"注册" forState:UIControlStateNormal];

                               /* do something on animation completion */
                           }];

        NSLog(@"loginPart:%@",self.loginPart);
    }
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

-(void)isInfoComplete
{
    if (![self.usernameField.text isEqualToString:@""] && ![self.ageField.text isEqualToString:@""] && ![self.emailField.text isEqualToString:@""] && ![self.passwordField.text  isEqualToString:@""] && ![self.confirmPasswordField.text  isEqualToString:@""]&& (self.maleBtn.selected || self.femaleBtn.selected)) {
        
        [self enableSubmitBtn];
    }else
    {
        [self disableSubmitBtn];
    }
    
}
-(BOOL)validateInfos
{
    if (![self.confirmPasswordField.text isEqualToString:self.passwordField.text])
    {
        UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"两次输入密码不一致!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [passwordAlert show];
        return false;
    }
    return true;
    
}

- (IBAction)submitRegister:(id)sender {
    
    if (![self validateInfos]) {
        return;
    }else
    {
        
        NSDictionary *parameters = @{@"tag": @"register",@"name":self.usernameField.text,@"email":self.emailField.text,@"password":self.passwordField.text,@"age":self.ageField.text,@"sex":self.sexInfo};
        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
//        
//        
//        [manager POST:@"http://localhost/~ericcao/index_withPOST.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            NSLog(@"JSON: %@", responseObject);
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
//            NSLog(@"JSON ERROR: %@",  operation.responseString);
//            
//            if ([operation.responseString containsString:@"User already existed"]) {
//                UIAlertView *userNameAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"您输入的用户名已存在，换一个吧" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [userNameAlert show];
//            }else
//            {
//                UIAlertView *registerFailedAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"注册失败，请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [registerFailedAlert show];
//            }
//            
//        }];
//        
//        
        //upload head image
        UIImage *image = self.headImg.image;
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);

        
        AFHTTPRequestOperationManager *manager2 = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost"]];
        [manager2 setRequestSerializer:[AFHTTPRequestSerializer serializer]];
        [manager2.requestSerializer setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
        manager2.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

        
        AFHTTPRequestOperation *op = [manager2 POST:registerService parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSString *fileName = [NSString stringWithFormat:@"%@.png",self.usernameField.text];
            
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
            
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
        
        [op start];
        
        
        
    }

}
@end
