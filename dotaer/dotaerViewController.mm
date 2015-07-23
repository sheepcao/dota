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
#import "myPointAnnotation.h"
#import "MFSideMenu.h"
#import "listCellTableViewCell.h"
#import "FabonacciNum.h"
#import "playerPageViewController.h"
#import "globalVar.h"
#import "userInfo.h"
#import "SideMenuViewController.h"
#import "DataCenter.h"

#define annoRatio 0.37
#define userCoverRatio 0.0025

@interface dotaerViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate, BMKRadarManagerDelegate> {
    BMKLocationService *_locServer;
    BMKRadarManager *_radarManager;
    CLLocationCoordinate2D _curLocation;
    CLLocationCoordinate2D _myCoor;

    BOOL isAutoUploading;
    NSLock *lock;
}


@property (strong,nonatomic) UIButton *pageFront;
@property (strong,nonatomic) UIButton *pageForward;
@property (strong,nonatomic) UILabel *pageNumLabel;
@property (strong,nonatomic) UISlider *radiusSlider;


@property (strong,nonatomic) UILabel *distanceLabel;

@property (strong,nonatomic) UITableView *listView;
@property (strong,nonatomic) BMKMapView *mapView;

@property (strong,nonatomic) userInfo *myUserInfo;
@property (strong,nonatomic) NSString *signature;

@property (nonatomic, strong) NSMutableArray *nearbyInfos;
@property (nonatomic) NSInteger curPageIndex;
@property (nonatomic) NSInteger totalPageNum;
@property (nonatomic) CGFloat searchRadius;

@end

@implementation dotaerViewController

@synthesize nearbyInfos = _nearbyInfos;
@synthesize curPageIndex = _curPageIndex;
- (void)viewDidLoad {
    [super viewDidLoad];

    _radarManager = [BMKRadarManager getRadarManagerInstance];

    [[DataCenter sharedDataCenter] setIsGuest:NO];
    self.signature = @"";
    if(!self.title) self.title = @"附近";
    
    UINib *nib = [UINib nibWithNibName:@"listCell" bundle:nil];
    [self.listView registerNib:nib forCellReuseIdentifier:@"listCell"];
    
    [self setupMenuBarButtonItems];
    [self setupCenterView];
    
    
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

-(void)setupCenterView
{
        NSLog(@"nav:%f,%f",self.navigationController.navigationBar.frame.size.height,self.navigationController.navigationBar.frame.origin.y);
    
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0.88*(SCREEN_HEIGHT-64))];
    
        [self.view addSubview:containerView];
    
    
        self.listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height-40)];
        self.listView.delegate = self;
        self.listView.dataSource = self;
       self.listView.rowHeight = 60;
//        self.listView.backgroundColor = [UIColor whiteColor];
        _nearbyInfos = [NSMutableArray array];

    
    
        self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)];
        self.mapView.backgroundColor = [UIColor whiteColor];
        self.mapView.zoomEnabled = YES;
    
        [containerView addSubview:self.listView];
    
    
        UIView *searchingBar = [[UIView alloc] initWithFrame:CGRectMake(0,  containerView.frame.size.height+containerView.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT - containerView.frame.size.height - containerView.frame.origin.y)];
    
        searchingBar.backgroundColor = [UIColor lightGrayColor];
    
        [self.view addSubview:searchingBar];
    
        UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(searchingBar.frame.size.width-searchingBar.frame.size.height, searchingBar.frame.size.height/8, searchingBar.frame.size.height*3/4, searchingBar.frame.size.height*3/4)];
    
  
    
        [searchBtn setTitle:@"查" forState:UIControlStateNormal];
        [searchBtn setBackgroundColor:[UIColor purpleColor]];
        [searchBtn addTarget:self action:@selector(searchDotaer) forControlEvents:UIControlEventTouchUpInside];
        [searchingBar addSubview:searchBtn];
        [searchBtn setEnabled:NO];
    [self performSelector:@selector(enableSearch:) withObject:searchBtn afterDelay:1.0];
    
    
        UIView *pageBar = [[UIView alloc] initWithFrame:CGRectMake(0,  containerView.frame.size.height+containerView.frame.origin.y - 40, SCREEN_WIDTH, 40)];
    [pageBar setBackgroundColor:[UIColor clearColor]];
    UIButton *pageUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 60, 30)];
    [pageUpBtn setTitle:@"前一页" forState:UIControlStateNormal];
    [pageUpBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [pageUpBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];

    [pageUpBtn addTarget:self action:@selector(pageUp) forControlEvents:UIControlEventTouchUpInside];
    [pageUpBtn setEnabled:NO];
    
    UIButton *pageDownBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 5, 60, 30)];
    [pageDownBtn setTitle:@"下一页" forState:UIControlStateNormal];
    [pageDownBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [pageDownBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];

    [pageDownBtn addTarget:self action:@selector(pageDown) forControlEvents:UIControlEventTouchUpInside];
    [pageDownBtn setEnabled:NO];
    
    UILabel *pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-20, 5, 40, 30)];
    [pageLabel setText:nil];
    pageLabel.textAlignment = NSTextAlignmentCenter;
    
    [pageBar addSubview:pageLabel];
    [pageBar addSubview:pageUpBtn];
    [pageBar addSubview:pageDownBtn];
    
    self.pageFront = pageUpBtn;
    self.pageForward = pageDownBtn;
    self.pageNumLabel = pageLabel;
    [self.view addSubview:pageBar];
    
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-80, searchingBar.frame.size.height/2-10, 160, 20)];
    slider.minimumValue = 13;
    slider.maximumValue = 31;
    slider.value = 18;
    _searchRadius = [FabonacciNum calculateFabonacci:slider.value];

    [slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    
    self.radiusSlider = slider;
    [searchingBar addSubview:slider];
    
    self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, searchingBar.frame.size.height/8, 55, searchingBar.frame.size.height*3/4)];
    [self.distanceLabel setText:@"< 2KM"];
    [self.distanceLabel setTextColor:[UIColor blackColor]];
    self.distanceLabel.font = [UIFont systemFontOfSize:13];
    [searchingBar addSubview:self.distanceLabel];

    
    


}

