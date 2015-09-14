//
//  passwordViewController.m
//  dotaer
//
//  Created by Eric Cao on 8/20/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "passwordViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "globalVar.h"

@interface passwordViewController ()

@end

@implementation passwordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改密码";
    UIVisualEffect *blurEffect_b;
    blurEffect_b = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView_b;
    visualEffectView_b = [[UIVisualEffectView alloc] initWithEffect:blurEffect_b];
    
    visualEffectView_b.frame =CGRectMake(0, 0, self.backIMG.frame.size.width, self.backIMG.frame.size.height) ;
    [self.backIMG addSubview:visualEffectView_b];
    
    
    self.submitBtn.layer.cornerRadius = 10.0f;
    self.submitBtn.layer.borderWidth = 0.7f;
    self.submitBtn.layer.borderColor = [UIColor colorWithRed:138/255.0f green:211/255.0f blue:221/255.0f alpha:1.0f].CGColor;
    
    [self.submitBtn setTitleColor:[UIColor colorWithRed:138/255.0f green:211/255.0f blue:221/255.0f alpha:1.0f] forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)submit:(id)sender {
    
    [self.view endEditing:YES];// this will do the trick
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoDic"];

    if (![self.oldPasswrod.text isEqualToString:[userDic objectForKey:@"password"]]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"旧密码输入有误";
        [hud hide:YES afterDelay:1.5];
        return;

    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Sending";
    hud.dimBackground = YES;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];

    NSDictionary *parameters = @{@"tag": @"changePassword",@"name":[userDic objectForKey:@"username"],@"password":self.aNewPassword.text};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30];  //Time out after 25 seconds
    
    
    [manager POST:registerService parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"密码修改成功";
        
        
        [hud hide:YES afterDelay:1.0];
        
        [self performSelector:@selector(backToSelfInfo) withObject:nil afterDelay:1.3];

        
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"密码修改错误";
        [hud hide:YES afterDelay:1.5];
        
        [self performSelector:@selector(backToSelfInfo) withObject:nil afterDelay:1.8];

        
    }];
    
    

}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}
-(void)backToSelfInfo
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotate {
    return NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; // your own style
}

- (BOOL)prefersStatusBarHidden {
    return NO; // your own visibility code
}

@end
