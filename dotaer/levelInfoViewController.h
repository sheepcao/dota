//
//  levelInfoViewController.h
//  dotaer
//
//  Created by Eric Cao on 7/21/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface levelInfoViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *levelWebview;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipText;

- (IBAction)uploadLevel:(id)sender;
@end
