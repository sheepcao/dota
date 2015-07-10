//
//  ViewController.m
//  dotaer
//
//  Created by Eric Cao on 7/6/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "dotaerViewController.h"
#import "loginViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "MFSideMenu.h"
#import "listCellTableViewCell.h"

@interface dotaerViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate, BMKRadarManagerDelegate> {
    BMKLocationService *_locServer;
    BMKRadarManager *_radarManager;
    CLLocationCoordinate2D _curLocation;
    CLLocationCoordinate2D _myCoor;

    BOOL isAutoUploading;
    NSLock *lock;
}


@property (strong,nonatomic) UITableView *listView;
@property (strong,nonatomic) BMKMapView *mapView;

@property (nonatomic, strong) NSMutableArray *nearbyInfos;
@property (nonatomic) NSInteger curPageIndex;
@end

@implementation dotaerViewController

@synthesize nearbyInfos = _nearbyInfos;
@synthesize curPageIndex = _curPageIndex;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoginPage];

    if(!self.title) self.title = @"附近";
    
    UINib *nib = [UINib nibWithNibName:@"listCell" bundle:nil];
    [self.listView registerNib:nib forCellReuseIdentifier:@"listCell"];
    
    [self setupMenuBarButtonItems];
    [self setupcCenterView];
    
    
}


-(void)showLoginPage
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultUser"])  {
        
    }else
    {
        loginViewController *demoController = [[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
        
        [self presentViewController:demoController animated:YES completion:nil];
    }
}

-(void)setupcCenterView
{
        NSLog(@"nav:%f,%f",self.navigationController.navigationBar.frame.size.height,self.navigationController.navigationBar.frame.origin.y);
    
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0.8*SCREEN_HEIGHT)];
    
        [self.view addSubview:containerView];
    
    
        self.listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)];
        self.listView.delegate = self;
        self.listView.dataSource = self;
       self.listView.rowHeight = 60;
//        self.listView.backgroundColor = [UIColor whiteColor];
        _nearbyInfos = [NSMutableArray array];

    
    
        self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)];
        self.mapView.backgroundColor = [UIColor whiteColor];
    
    
        [containerView addSubview:self.listView];
    
    
        UIView *searchingBar = [[UIView alloc] initWithFrame:CGRectMake(0,  containerView.frame.size.height+containerView.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT - containerView.frame.size.height - containerView.frame.origin.y)];
    
        searchingBar.backgroundColor = [UIColor lightGrayColor];
    
        [self.view addSubview:searchingBar];
    
        UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(searchingBar.frame.size.width-searchingBar.frame.size.height, searchingBar.frame.size.height/8, searchingBar.frame.size.height*3/4, searchingBar.frame.size.height*3/4)];
    
        [searchBtn setTitle:@"查" forState:UIControlStateNormal];
        [searchBtn setBackgroundColor:[UIColor purpleColor]];
        [searchBtn addTarget:self action:@selector(searchDotaer) forControlEvents:UIControlEventTouchUpInside];
        [searchingBar addSubview:searchBtn];
    
    
    
    
        [self uploadLocation];
        BOOL res = [_radarManager uploadInfoRequest:[self getCurrInfo]];
        if (res) {
            NSLog(@"upload 成功");
        } else {
            NSLog(@"upload 失败");
        }
    
    
        

}


#pragma mark -
#pragma mark - UIBarButtonItems

- (void)setupMenuBarButtonItems {
    
    self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
    if(self.menuContainerViewController.menuState == MFSideMenuStateClosed &&
       ![[[self.navigationController viewControllers] objectAtIndex:0] isEqual:self]) {
        self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
    } else {
        self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
    }
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuStateEventOccurred:)
                                                 name:MFSideMenuStateNotificationEvent
                                               object:nil];
    
    [self.menuContainerViewController setMenuWidth:200];
 

}

- (void)menuStateEventOccurred:(NSNotification *)notification {
    
    NSLog(@"eventType:%@",[[notification userInfo] objectForKey:@"eventType"]);
    

    if ([[[notification userInfo] objectForKey:@"eventType"] intValue] == MFSideMenuStateEventMenuDidClose) {
        self.menuContainerViewController.panMode = MFSideMenuPanModeNone ;

    }else if([[[notification userInfo] objectForKey:@"eventType"] intValue] == MFSideMenuStateEventMenuDidOpen)
    {
        self.menuContainerViewController.panMode = MFSideMenuPanModeDefault ;

    }
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    return [[UIBarButtonItem alloc] initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:self action:@selector(leftSideMenuButtonPressed:)];

}

