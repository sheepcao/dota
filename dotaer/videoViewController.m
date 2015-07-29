//
//  videoViewController.m
//  dotaer
//
//  Created by Eric Cao on 7/28/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "videoViewController.h"
#import "videoTableViewCell.h"
#import "playVideoViewController.h"
@interface videoViewController ()

@end

@implementation videoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - UITableViewDataSource




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    videoTableViewCell *cell =(videoTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"vedioCell"];
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"videoTableViewCell" owner:self options:nil] objectAtIndex:0];//加载nib文件
    }
    
    [cell.videoBtn addTarget:self action:@selector(videoTap:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;


}

-(void)videoTap:(videoButton *)btn
{
    NSLog(@"video tap...");
    playVideoViewController *playVideo = [[playVideoViewController alloc] initWithNibName:@"playVideoViewController" bundle:nil];
    [self presentViewController:playVideo animated:YES completion:nil];

    
}
#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
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
