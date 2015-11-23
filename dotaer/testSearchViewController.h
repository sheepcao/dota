//
//  testSearchViewController.h
//  dotaer
//
//  Created by Eric Cao on 11/23/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface testSearchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *validCode;
- (IBAction)refreshCode:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
- (IBAction)login:(id)sender;

@end