- (UIBarButtonItem *)rightMenuBarButtonItem {
    return [[UIBarButtonItem alloc] initWithTitle:@"地图" style:UIBarButtonItemStylePlain target:self action:@selector(mapTapped:)];
    

}

- (UIBarButtonItem *)backBarButtonItem {
    return [[UIBarButtonItem alloc] initWithTitle:@"收回"
                                            style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(backButtonPressed:)];
}


#pragma mark -
#pragma mark - UIBarButtonItem Callbacks

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        [self setupMenuBarButtonItems];
    }];
}

- (void)rightSideMenuButtonPressed:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
        [self setupMenuBarButtonItems];
    }];
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [_mapView viewWillAppear];
    [_radarManager addRadarManagerDelegate:self];//添加radar delegate

    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [_mapView viewWillDisappear];
    [_radarManager removeRadarManagerDelegate:self];//不用需移除，否则影响内存释放
    _mapView.delegate = nil; // 不用时，置nil
}

-(void)uploadLocation
{
    _radarManager = [BMKRadarManager getRadarManagerInstance];
    _locServer = [[BMKLocationService alloc] init];
    _locServer.delegate = self;
    [_locServer startUserLocationService];
    
    [_radarManager startAutoUpload:10];

}

-(void)mapTapped:(UINavigationItem *)sender
{
    if ([sender.title isEqualToString:@"地图"]) {
        [sender setTitle:@"列表"];
//        [CATransaction flush];

        [UIView transitionFromView:self.listView
                            toView:self.mapView
                          duration:0.8
                           options:UIViewAnimationOptionTransitionFlipFromLeft                        completion:^(BOOL finished){
                            /* do something on animation completion */
                        }];
        [_mapView setCenterCoordinate:_myCoor];
        [_mapView setZoomLevel:5.5];

    }else
    {
        [sender setTitle:@"地图"];

//        [CATransaction flush];

        [UIView transitionFromView:self.mapView
                            toView:self.listView
                          duration:0.8
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:^(BOOL finished){
                            /* do something on animation completion */
                        }];
    }
    NSLog(@"map tapped!");
}

///更新缓存附近信息数据并刷新地图显示
- (void)setNearbyInfos:(NSMutableArray *)nearbyInfos {
    [_nearbyInfos removeAllObjects];
    [_nearbyInfos addObjectsFromArray:nearbyInfos];
    [self.listView reloadData];
    [_mapView removeAnnotations:_mapView.annotations];
    NSMutableArray *annotations = [NSMutableArray array];
    for (BMKRadarNearbyInfo *info in _nearbyInfos) {
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        annotation.coordinate = info.pt;
        annotation.title = info.userId;
        annotation.subtitle = info.extInfo;
        [annotations addObject:annotation];
    }
    [_mapView addAnnotations:annotations];
    [_mapView showAnnotations:annotations animated:YES];
}
-(void)searchDotaer
{
    [self nearbySearchWithPageIndex:1];

}

- (void)nearbySearchWithPageIndex:(NSInteger) pageIndex {
    BMKRadarNearbySearchOption *option = [[BMKRadarNearbySearchOption alloc] init]
    ;
    option.radius = 80000000000000000;
    option.sortType = BMK_RADAR_SORT_TYPE_DISTANCE_FROM_NEAR_TO_FAR;
    option.centerPt = _myCoor;
//    option.centerPt = CLLocationCoordinate2DMake(39.916, 116.404);
    option.pageIndex = pageIndex;
    //    option.pageCapacity = 2;
    //    NSDate *eDate = [NSDate date];
    //    //    eDate = [NSDate dateWithTimeInterval:-3600 * 3 sinceDate:eDate];
    //    NSDate *date = [NSDate dateWithTimeInterval:-3600 * 4 sinceDate:eDate];
    //    BMKDateRange *dateRange = [[BMKDateRange alloc] init];
    //    dateRange.startDate = date;
    //    dateRange.endDate = eDate;
    //    NSLog(@"%@ ,  %@", date, eDate);
    //    option.dateRange = dateRange;
    
    BOOL res = [_radarManager getRadarNearbySearchRequest:option];
    if (res) {
        NSLog(@"get 成功");
    } else {
        NSLog(@"get 失败");
    }
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)updateMyLocation:(BMKUserLocation *) loc {
    BMKUserLocation *location = loc;
    _myCoor = location.location.coordinate;
    [_mapView updateLocationData:location];

    
}

