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

@property (strong, nonatomic) IBOutlet UIView *midView;

@property (strong, nonatomic) IBOutlet UIView *registerView;

@property (weak, nonatomic) IBOutlet UIView *roundBack_R;
- (IBAction)changePage:(id)sender;
@end
