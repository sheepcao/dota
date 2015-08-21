//
//  passwordViewController.h
//  dotaer
//
//  Created by Eric Cao on 8/20/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface passwordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backIMG;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswrod;
@property (weak, nonatomic) IBOutlet UITextField *aNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *confirmNewPassword;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)submit:(id)sender;

@end
