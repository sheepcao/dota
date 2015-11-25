//
//  popView.h
//  dotaer
//
//  Created by Eric Cao on 11/23/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface popView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *codeImage;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property(weak,nonatomic) MBProgressHUD *hud;

-(void)roundBack;
-(void)loadingOn:(UIView *)view withDim:(BOOL)dim;
-(void)loadOver;
-(BOOL)isLoading;
@end
