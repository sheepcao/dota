//
//  searchHomeViewController.h
//  dotaer
//
//  Created by Eric Cao on 9/14/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchHomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *keywordField;
- (IBAction)search;

@end
