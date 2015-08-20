//
//  VideoListViewController.m
//  dotaer
//
//  Created by Eric Cao on 8/19/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "VideoListViewController.h"
#import "videoTableViewCell.h"
@interface VideoListViewController ()

@property (nonatomic ,strong) NSArray *publisherArray;
@end

@implementation VideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = @"解说列表";
    
    self.publisherArray = @[@"123",@"222"];
    
    UIVisualEffect *blurEffect_b;
    blurEffect_b = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView_b;
    visualEffectView_b = [[UIVisualEffectView alloc] initWithEffect:blurEffect_b];
    
    visualEffectView_b.frame =CGRectMake(0, 0, self.backIMG.frame.size.width, self.backIMG.frame.size.height) ;
    [self.backIMG addSubview:visualEffectView_b];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Table view data source


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.publisherArray.count;
}
// Customize the appearance of table view cells.
- (videoTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    videoTableViewCell *cell =(videoTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"publisherCell"];
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"videoTableViewCell" owner:self options:nil] objectAtIndex:0];//加载nib文件
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.backgroundColor = [UIColor clearColor];
    
//    cell.title.text = self.favorArray[indexPath.row];
//    
//    NSString *headPath = [NSString stringWithFormat:@"%@%@.png",imagePath,self.favorArray[indexPath.row]];
//    
//    
//    
//    NSURL *url = [NSURL URLWithString:[headPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    
//    [cell.userHeadImg setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultHead.png"]];
//    
    //    NSData *data = [NSData dataWithContentsOfURL:url];
    //    UIImage *img;
    //
    //    if (data) {
    //        img = [[UIImage alloc] initWithData:data];
    //    }else
    //    {
    //        img = [UIImage imageNamed:@"defaultHead"];
    //    }
    //
    //
    //    [cell.userHeadImg setImage:img];
    
    
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    if(self.isFromFavor)
//    {
//        
//        playerPageViewController *playInfo = [[playerPageViewController alloc] initWithNibName:@"playerPageViewController" bundle:nil];
//        
//        playInfo.playerName = self.favorArray[indexPath.row];
//        
//        playInfo.distance = -1;
//        
//        [self.navigationController pushViewController:playInfo animated:YES];
//        
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    }else
//    {
////        [self jumpToPlayer: self.favorArray[indexPath.row] andDistance:self.distance andGeoInfo:self.userPosition];
//    }
}

//-(void)jumpToPlayer:(NSString *)playerName andDistance:(NSUInteger)distance andGeoInfo:(CLLocationCoordinate2D)position
//{
//    playerPageViewController *playInfo = [[playerPageViewController alloc] initWithNibName:@"playerPageViewController" bundle:nil];
//    
//    playInfo.playerName = playerName;
//    playInfo.distance = distance;
//    playInfo.userPosition = position;
//    
//    [self.navigationController pushViewController:playInfo animated:YES];
//    
//    
//}


@end
