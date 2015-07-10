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

@interface loginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet FXBlurView *blurView;

@end


@implementation loginViewController

bool emailOK;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    emailOK = NO;
    // Do any additional setup after loading the view from its nib.
    self.blurView.blurRadius = 7;
    self.roundBack.layer.cornerRadius = 7.5;
    self.loginBtn.layer.cornerRadius = 15.0f;
    self.submitBtn.layer.cornerRadius = 15.0f;
    self.haedBtn.layer.cornerRadius = 65.0f;
    
    
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
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    

    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}



- (IBAction)uploadHead:(UIButton *)sender {
}

- (IBAction)selectSex:(UIButton *)sender {
    [sender setSelected:YES];
    if ([sender isEqual:self.maleBtn]) {
        [self.femaleBtn setSelected:NO];
    }else
    {
        [self.maleBtn setSelected:NO];

    }
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
//        [self.loginPart setHidden:NO];
//        [self.registerView setHidden:YES];
        NSLog(@"loginPart:%@",self.loginPart);
    }
}

- (IBAction)submitRegister:(id)sender {
}
@end