-(void)enableSearch:(UIButton *)btn
{
    [btn setEnabled:YES];
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

       
    }else if([[[notification userInfo] objectForKey:@"eventType"] intValue] == MFSideMenuStateEventMenuWillOpen)
    {
        if ([[DataCenter sharedDataCenter] isGuest]) {
            if ( [self.menuContainerViewController.leftMenuViewController isKindOfClass:[SideMenuViewController class]]) {
                SideMenuViewController *leftMenuVC = (SideMenuViewController *)self.menuContainerViewController.leftMenuViewController;
                [leftMenuVC.logoutBtn setTitle:@"登录" forState:UIControlStateNormal];
                [leftMenuVC.unLoginLabel setHidden:NO];
                [leftMenuVC.itemsTable setHidden:YES];
            }
        }else
        {
            
            if ( [self.menuContainerViewController.leftMenuViewController isKindOfClass:[SideMenuViewController class]]) {
                SideMenuViewController *leftMenuVC = (SideMenuViewController *)self.menuContainerViewController.leftMenuViewController;
                [leftMenuVC.logoutBtn setTitle:@"注销" forState:UIControlStateNormal];
                [leftMenuVC.unLoginLabel setHidden:YES];
                [leftMenuVC.itemsTable setHidden:NO];
            }
        }
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
    NSLog(@"appear !!!!!");
    [super viewWillAppear:animated];
    


    [_mapView viewWillAppear];
    [_radarManager addRadarManagerDelegate:self];//添加radar delegate

    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    
    NSLog(@"isGuest:%d",[[DataCenter sharedDataCenter] isGuest]);
    if ([[DataCenter sharedDataCenter] isGuest]) {
        NSLog(@"isGuest!");
        [self cancelUploadLocation];
        return;
    }else
    {
        NSLog(@"is NOT guest!");


        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"haveDefaultUser"] isEqualToString:@"yes"]) {
            
            NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoDic"];
            
         
            [self configUserInfo:userDic];
            
            if ( [self.menuContainerViewController.leftMenuViewController isKindOfClass:[SideMenuViewController class]]) {

                SideMenuViewController *leftMenuVC = (SideMenuViewController *)self.menuContainerViewController.leftMenuViewController;
                
                self.signature = [leftMenuVC requestSignature];
                
            }
            
            //        [self performSelector:@selector(uploadRadarInfo) withObject:nil afterDelay:0.75];

            [self uploadLocation];

            
        }else
        {
            [self showLoginPage];
            
        }
        

    }
    
}

