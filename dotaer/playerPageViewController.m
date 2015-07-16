//
//  playerPageViewController.m
//  dotaer
//
//  Created by Eric Cao on 7/16/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "playerPageViewController.h"
#import "globalVar.h"
@interface playerPageViewController ()

@end

@implementation playerPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.mainScroll.backgroundColor = [UIColor redColor];
    
    [self.mainScroll setContentSize:CGSizeMake(SCREEN_WIDTH, 700)];
    [self.infoView setFrame:CGRectMake((SCREEN_WIDTH-320)/2, 64, 320, 200)];

    
    [self.view addSubview:self.mainScroll];
    [self.mainScroll addSubview: self.infoView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
