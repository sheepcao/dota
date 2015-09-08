//
//  commentDetailViewController.m
//  dotaer
//
//  Created by Eric Cao on 9/8/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "commentDetailViewController.h"
#import "globalVar.h"

@interface commentDetailViewController ()

@end

@implementation commentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.usernameLabel setText:self.username];
    
    NSString *headPath = [NSString stringWithFormat:@"%@%@.png",imagePath,self.username];
    
    NSURL *url = [NSURL URLWithString:[headPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [self.headIMG setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultHead.png"]];
    [self.likeCountLabel setText:self.likeCount];
    
    [self.commentBody setText:self.commentContent];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)likeTapped:(id)sender {
}

- (IBAction)userButtonTap:(id)sender {
}
@end
