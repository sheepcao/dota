//
//  favorViewController.m
//  dotaer
//
//  Created by Eric Cao on 7/31/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "favorViewController.h"
#import "DataCenter.h"
#import "playerPageViewController.h"
#import "favorTableViewCell.h"
#import "globalVar.h"

@interface favorViewController ()

@property(strong,nonatomic) NSMutableArray *favorArray;
@end

@implementation favorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"关注";

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.favorArray = [[DataCenter sharedDataCenter] fetchFavors];
    
    [self.favorTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark Table view data source


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favorArray.count;
}
// Customize the appearance of table view cells.
- (favorTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    favorTableViewCell *cell =(favorTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"favorCell"];
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"favorTableViewCell" owner:self options:nil] objectAtIndex:0];//加载nib文件
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.backgroundColor = [UIColor clearColor];
    
    cell.usernameLabel.text = self.favorArray[indexPath.row];
    
    NSString *headPath = [imagePath stringByAppendingString:self.favorArray[indexPath.row]];
    
    NSURL *url = [NSURL URLWithString:headPath];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img;
    
    if (data) {
        img = [[UIImage alloc] initWithData:data];
    }else
    {
        img = [UIImage imageNamed:@"defaultHead"];
    }
    
    
    [cell.userHeadImg setImage:img];
    

    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    playerPageViewController *playInfo = [[playerPageViewController alloc] initWithNibName:@"playerPageViewController" bundle:nil];
    
    playInfo.playerName = self.favorArray[indexPath.row];

    playInfo.distance = -1;
    
    [self.navigationController pushViewController:playInfo animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
