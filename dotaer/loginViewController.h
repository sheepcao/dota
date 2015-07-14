//
//  loginViewController.h
//  dotaer
//
//  Created by Eric Cao on 7/6/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *loginPart;
@property (weak, nonatomic) IBOutlet UIView *roundBack;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *userLoginField;
@property (weak, nonatomic) IBOutlet UITextField *passwordLoginField;
- (IBAction)userLogin:(UIButton *)sender;




@property (strong, nonatomic) IBOutlet UIView *midView;




@property (strong, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *ageField;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;
@property (weak, nonatomic) IBOutlet UIButton *haedBtn;
@property (weak, nonatomic) IBOutlet UILabel *headUploadTip;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

- (IBAction)uploadHead:(UIButton *)sender;
- (IBAction)selectSex:(UIButton *)sender;


- (IBAction)changePage:(id)sender;
- (IBAction)submitRegister:(id)sender;


@end
