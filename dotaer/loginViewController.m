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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.blurView.blurRadius = 7;
    self.roundBack.layer.cornerRadius = 7.5;
    self.roundBack_R.layer.cornerRadius = 7.5;

    self.loginBtn.layer.cornerRadius = 15.0f;
    
    
    
    [self.midView setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-30)];
    [self.view addSubview:self.midView];
    
    [self.loginPart setCenter:CGPointMake(self.midView.center.x, self.midView.center.y-50)];
    [self.registerView setCenter:self.midView.center];

    [self.midView addSubview:self.loginPart];
    
  

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)judgeWordCount:(UITextField *)textField
{
    CGSize textSize = [textField.text sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Thin" size:13.0] }];
    if (textSize.width>=textField.frame.size.width) {
        textField.text = @"";
        NSLog(@"too many words");
        UIAlertView *wordMaxAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"太长了...您的昵称太长了..." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [wordMaxAlert show];
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
   
    
    [self judgeWordCount:textField];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self judgeWordCount:textField];

    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
@end
