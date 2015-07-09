//
//  loginViewController.m
//  dotaer
//
//  Created by Eric Cao on 7/6/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "loginViewController.h"
#import "FXBlurView.h"

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

@end