-(void)configUserInfo:(NSDictionary *)userDic
{
    userInfo *myInfo = [[userInfo alloc] init];
    myInfo.username = [userDic objectForKey:@"username"];
    myInfo.age = [userDic objectForKey:@"age"];
    myInfo.sex = [userDic objectForKey:@"sex"];
    myInfo.email = [userDic objectForKey:@"email"];
    myInfo.createTime = [userDic objectForKey:@"created"];
    myInfo.id_DB = [userDic objectForKey:@"id"];
    myInfo.headImagePath = [imagePath stringByAppendingString:[userDic objectForKey:@"username"]];
    
    self.myUserInfo = myInfo;
    
    if ( [self.menuContainerViewController.leftMenuViewController isKindOfClass:[SideMenuViewController class]]) {
        NSURL *url = [NSURL URLWithString:myInfo.headImagePath];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        SideMenuViewController *leftMenuVC = (SideMenuViewController *)self.menuContainerViewController.leftMenuViewController;
        
        [leftMenuVC.headImage setImage:img];
        [leftMenuVC.sexImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",myInfo.sex]]];
        [leftMenuVC.ageLabel setText:[NSString stringWithFormat:@"%@岁",myInfo.age]];
        
        
    }
}

-(void)uploadRadarInfo
{
    BOOL res = [_radarManager uploadInfoRequest:[self getCurrInfo]];
    if (res) {
        NSLog(@"upload 成功");
    } else {
        NSLog(@"upload 失败");
    }
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
    _locServer = [[BMKLocationService alloc] init];
    _locServer.delegate = self;
    [_locServer startUserLocationService];
    
    [_radarManager startAutoUpload:17];
   

}
-(void)cancelUploadLocation
{
    _radarManager = [BMKRadarManager getRadarManagerInstance];
    _locServer = [[BMKLocationService alloc] init];
    _locServer.delegate = self;
    [_locServer startUserLocationService];
    
    [_radarManager stopAutoUpload];
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

        //test
//        [_mapView setCenterCoordinate:_myCoor];
        [_mapView setCenterCoordinate: CLLocationCoordinate2DMake(34.226, 108.886)];

        [_mapView setZoomLevel:14.0];

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
        
        myPointAnnotation *annotation = [[myPointAnnotation alloc] init];
        annotation.coordinate = info.pt;
        annotation.title = info.userId;
        annotation.annoUserDistance = info.distance;
        
        //distance....
        
        BOOL beContained = NO;
        
        for(myPointAnnotation *tempAnno in annotations)
        {
            if (fabs(annotation.coordinate.latitude - tempAnno.coordinate.latitude)<userCoverRatio && fabs(annotation.coordinate.longitude - tempAnno.coordinate.longitude)<userCoverRatio) {

                [tempAnno.containUsers addObject:annotation];
                beContained = YES;
                break;
            }
        }
        if (!beContained) {
            [annotations addObject:annotation];

        }
    }
    [_mapView addAnnotations:annotations];
    [_mapView showAnnotations:annotations animated:YES];
    [_mapView setZoomLevel:9.5+((32 - self.radiusSlider.value)/2) ];
}

-(void)updateValue:(UISlider *)sender{
//添加响应事件
    
    
    if (sender.value<31) {
        _searchRadius = [FabonacciNum calculateFabonacci:sender.value];
        [self.distanceLabel setText:@"> 500KM"];

        
        if (_searchRadius<1000) {
            self.distanceLabel.text = [NSString stringWithFormat:@"< %d00米",(int)_searchRadius/100];
            
        }else if(_searchRadius>10000000)
        {
            self.distanceLabel.text = [NSString stringWithFormat:@"> 500KM"];
            
        }else
        {
            self.distanceLabel.text = [NSString stringWithFormat:@"< %dKM",((int)_searchRadius/1000) +1];
            
        }
        

    }else
    {
        _searchRadius = 99999999999;//无限远
        [self.distanceLabel setText:@"> 500KM"];

    }
    
    NSLog(@"Radius------%f",_searchRadius);

}

-(void)searchDotaer
{
    _curPageIndex = 0;
    [self nearbySearchWithPageIndex:_curPageIndex];

}

-(void)pageUp
{
    if (_curPageIndex>0) {
        _curPageIndex --;
        [self nearbySearchWithPageIndex:_curPageIndex];
    }

}
-(void)pageDown
{
    if (_curPageIndex<_totalPageNum) {
        _curPageIndex ++;
        [self nearbySearchWithPageIndex:_curPageIndex];
    }
    
    
}

- (void)nearbySearchWithPageIndex:(NSInteger) pageIndex {
    BMKRadarNearbySearchOption *option = [[BMKRadarNearbySearchOption alloc] init]
    ;
    option.radius = _searchRadius;
    option.sortType = BMK_RADAR_SORT_TYPE_DISTANCE_FROM_NEAR_TO_FAR;
    //test
//    option.centerPt = _myCoor;
    option.centerPt = CLLocationCoordinate2DMake(34.226, 108.886);
    option.pageIndex = pageIndex;

    
    BOOL res = [_radarManager getRadarNearbySearchRequest:option];
    if (res) {
        NSLog(@"get 成功");
    } else {
        NSLog(@"get 失败");
    }
    
}