#pragma mark -
#pragma mark Table view data source


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _nearbyInfos.count;
}
// Customize the appearance of table view cells.
- (listCellTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    listCellTableViewCell *cell =(listCellTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"listCell" owner:self options:nil] objectAtIndex:0];//加载nib文件
    }
    cell.backgroundColor = [UIColor clearColor];

    BMKRadarNearbyInfo *info = [_nearbyInfos objectAtIndex:indexPath.row];
    cell.userInfo.text = info.userId;
    cell.userDistance.text = [NSString stringWithFormat:@"%d米   %@", (int)info.distance, info.extInfo];
    
    
    

    return cell;
}

//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"BaiduMapRadarDemoCell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
//    BMKRadarNearbyInfo *info = [_nearbyInfos objectAtIndex:indexPath.row];
//    cell.textLabel.text = info.userId;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d米   %@", (int)info.distance, info.extInfo];
//    return cell;
//}
#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
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

- (BMKRadarUploadInfo *)getCurrInfo {
    BMKRadarUploadInfo *info = [[BMKRadarUploadInfo alloc] init];

    int random = arc4random()%1000;
    _radarManager.userId =[NSString stringWithFormat:@"dotaer%d",random];

    info.extInfo = @"hello dota";
    [lock lock];
//    info.pt = CLLocationCoordinate2DMake(39.916, 116.404);//我的地理坐标

    info.pt = _curLocation;
    [lock unlock];
    return info;
}

#pragma mark - BMKRadarManagerDelegate

/*
 *开启自动上传，需实现该回调
 */
- (BMKRadarUploadInfo *)getRadarAutoUploadInfo {
    return [self getCurrInfo];
}

/**
 *返回雷达 上传结果
 *@param error 错误号，@see BMKRadarErrorCode
 */
- (void)onGetRadarUploadResult:(BMKRadarErrorCode) error {
    NSLog(@"onGetRadarUploadResult  %d", error);
    if (error == BMK_RADAR_NO_ERROR) {
        NSLog(@"成功上传我的位置");

    }
}

/**
 *返回雷达 清除我的信息结果
 *@param error 错误号，@see BMKRadarErrorCode
 */
- (void)onGetRadarClearMyInfoResult:(BMKRadarErrorCode) error {
    NSLog(@"onGetRadarClearMyInfoResult  %d", error);
    if (error == BMK_RADAR_NO_ERROR) {
        NSLog(@"成功清除我的位置");
    }
}

#pragma mark - BMKLocationServiceDelegate

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self updateMyLocation:userLocation];
    [lock lock];
    _curLocation.latitude = userLocation.location.coordinate.latitude;
    _curLocation.longitude = userLocation.location.coordinate.longitude;
    [lock unlock];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

#pragma mark - BMKRadarManagerDelegate
/**
 *返回雷达 查询周边的用户信息结果
 *@param result 结果，类型为@see BMKRadarNearbyResult
 *@param error 错误号，@see BMKRadarErrorCode
 */
- (void)onGetRadarNearbySearchResult:(BMKRadarNearbyResult *)result error:(BMKRadarErrorCode)error {
    NSLog(@"onGetRadarNearbySearchResult  %d", error);
    if (error == BMK_RADAR_NO_ERROR) {
        NSLog(@"result.infoList.count:  %d", (int)result.infoList.count);
        self.nearbyInfos = (NSMutableArray *)result.infoList;
        _curPageIndex = result.pageIndex;
//        _curPageLabel.text = [NSString stringWithFormat:@"%d", (int)_curPageIndex + 1];
//        _nextButton.enabled = (_curPageIndex + 1 != result.pageNum);
//        _preButton.enabled = _curPageIndex != 0;
    }
}

#pragma mark - BMKMapViewDelegate

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"RadarMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}


- (void) dealloc {
    _radarManager = nil;
    [BMKRadarManager releaseRadarManagerInstance];
    _locServer.delegate = nil;
    _locServer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _mapView = nil;
}
@end
