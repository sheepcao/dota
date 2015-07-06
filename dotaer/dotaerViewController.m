//
//  ViewController.m
//  dotaer
//
//  Created by Eric Cao on 7/6/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "dotaerViewController.h"
#import "IIViewDeckController.h"
#import "loginViewController.h"
#import <BaiduMapAPI/BMapKit.h>

@interface dotaerViewController ()<IIViewDeckControllerDelegate,BMKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>


@property (strong,nonatomic) UITableView *listView;
@property (strong,nonatomic) BMKMapView *mapView;

@end

@implementation dotaerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.viewDeckController.delegate = self;
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
    self.viewDeckController.openSlideAnimationDuration = 0.28f; // In seconds
    self.viewDeckController.closeSlideAnimationDuration = 0.12f;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 68, 375, 538)];

    [self.view addSubview:containerView];

    
    self.listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)];
    self.listView.delegate = self;
    self.listView.dataSource = self;
    self.listView.backgroundColor = [UIColor whiteColor];
    
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)];
    self.mapView.backgroundColor = [UIColor whiteColor];


//    UIButton * mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 150, 150)];
//    [mapBtn setTitle:@"mapya" forState:UIControlStateNormal];
//    [mapBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.mapView addSubview:mapBtn];
//
//    UIButton * listBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 150, 150)];
//    [listBtn setTitle:@"list" forState:UIControlStateNormal];
//    [self.listView addSubview:listBtn];
    [containerView addSubview:self.listView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:self.viewDeckController action:@selector(toggleLeftView)];
    
    self.navigationItem.title = @"附近";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"地图" style:UIBarButtonItemStylePlain target:self action:@selector(mapTapped:)];


    
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

-(void)mapTapped:(UINavigationItem *)sender
{
    if ([sender.title isEqualToString:@"地图"]) {
        [sender setTitle:@"列表"];
//        [CATransaction flush];

        [UIView transitionFromView:self.listView
                            toView:self.mapView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft                        completion:^(BOOL finished){
                            /* do something on animation completion */
                        }];
    

    }else
    {
        [sender setTitle:@"地图"];

//        [CATransaction flush];

        [UIView transitionFromView:self.mapView
                            toView:self.listView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished){
                            /* do something on animation completion */
                        }];
    }
    NSLog(@"map tapped!");
}


#pragma 抽屉代理方法.
- (void)viewDeckController:(IIViewDeckController *)viewDeckController applyShadow:(CALayer *)shadowLayer withBounds:(CGRect)rect {
    shadowLayer.masksToBounds = NO;
    shadowLayer.shadowRadius = 5;
    shadowLayer.shadowOpacity = 0.9;
    shadowLayer.shadowColor = [[UIColor blackColor] CGColor];
    shadowLayer.shadowOffset = CGSizeZero;
    shadowLayer.shadowPath = [[UIBezierPath bezierPathWithRect:rect] CGPath];
}

-(void)viewDeckController:(IIViewDeckController *)viewDeckController didCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    self.viewDeckController.panningMode = IIViewDeckNoPanning;

}

-(void)viewDeckController:(IIViewDeckController *)viewDeckController didOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark Table view data source


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nearbyCell"];
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"listCell" owner:self options:nil] lastObject];//加载nib文件
    }
    cell.backgroundColor = [UIColor clearColor];

    
//    cell.textLabel.text = [_demoNameArray objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UIViewController* viewController = nil;
//    if (indexPath.row < 18) {
//        viewController = [[NSClassFromString([_viewControllerArray objectAtIndex:indexPath.row]) alloc] init];
//    } else {
//        viewController = [[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil] instantiateViewControllerWithIdentifier:[_viewControllerArray objectAtIndex:indexPath.row]];
//    }
//    viewController.title = [_viewControllerTitleArray objectAtIndex:indexPath.row];
//    UIBarButtonItem *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
//    customLeftBarButtonItem.title = @"返回";
//    self.navigationItem.backBarButtonItem = customLeftBarButtonItem;
//    [self.navigationController pushViewController:viewController animated:YES];
}

@end