#pragma custom annotation




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)updateMyLocation:(BMKUserLocation *) loc {
    BMKUserLocation *location = loc;
    _myCoor = location.location.coordinate;
//    _mapView.showsUserLocation = YES;//显示定位图层
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


#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    BMKRadarNearbyInfo *info = [_nearbyInfos objectAtIndex:indexPath.row];
    [self jumpToPlayer:info.userId andDistance:info.distance andSignature:self.signature];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (BMKRadarUploadInfo *)getCurrInfo {
    BMKRadarUploadInfo *info = [[BMKRadarUploadInfo alloc] init];

//    int random = arc4random()%1000;
//    _radarManager.userId =[NSString stringWithFormat:@"dotaer%d",random];
    if (self.myUserInfo.username) {
        _radarManager.userId =self.myUserInfo.username;
        info.extInfo = @"hello dota";
        [lock lock];
        
        
        info.pt =  CLLocationCoordinate2DMake(34.216, 108.896);//我的地理坐标
        
        //test
        //    info.pt = _curLocation;
        [lock unlock];
        return info;
    }
    else
    {
        return nil;
    }


 
}

#pragma mark - BMKRadarManagerDelegate

/*
 *开启自动上传，需实现该回调
 */
- (BMKRadarUploadInfo *)getRadarAutoUploadInfo {
//    if ([[DataCenter sharedDataCenter] isGuest])
//    {
//        return nil;
//    }else
    
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
    NSLog(@"location error,%@",error);
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

        _totalPageNum = result.pageNum;
        
        if (_totalPageNum>0 && _curPageIndex<_totalPageNum-1) {
            [self.pageForward setEnabled:YES];
        }else
        {
            [self.pageForward setEnabled:NO];
        }
        
        if (_curPageIndex>0) {
            [self.pageFront setEnabled:YES];

        }else
        {
            [self.pageFront setEnabled:NO];
        }
        
        [self.pageNumLabel setText:[NSString stringWithFormat:@"%ld",_curPageIndex+1]];
        
//        if (_searchRadius<1000) {
//            self.title = [NSString stringWithFormat:@"附近 < %d00米",(int)_searchRadius/100];
//
//        }else if(_searchRadius>10000000)
//        {
//            self.title = [NSString stringWithFormat:@"附近 > 500KM"];
//
//        }else
//        {
//            self.title = [NSString stringWithFormat:@"附近 < %dKM",((int)_searchRadius/1000) +1];
//            
//        }
//        _curPageIndex = result.pageIndex;
        
//        NSLog(@"pageIndex---%ld  of %ld",_curPageIndex,result.pageNum);
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
    annotationView.canShowCallout = NO;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    

    
    UIView *viewForImage=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 112*annoRatio, 144*annoRatio)];
    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 112*annoRatio, 144*annoRatio)];
    [backImageView setImage:[UIImage imageNamed:@"MapAnnotationBG"]];

    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(3, 4, 112*annoRatio-6, 112*annoRatio-6)];
    [viewForImage addSubview:backImageView];
    [viewForImage addSubview:imageview];

    if ([annotation isKindOfClass:[myPointAnnotation class]]) {
        
        
        myPointAnnotation *anno = (myPointAnnotation *)annotation;
        NSString *headPath = [imagePath stringByAppendingString:anno.title];
        
        NSLog(@"anno.title---%@",anno.title);
        
        NSURL *url = [NSURL URLWithString:headPath];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        [imageview setImage:img];

        if (anno.containUsers.count>0) {
            
            UIImageView *countBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(112*annoRatio-6-15, 112*annoRatio-6-15, 15, 15)];
            [countBackImage setImage:[UIImage imageNamed:@"MapUserCountBG"]];
            
            [imageview addSubview:countBackImage];
            
            UILabel *userCount = [[UILabel alloc] initWithFrame:CGRectMake(112*annoRatio-6-14, 112*annoRatio-6-13, 16, 16)];
            userCount.textAlignment = NSTextAlignmentCenter;
            [userCount setText:[NSString stringWithFormat:@"%ld",anno.containUsers.count + 1 ]];
            userCount.font = [UIFont boldSystemFontOfSize:8.2f];
            [imageview addSubview:userCount];
        }
    }
    
    
    annotationView.image=[self getImageFromView:viewForImage];
    

    
    return annotationView;
}


-(UIImage *)getImageFromView:(UIView *)view{
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(view.bounds.size);
    //获取图像
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;


}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"tap annotation!");
    
    myPointAnnotation *anno;
    if ([view.annotation isKindOfClass:[myPointAnnotation class]]) {
        anno = (myPointAnnotation *)view.annotation;
    }
    
    [self jumpToPlayer:anno.title andDistance:anno.annoUserDistance andSignature:self.signature];

    [_mapView deselectAnnotation:view.annotation animated:YES];
  
}


-(void)jumpToPlayer:(NSString *)playerName andDistance:(NSUInteger)distance andSignature:(NSString *)signature
{
    playerPageViewController *playInfo = [[playerPageViewController alloc] initWithNibName:@"playerPageViewController" bundle:nil];

    playInfo.playerName = playerName;
    playInfo.distance = distance;
    playInfo.userSignature = signature;
    
    [self.navigationController pushViewController:playInfo animated:YES];
    
    
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
