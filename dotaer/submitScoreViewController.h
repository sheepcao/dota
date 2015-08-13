//
//  submitScoreViewController.h
//  dotaer
//
//  Created by Eric Cao on 8/12/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

@protocol setTTscoreDelegate <NSObject>

-(void)fillTTScore:(NSString *)score;

@end

@interface submitScoreViewController : UIViewController
@property (weak, nonatomic) IBOutlet FXBlurView *blurBack;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIView *roundBack;
@property (weak, nonatomic) id <setTTscoreDelegate> TTscoreDelegate;

- (IBAction)submit:(id)sender;
- (IBAction)cancel:(id)sender;

-(void)requestExtroInfoWithUser:(NSString *)username andPassword:(NSString *)password;
@end
