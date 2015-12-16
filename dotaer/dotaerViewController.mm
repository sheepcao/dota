//
//  ViewController.m
//  dotaer
//
//  Created by Eric Cao on 7/6/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//
#import <GoogleMobileAds/GoogleMobileAds.h>

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
//#import "levelInfoViewController.h"
#import "submitScoreViewController.h"
#import "favorViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "testSearchViewController.h"
#import "settingViewController.h"


#define annoRatio 0.37
#define userCoverRatio 0.0025



@interface dotaerViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate, BMKRadarManagerDelegate,GADBannerViewDelegate,setTTscoreDelegate> {
    BMKLocationService *_locServer;
    //    BMKRadarManager *_radarManager;
    CLLocationCoordinate2D _curLocation;
    CLLocationCoordinate2D _myCoor;
    
    BOOL isAutoUploading;
    NSLock *lock;
}


@property (strong,nonatomic) UIButton *pageFront;
@property (strong,nonatomic) UIButton *pageForward;
@property (strong,nonatomic) UILabel *pageNumLabel;
@property (strong,nonatomic) UISlider *radiusSlider;

@property (strong,nonatomic) UIView *containerView;
@property (strong,nonatomic) UILabel *distanceLabel;

@property (strong,nonatomic) UITableView *listView;
@property (strong,nonatomic) BMKMapView *mapView;

@property (strong,nonatomic) userInfo *myUserInfo;
@property (strong,nonatomic) NSString *signature;
@property (strong,nonatomic) NSString *topic;
@property (strong,nonatomic) NSString *topicDay;


@property (nonatomic, strong) NSMutableArray *nearbyInfos;
@property (nonatomic, strong) NSMutableDictionary *nearbyDics;

@property (nonatomic) NSInteger curPageIndex;
@property (nonatomic) NSInteger totalPageNum;
@property (nonatomic) CGFloat searchRadius;

@property (nonatomic, strong) popView *PopAlert;



@property (nonatomic, strong) NSString *VIEWSTATEGENERATOR ;
@property (nonatomic, strong) NSString *VIEWSTATE;
@property (nonatomic, strong) NSString *EVENTVALIDATION;
@property (nonatomic, strong) NSString *loginURL;


@end

@implementation dotaerViewController
@synthesize loginURL;
@synthesize VIEWSTATEGENERATOR;
@synthesize VIEWSTATE;
@synthesize EVENTVALIDATION;

int uploadPositionCount;

@synthesize nearbyInfos = _nearbyInfos;
@synthesize nearbyDics = _nearbyDics;
@synthesize curPageIndex = _curPageIndex;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    uploadPositionCount = 0;
    _locServer = [[BMKLocationService alloc] init];
    _locServer.delegate = self;
    lock = [[NSLock alloc] init];
    
    [self judgeIsLocaltionabele];
    
    [_locServer startUserLocationService];
    
    [[DataCenter sharedDataCenter] setIsGuest:NO];
    [[DataCenter sharedDataCenter] setNeedLoginDefault:YES];
    [[DataCenter sharedDataCenter] setAlertLocationPermission:NO];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"invisible"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"invisible"];
    }
    
    
    self.signature = @"";
    if(!self.title) self.title = @"附近";
    
    UINib *nib = [UINib nibWithNibName:@"listCell" bundle:nil];
    [self.listView registerNib:nib forCellReuseIdentifier:@"listCell"];
    
    [self setupMenuBarButtonItems];
    self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
    
    [self setupCenterView];
    [self requestTopic];
    [self performSelector:@selector(dismissHUD) withObject:nil afterDelay:6.6f];
    
    NSLog(@"dotaerViewController did load");
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];

}

-(void)judgeIsLocaltionabele
{
    if ([CLLocationManager locationServicesEnabled] && (
                                                        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
                                                        || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined
                                                        ||[CLLocationManager authorizationStatus] ==kCLAuthorizationStatusAuthorizedWhenInUse)) {
        //定位功能可用，开始定位
        
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请开启隐私设置中的定位服务，否则无法检索附近玩家。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
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


-(void)requestTopic
{
    
    
    self.topic = @"";
    self.topicDay = @"1";
    
    NSDictionary *parameters = @{@"tag": @"todayTopic"};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:12];  //Time out after 25 seconds
    
    
    [manager POST:topicURL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"topic Json: %@", responseObject);
        
        self.topic = [responseObject objectForKey:@"topic_content"];
        self.topicDay = [responseObject objectForKey:@"topic_day"] ;
        
        SideMenuViewController *leftMenuVC;
        
        if ( [self.menuContainerViewController.leftMenuViewController isKindOfClass:[SideMenuViewController class]]) {
            leftMenuVC = (SideMenuViewController *)self.menuContainerViewController.leftMenuViewController;
            
            
            
            leftMenuVC.topicDay = self.topicDay;
            leftMenuVC.topic = self.topic;
            
            
        }
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"topicDay"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"topicDay"] isEqualToString:self.topicDay]) {
            
            
        }else
        {
            NSLog(@"今日有新的话题！！！！！目录和item都加红点。。。");
            
            int rowHeight = 35;
            
            if(IS_IPHONE_4_OR_LESS){
                
            }else if(IS_IPHONE_5)
            {
                rowHeight = 42;
            }else if(IS_IPHONE_6)
            {
                rowHeight = 48;
            }else
            {
                rowHeight = 50;
            }
            
            
            UIImageView *haveNewtopicImg = [[UIImageView alloc] initWithFrame:CGRectMake(leftMenuVC.itemsTable.frame.size.width*2/3-10, rowHeight*2.3, 30, 14)];
            [haveNewtopicImg setImage:[UIImage imageNamed:@"new.png"]];
            haveNewtopicImg.tag = 101;
            
            for (UIView *img in [leftMenuVC.itemsTable subviews]) {
                if (img.tag == 101) {
                    return ;
                }
                
                [leftMenuVC.itemsTable addSubview:haveNewtopicImg];
                
                
                
            }
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"topic JsonError: %@", error.localizedDescription);
        NSLog(@"topic Json ERROR: %@",  operation.responseString);
        
        
        
        
        
    }];
    
    
}
-(void)setupCenterView
{
       NSLog(@"nav:%f,%f",self.navigationController.navigationBar.frame.size.height,self.navigationController.navigationBar.frame.origin.y);
    
    
    self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, 50)];
    self.bannerView.delegate = self;
    self.bannerView.adUnitID =ADMOB_ID;
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
    [self.view addSubview:self.bannerView];
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0+50, SCREEN_WIDTH, 0.88*(SCREEN_HEIGHT-64-50))];
    
    containerView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:containerView];
    
    
    self.listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height-40)];
    self.listView.delegate = self;
    self.listView.dataSource = self;
    self.listView.rowHeight = 70;
    //    self.listView.backgroundColor = [UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1.0];
    
    self.listView.backgroundColor = [UIColor clearColor];
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [self.listView setSeparatorInset:UIEdgeInsetsMake(0,30,0,30)];
    _nearbyInfos = [NSMutableArray array];
    
    
    
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)];
    self.mapView.backgroundColor = [UIColor whiteColor];
    self.mapView.zoomEnabled = YES;
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放

    [containerView addSubview:self.listView];
    
    
    self.containerView = containerView;
    
    
    UIView *searchingBar = [[UIView alloc] initWithFrame:CGRectMake(0,  containerView.frame.size.height+containerView.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT -64- containerView.frame.size.height - containerView.frame.origin.y)];
    //    NSLog(@"searchingBar:%@-----container:%@",searchingBar,containerView);
    
    searchingBar.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *bottomBarBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, searchingBar.frame.size.width, searchingBar.frame.size.height)];
    [bottomBarBack setImage:[UIImage imageNamed:@"topBar.png"]];
    
    [searchingBar addSubview:bottomBarBack];
    
    [self.view addSubview:searchingBar];
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(searchingBar.frame.size.width-searchingBar.frame.size.height*1.3, searchingBar.frame.size.height*0.2, 2*searchingBar.frame.size.height*0.6, searchingBar.frame.size.height*0.6)];
    
    
    
    
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"listButton.png"] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"listButtonPress.png"] forState:UIControlStateHighlighted];
    [searchBtn setTitle:@"搜 索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor colorWithRed:250/255.0f green:250/255.0f  blue:250/255.0f  alpha:1.0f] forState:UIControlStateNormal];
  
    [searchBtn addTarget:self action:@selector(searchDotaer) forControlEvents:UIControlEventTouchUpInside];
    [searchingBar addSubview:searchBtn];
    [searchBtn setEnabled:NO];
    [self performSelector:@selector(enableSearch:) withObject:searchBtn afterDelay:1.0];
    
    
    UIView *pageBar = [[UIView alloc] initWithFrame:CGRectMake(0,  containerView.frame.size.height+containerView.frame.origin.y - 40, SCREEN_WIDTH, 40)];
    [pageBar setBackgroundColor:[UIColor clearColor]];
    UIButton *pageUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 60, 30)];
    [pageUpBtn setTitle:@"前一页" forState:UIControlStateNormal];
    [pageUpBtn setTitleColor:[UIColor colorWithRed:7/255.0f green:7/255.0f  blue:7/255.0f  alpha:1.0f] forState:UIControlStateNormal];
    [pageUpBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    [pageUpBtn addTarget:self action:@selector(pageUp) forControlEvents:UIControlEventTouchUpInside];
    [pageUpBtn setEnabled:NO];
    
    UIButton *pageDownBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 5, 60, 30)];
    [pageDownBtn setTitle:@"下一页" forState:UIControlStateNormal];
    [pageDownBtn setTitleColor:[UIColor colorWithRed:7/255.0f green:7/255.0f  blue:7/255.0f  alpha:1.0f] forState:UIControlStateNormal];
    [pageDownBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    [pageDownBtn addTarget:self action:@selector(pageDown) forControlEvents:UIControlEventTouchUpInside];
    [pageDownBtn setEnabled:NO];
    
    UILabel *pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-20, 5, 40, 30)];
    [pageLabel setText:nil];
    [pageLabel setTextColor:[UIColor colorWithRed:7/255.0f green:7/255.0f  blue:7/255.0f  alpha:1.0f]];
    pageLabel.textAlignment = NSTextAlignmentCenter;
    
    [pageBar addSubview:pageLabel];
    [pageBar addSubview:pageUpBtn];
    [pageBar addSubview:pageDownBtn];
    
    self.pageFront = pageUpBtn;
    self.pageForward = pageDownBtn;
    self.pageNumLabel = pageLabel;
    [self.view addSubview:pageBar];
    
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(82, searchingBar.frame.size.height/2-17, searchingBar.frame.size.width-82-1.15*searchBtn.frame.size.width, 34)];
    slider.minimumValue = 13;
    slider.maximumValue = 31;
    slider.value = 22;
    slider.maximumTrackTintColor = [UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f];
    slider.minimumTrackTintColor = [UIColor colorWithRed:108/255.0f green:178/255.0f blue:175/255.0f alpha:1.0f];
    
    //    [slider setThumbTintColor:[UIColor colorWithRed:108/255.0f green:178/255.0f blue:175/255.0f alpha:1.0f]];
    
    //    UIImage* minTrack = [UIImage imageNamed:@"eye29.png"];
    //    [slider setThumbImage:minTrack forState:UIControlStateNormal];
    
    [slider setThumbTintColor:[UIColor colorWithRed:108/255.0f green:178/255.0f blue:175/255.0f alpha:1.0f]];
    
    _searchRadius = [FabonacciNum calculateFabonacci:slider.value];
    
    [slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    
    self.radiusSlider = slider;
    [searchingBar addSubview:slider];
    
    self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, searchingBar.frame.size.height/8, 63, searchingBar.frame.size.height*3/4)];
    self.distanceLabel.textAlignment = NSTextAlignmentCenter;
    //    [self.distanceLabel setBackgroundColor:[UIColor yellowColor]];
    [self.distanceLabel setText:@"11KM"];
    [self.distanceLabel setTextColor:[UIColor colorWithRed:247/255.0f green:257/255.0f blue:257/255.0f alpha:1.0f]];
    self.distanceLabel.font = [UIFont systemFontOfSize:14.5f];
    [searchingBar addSubview:self.distanceLabel];
    
}

-(void)enableSearch:(UIButton *)btn
{
    [btn setEnabled:YES];
    
    [self performSelector:@selector(firstSearch) withObject:nil afterDelay:0.8];
    
    
    
}
-(void)firstSearch
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.containerView animated:YES];
    hud.tag = 345;
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"正在搜索玩家...";
    [hud hide:YES afterDelay:6.0f];
    
    _curPageIndex = 0;
    
    [self nearbySearchWithPageIndex:[NSNumber numberWithInteger:_curPageIndex]];
    
    NSLog(@"firstSearch");
}

-(void)showHUD:(NSNumber *)time
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.containerView animated:YES];
    hud.tag = 345;
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"正在搜索玩家...";
    [hud hide:YES afterDelay:[time doubleValue]];
}

-(void)dismissHUD
{
    
    for (UIView *hud in [self.containerView subviews]) {
        if ([hud isKindOfClass:[MBProgressHUD class]]) {
            
            MBProgressHUD * hudView = (MBProgressHUD *)hud;
            [hudView hide:YES];
            
        }
    }
    
    
}


#pragma mark -
#pragma mark - UIBarButtonItems

- (void)setupMenuBarButtonItems {
    
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
                [leftMenuVC.logoutBtn setTitle:@"登 录" forState:UIControlStateNormal];
                [leftMenuVC.unLoginLabel setHidden:NO];
                //                [leftMenuVC.itemsTable setHidden:YES];
                [leftMenuVC.ageLabel setHidden:YES];
                [leftMenuVC.headImage setHidden:YES];
                [leftMenuVC.headBtn setHidden:YES];
                [leftMenuVC.signatureTextView setHidden:YES];
                [leftMenuVC.sexImg setHidden:YES];
                [leftMenuVC.usernameLabel setHidden:YES];
                [leftMenuVC.cycleIMG setHidden:YES];
                
                [leftMenuVC.itemsTable reloadData];
                
                
            }
        }else
        {
            
            if ( [self.menuContainerViewController.leftMenuViewController isKindOfClass:[SideMenuViewController class]]) {
                SideMenuViewController *leftMenuVC = (SideMenuViewController *)self.menuContainerViewController.leftMenuViewController;
                [leftMenuVC.logoutBtn setTitle:@"注 销" forState:UIControlStateNormal];
                [leftMenuVC.unLoginLabel setHidden:YES];
                //                [leftMenuVC.itemsTable setHidden:NO];
                [leftMenuVC.ageLabel setHidden:NO];
                [leftMenuVC.headImage setHidden:NO];
                [leftMenuVC.headBtn setHidden:NO];
                [leftMenuVC.signatureTextView setHidden:NO];
                [leftMenuVC.sexImg setHidden:NO];
                [leftMenuVC.usernameLabel setHidden:NO];
                [leftMenuVC.cycleIMG setHidden:NO];
                [leftMenuVC.itemsTable reloadData];
                
                
                NSMutableArray *favorArray = [[DataCenter sharedDataCenter] fetchFavors];
                NSString *favorString = @"关注";
                if (favorArray && favorArray.count>0)
                {
                    favorString = [NSString stringWithFormat:@"关注(%lu)",(unsigned long)favorArray.count];
                }
                
            }
        }
    }
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    //    return [[UIBarButtonItem alloc] initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:self action:@selector(leftSideMenuButtonPressed:)];
    
    UIButton *btnNext1 =[[UIButton alloc] init];
    [btnNext1 setImage:[UIImage imageNamed:@"menu1.png"] forState:UIControlStateNormal];
    
    btnNext1.frame = CGRectMake(15, 17, 35, 35);
    UIBarButtonItem *btnNext =[[UIBarButtonItem alloc] initWithCustomView:btnNext1];
    btnNext1.tag = 0;
    [btnNext1 addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return btnNext;
    
    
}

- (UIBarButtonItem *)rightMenuBarButtonItem {
    
    
    UIButton *btnNext1 =[[UIButton alloc] init];
    [btnNext1 setImage:[UIImage imageNamed:@"mid_ditu.png"] forState:UIControlStateNormal];
    
    btnNext1.frame = CGRectMake(15, SCREEN_WIDTH-52, 35, 35);
    UIBarButtonItem *btnNext =[[UIBarButtonItem alloc] initWithCustomView:btnNext1];
    btnNext1.tag = 0;
    [btnNext1 addTarget:self action:@selector(mapTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return btnNext;
    
    
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


- (void)userLogin:(NSDictionary *)userinfoDic {
    
    [self.view endEditing:YES];// this will do the trick
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"登录中...";
    hud.dimBackground = YES;
    
    NSDictionary *parameters = @{@"tag": @"login",@"name":[userinfoDic objectForKey:@"username"],@"password":[userinfoDic objectForKey:@"password"]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:15];  //Time out after 25 seconds
    
    
    [manager POST:registerService parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MobClick event:@"UserLogin"];
        
//        hud.mode = MBProgressHUDModeCustomView;
//        hud.labelText = @"登录成功";
    
        [hud hide:YES];
        
        NSString *invis = [[NSUserDefaults standardUserDefaults] objectForKey:@"invisible"];
        if (![invis isEqualToString:@"yes"]) {
            [self showLocationPermission];
        }
        
        [self configUserInfo:userinfoDic];
        
        
        if ( [self.menuContainerViewController.leftMenuViewController isKindOfClass:[SideMenuViewController class]]) {
            
            SideMenuViewController *leftMenuVC = (SideMenuViewController *)self.menuContainerViewController.leftMenuViewController;
            
            self.signature = [leftMenuVC requestSignature];
            
        }
        
        
        [self uploadLocation];
        
        [self popValidationCodeWithImage];
        
   
        
        
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        
        
        [hud hide:YES ];
        
        
        [self cancelUploadLocation];
        [self showLoginPage];
        if ([DataCenter myContainsStringFrom:operation.responseString ForSting:@"Incorrect username or password"]) {
            UIAlertView *userNameAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"您的默认密码有误，请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [userNameAlert show];
        }else
        {
            UIAlertView *registerFailedAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"登录失败，请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [registerFailedAlert show];
        }
        
        
        
    }];
    
    
    [[DataCenter sharedDataCenter] setNeedLoginDefault:NO];
    
    
    
    
}



-(void)popValidationCodeWithImage
{
    
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"popView"
                            
                                                         owner:nil                                                               	options:nil];
    
    self.PopAlert= 	(popView *)[nibContents objectAtIndex:0];
    [self.PopAlert roundBack];
    [self.PopAlert loadingOn:self.PopAlert.contentView withDim:YES];
    
    [self.PopAlert.codeImage addTarget:self action:@selector(refreshCode) forControlEvents:UIControlEventTouchUpInside];
    [self.PopAlert.submitButton addTarget:self action:@selector(prepareCocies) forControlEvents:UIControlEventTouchUpInside];
    [self.PopAlert.submitButton setEnabled:NO];
    
    [self.PopAlert setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT*3/2)];
    [self.view addSubview:self.PopAlert];
    
    [self requestExtroInfo];
    
    [UIView animateWithDuration:0.45 delay:0.05 usingSpringWithDamping:1.0 initialSpringVelocity:0.4 options:0 animations:^{
        [self.PopAlert setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
    } completion:nil];
    
    
}

-(void)requestExtroInfo
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:37.0) Gecko/20100101 Firefox/37.0" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    [manager.requestSerializer setTimeoutInterval:12];
    
    [[DataCenter sharedDataCenter] clearRequestCache];
    
    NSString *infoURLstring = @"http://score.5211game.com/Ranking/ranking.aspx";
    
    //
    [manager GET:infoURLstring parameters:nil success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
        
        testSearchViewController * testSearchVC = [[testSearchViewController alloc] init];
        
        
        loginURL = [testSearchVC pickURL:responseObject];
        
        
        VIEWSTATEGENERATOR = [testSearchVC pickVIEWSTATEGENERATOR:responseObject];
        VIEWSTATE = [testSearchVC pickVIEWSTATE:responseObject];
        EVENTVALIDATION = [testSearchVC pickEVENTVALIDATION:responseObject];
        
        NSLog(@"VIEWSTATE--%@\nVIEWSTATEGENERATOR--%@\nEVENTVALIDATION--%@\n",VIEWSTATE,VIEWSTATEGENERATOR,EVENTVALIDATION);
        
        
        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"result------%@\n",aString);
        
        
        [self requestValidationImage];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        
        
    }];
}


-(void)requestValidationImage
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:37.0) Gecko/20100101 Firefox/37.0" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    [manager.requestSerializer setTimeoutInterval:30];
    
    
    
    NSString *infoURLstring = @"http://passport.5211game.com/ValidateCode.aspx";
    
    //
    [manager GET:infoURLstring parameters:nil success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
        
        
        UIImage *aString = [[UIImage alloc] initWithData:responseObject];
        
        [self.PopAlert.codeImage setBackgroundImage: aString forState:UIControlStateNormal];
        [self.PopAlert.submitButton setEnabled:YES];
        
        if (self.PopAlert.isLoading) {
            [self.PopAlert loadOver];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        if (self.PopAlert.isLoading) {
            [self.PopAlert loadOver];
        }
        
    }];
}

- (void)refreshCode {
    
    [self requestValidationImage];
    
}
- (void)prepareCocies{
    
    [self.PopAlert.codeField resignFirstResponder];
    
    if (!self.PopAlert.isLoading) {
        [self.PopAlert loadingOn:self.PopAlert.contentView withDim:YES];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:37.0) Gecko/20100101 Firefox/37.0" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    [manager.requestSerializer setTimeoutInterval:30];
    
    
    
    NSString *infoURLstring = [NSString stringWithFormat:@"http://passport.5211game.com%@",loginURL];
    NSString *code = @"000000";
    if (![self.PopAlert.codeField.text isEqualToString:@""]) {
        code= self.PopAlert.codeField.text;
        
    }
    
    if(!loginURL||!VIEWSTATE||!EVENTVALIDATION||!VIEWSTATEGENERATOR)
    {
        if (self.PopAlert.isLoading) {
            [self.PopAlert loadOver];
        }
        return ;
    }
    
    NSDictionary *parameters = @{@"__VIEWSTATE":VIEWSTATE,@"__VIEWSTATEGENERATOR":VIEWSTATEGENERATOR,@"__EVENTVALIDATION":EVENTVALIDATION,@"txtAccountName":@"宝贝拼吧",@"txtPassWord":@"xuechan99",@"txtValidateCode":code,@"ImgButtonLogin.x":@65,@"ImgButtonLogin.y":@13};
    
    [manager POST:infoURLstring parameters:parameters success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
        
        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"login success:%@",aString);
        if (self.PopAlert.isLoading) {
            [self.PopAlert loadOver];
        }
        testSearchViewController * testSearchVC = [[testSearchViewController alloc] init];
        
        NSString *userID = [testSearchVC pickUserID:responseObject];
        if (userID) {

            
            [UIView animateWithDuration:0.45 delay:0.05 usingSpringWithDamping:1.0 initialSpringVelocity:0.4 options:0 animations:^{
                [self.PopAlert setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT*3/2)];
            } completion:^(BOOL isfinished){
            
                [self.PopAlert removeFromSuperview];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeAnnularDeterminate;
                hud.labelText = @"登录成功";
                hud.dimBackground = YES;
                [hud hide:YES afterDelay:1.0];
            }];
            
            
 
           

            
        }else
        {
            [self refreshCode];
            [self.PopAlert.codeField setText:@""];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        if (self.PopAlert.isLoading) {
            [self.PopAlert loadOver];
        }
        
    }];
    
    
    
}







-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"appear !!!!!");
    [super viewDidAppear:animated];
    
    self.title = @"附近";
    

    
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
            
            
            if ([[DataCenter sharedDataCenter] needLoginDefault]) {
                [self userLogin:userDic];
                
            }else
            {
                if ([[DataCenter sharedDataCenter] alertLocationPermission])
                {
                    [self showLocationPermission];
                }
                
                [self configUserInfo:userDic];
                
                
                if ( [self.menuContainerViewController.leftMenuViewController isKindOfClass:[SideMenuViewController class]]) {
                    
                    SideMenuViewController *leftMenuVC = (SideMenuViewController *)self.menuContainerViewController.leftMenuViewController;
                    
                    self.signature = [leftMenuVC requestSignature];
                    
                }
                
                
                [self uploadLocation];
            }
            
            
            if([[DataCenter sharedDataCenter] needConfirmLevelInfo])
            {
                [self showConfirmLevel];
            }
            
            
            
            
        }else
        {
            [self showLoginPage];
            
        }
        
        
    }
    
    NSLog(@"dotaerViewController did appear");
    
    
}

-(void)showLocationPermission
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:15];  //Time out after 25 seconds
    
    
    NSDictionary *parameters = @{@"tag": @"needPermissionAlert"};

    NSString *infoURLstring = [NSString stringWithFormat:@"http://cgx.nwpu.info/Sites/settings.php"];
    
    [manager POST:infoURLstring parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        if ([[responseObject objectForKey:@"location_alert"] isEqualToString:@"yes"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"捣塔圈已共享您的位置信息，如果您不想被周围玩家查看，可以在我的圈子中进行隐身设置哦。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"去设置", nil];
            
            [[DataCenter sharedDataCenter] setAlertLocationPermission:NO];
            alert.tag = 100;
            [alert show];
        }
       
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
      
        
    }];

    
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if(buttonIndex == 1)
        {
            settingViewController *settingVC = [[settingViewController alloc] initWithNibName:@"settingViewController" bundle:nil];
            [self.navigationController pushViewController:settingVC animated:YES];

        }
    }
}



-(void)updateUserScores:(NSString *)username
{
    NSDictionary *userGameAccount = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:username]];
    
    if (userGameAccount) {
        
        NSString *gameName = [userGameAccount objectForKey:@"gameName"];
        NSString *gamePassword = [userGameAccount objectForKey:@"gamePassword"];
        if(gameName && gamePassword && ![gameName isEqualToString:@""] &&![gamePassword isEqualToString:@""])
        {
            submitScoreViewController *levelInfo = [[submitScoreViewController alloc] init];
            [levelInfo requestExtroInfoWithUser:gameName andPassword:gamePassword];
            
        }
        
        
    }
    
    
}

-(void)showConfirmLevel
{
    
    submitScoreViewController *levelInfo = [[submitScoreViewController alloc] initWithNibName:@"submitScoreViewController" bundle:nil];
    
    levelInfo.TTscoreDelegate = self;
    [self presentViewController:levelInfo animated:YES completion:nil];
    
    [[DataCenter sharedDataCenter] setNeedConfirmLevelInfo:NO];
}

-(void)configUserInfo:(NSDictionary *)userDic
{
    userInfo *myInfo = [[userInfo alloc] init];
    myInfo.username = [userDic objectForKey:@"username"];
    myInfo.age = [userDic objectForKey:@"age"];
    myInfo.sex = [userDic objectForKey:@"sex"];
    myInfo.email = [userDic objectForKey:@"email"];
    myInfo.createTime = [userDic objectForKey:@"created"];
    myInfo.isReviewed = [userDic objectForKey:@"isReviewed"];
    myInfo.TTscore = [userDic objectForKey:@"TTscore"];
    
    //    myInfo.id_DB = [userDic objectForKey:@"id"];
    myInfo.headImagePath = [NSString stringWithFormat:@"%@%@.png",imagePath,[userDic objectForKey:@"username"]];
    
    self.myUserInfo = myInfo;
    
    if ( [self.menuContainerViewController.leftMenuViewController isKindOfClass:[SideMenuViewController class]]) {
        
        
        SideMenuViewController *leftMenuVC = (SideMenuViewController *)self.menuContainerViewController.leftMenuViewController;
        
        NSURL *url = [NSURL URLWithString:[myInfo.headImagePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        UIImage *defaultHead;
        if ([myInfo.sex isEqualToString:@"male"])
        {
            defaultHead = [UIImage imageNamed:@"boy.png"];
            
        }else if([myInfo.sex isEqualToString:@"female"])
        {
            defaultHead = [UIImage imageNamed:@"girl.png"];
            
        }
        
        [leftMenuVC.headImage setImageWithURL:url placeholderImage:defaultHead];
        
        
        
        
        [leftMenuVC.usernameLabel setText:myInfo.username];
        [leftMenuVC.sexImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",myInfo.sex]]];
        [leftMenuVC.ageLabel setText:[NSString stringWithFormat:@"%@岁",myInfo.age]];
        
        NSMutableArray *favorArray = [[DataCenter sharedDataCenter] fetchFavors];
        NSString *favorString = @"关注";
        if (favorArray && favorArray.count>0)
        {
            favorString = [NSString stringWithFormat:@"关注(%lu)",(unsigned long)favorArray.count];
        }
        
    }
    
    NSLog(@"config user info");
}
//

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
}

-(void)uploadLocation
{
    
    if(![CLLocationManager locationServicesEnabled])
    {
        UIAlertView *alet = [[UIAlertView alloc] initWithTitle:@"错误" message:@"当前无法定位，请检查您的隐私设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alet show];
    }
    
    //    NSLog(@"uploadLocation");
    
}
-(void)cancelUploadLocation
{
    //    _radarManager = [BMKRadarManager getRadarManagerInstance];
    //    _locServer = [[BMKLocationService alloc] init];
    //    _locServer.delegate = self;
    //    [_locServer startUserLocationService];
    
    //    [_radarManager stopAutoUpload];
}

-(void)mapTapped:(UIButton *)sender
{
    if (sender.tag ==0) {
        
        [MobClick event:@"MapTap"];
        
        [sender setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        [self.navigationItem.rightBarButtonItem setCustomView:sender];
        
        sender.tag = 1;
        [UIView transitionFromView:self.listView
                            toView:self.mapView
                          duration:0.8
                           options:UIViewAnimationOptionTransitionFlipFromLeft                        completion:^(BOOL finished){
                               /* do something on animation completion */
                           }];
        
        //test
        [_mapView setCenterCoordinate:_myCoor];
        //        [_mapView setCenterCoordinate: CLLocationCoordinate2DMake(34.226, 108.886)];
        
        [_mapView setZoomLevel:13.5];
        
    }else
    {
        [sender setImage:[UIImage imageNamed:@"mid_ditu.png"] forState:UIControlStateNormal];
        [self.navigationItem.rightBarButtonItem setCustomView:sender];
        
        sender.tag = 0;
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
    
    
    NSLog(@"nearbyInfos  %@",nearbyInfos);
    
    
    
    [_nearbyInfos removeAllObjects];
    [_nearbyInfos addObjectsFromArray:nearbyInfos];
    
    [self.listView reloadData];
    [_mapView removeAnnotations:_mapView.annotations];
    NSMutableArray *annotations = [NSMutableArray array];
    for (NSDictionary *info in _nearbyInfos) {
        
        CLLocationCoordinate2D pt;
        pt.latitude = [[info objectForKey:@"latitude"] doubleValue];
        pt.longitude = [[info objectForKey:@"longitude"] doubleValue];
        
        myPointAnnotation *annotation = [[myPointAnnotation alloc] init];
        annotation.coordinate = pt;
        annotation.title = [info objectForKey:@"username"];
        annotation.annoUserDistance = [[info objectForKey:@"juli"] integerValue];
        annotation.annoUserSex = [info objectForKey:@"sex"];
        
        
        
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
    [_mapView setZoomLevel:9+((32 - self.radiusSlider.value)/2) ];
    NSLog(@"addAnnotations");
}


-(NSMutableArray *)makeDotaer:(NSDictionary *)dic
{
    NSArray * names = [dic objectForKey:@"username"];
    
    if (names.count>=50 ) {
        [self.pageForward setEnabled:YES];
    }else
    {
        [self.pageForward setEnabled:NO];
    }
    
    
    
    NSMutableArray *dotaerAray = [[NSMutableArray alloc] initWithCapacity:50];
    for (int i = 0; i<names.count; i++) {
        
        
        if ([[dic objectForKey:@"invisible"][i] isEqualToString:@"no"]) {
            NSDictionary *oneDotaer = @{
                                        @"username":[dic objectForKey:@"username"][i],
                                        @"age":[dic objectForKey:@"age"][i],
                                        @"sex":[dic objectForKey:@"sex"][i],
                                        @"juli":[dic objectForKey:@"juli"][i],
                                        @"latitude":[dic objectForKey:@"latitude"][i],
                                        @"longitude":[dic objectForKey:@"longitude"][i],
                                        @"invisible":[dic objectForKey:@"invisible"][i],
                                        @"isReviewed":[dic objectForKey:@"isReviewed"][i]};
            [dotaerAray addObject:oneDotaer];
            
        }
    }
    
    return dotaerAray;
    
}

-(void)updateValue:(UISlider *)sender{
    //添加响应事件
    
    
    if (sender.value<31) {
        _searchRadius = [FabonacciNum calculateFabonacci:sender.value];
        
        
        if (_searchRadius<1000) {
            self.distanceLabel.text = [NSString stringWithFormat:@"%d00米",(int)_searchRadius/100];
            
        }else if(_searchRadius>10000000)
        {
            self.distanceLabel.text = [NSString stringWithFormat:@"> 500KM"];
            
        }else
        {
            self.distanceLabel.text = [NSString stringWithFormat:@"%dKM",((int)_searchRadius/1000) +1];
            
        }
        
        
    }else
    {
        _searchRadius = 99999999;//无限远
        [self.distanceLabel setText:@"> 500KM"];
        
    }
    
    NSLog(@"Radius------%f",_searchRadius);
    
}

-(void)searchDotaer
{
    
    [MobClick event:@"searchDotaer"];
    
    _curPageIndex = 0;
    MBProgressHUD *hud2 = [MBProgressHUD showHUDAddedTo:self.containerView animated:YES];
    hud2.tag = 456;
    
    hud2.mode = MBProgressHUDModeText;
    hud2.labelText = @"正在搜索...";
    
    [hud2 hide:YES afterDelay:12];
    
    [self nearbySearchWithPageIndex:[NSNumber numberWithInteger:_curPageIndex]];
    
    
    
}

-(void)pageUp
{
    MBProgressHUD *hud2 = [MBProgressHUD showHUDAddedTo:self.containerView animated:YES];
    hud2.tag = 456;
    
    hud2.mode = MBProgressHUDModeText;
    hud2.labelText = @"正在搜索...";
    
    [hud2 hide:YES afterDelay:18];
    
    if (_curPageIndex > 0) {
        _curPageIndex--;
        [self nearbySearchWithPageIndex:[NSNumber numberWithInteger:_curPageIndex]];
    } else {
        [self.pageFront setEnabled:NO];
    }
    
    
}
-(void)pageDown
{
    MBProgressHUD *hud2 = [MBProgressHUD showHUDAddedTo:self.containerView animated:YES];
    hud2.tag = 456;
    
    hud2.mode = MBProgressHUDModeText;
    hud2.labelText = @"正在搜索...";
    
    [hud2 hide:YES afterDelay:18];
    
    _curPageIndex ++;
    [self nearbySearchWithPageIndex:[NSNumber numberWithInteger:_curPageIndex]];
    
    [self.pageForward setEnabled:YES];
    
    
    
}

- (void)nearbySearchWithPageIndex:(NSNumber *) pageIndex {
    
    if ((_myCoor.latitude > 0.001 || _myCoor.latitude < -0.001) && (_myCoor.longitude > 0.001 || _myCoor.longitude < -0.001)) {
        
        
        NSString *page = [NSString stringWithFormat:@"%@",pageIndex];
        NSString *ratio = [NSString stringWithFormat:@"%f",_searchRadius];
        
        
        NSString *lati = [NSString stringWithFormat:@"%f",_myCoor.latitude];
        NSString *longi = [NSString stringWithFormat:@"%f",_myCoor.longitude];
        
        NSDictionary *parameters = @{@"tag": @"getDistance",@"lat": lati,@"long": longi,@"ratio":ratio,@"page": page};
        
        
        
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [manager.requestSerializer setTimeoutInterval:30];
        
        
        [manager POST:positionURL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            
            for (UIView *hud  in [self.containerView subviews]) {
                if ([hud isKindOfClass:[MBProgressHUD class]]) {
                    MBProgressHUD *hudView = (MBProgressHUD *)hud;
                    [hudView hide:YES];
                }
            }
            
          
            
            
            if ([[responseObject objectForKey:@"noRecord"] isEqualToString:@"yes"]) {
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.containerView animated:YES];
                
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"没有搜到玩家，请加大搜索半径!";
                if (hud) {
                    [hud hide:YES afterDelay:1.0];
                    
                }
                
                
            }else
            {
                  [self.pageNumLabel setText:[NSString stringWithFormat:@"%d",_curPageIndex+1]];
                
                if (_curPageIndex<=0) {
                    [self.pageFront setEnabled:NO];
                    
                }else
                {
                    [self.pageFront setEnabled:YES];
                    
                }
                
                
                self.nearbyInfos = [self makeDotaer:responseObject];
                
                
                
                
                
            }
            NSLog(@"search result info: %@", responseObject);
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            for (UIView *hud  in [self.containerView subviews]) {
                if ([hud isKindOfClass:[MBProgressHUD class]]) {
                    MBProgressHUD *hudView = (MBProgressHUD *)hud;
                    [hudView hide:YES];
                }
            }
            NSLog(@"search result Error: %@", error.localizedDescription);
            NSLog(@"search result ERROR333: %@",  operation.responseString);
            
        }];
        
        
    }else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.containerView animated:YES];
        
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"定位失败, 请重试";
        if (hud) {
            [hud hide:YES afterDelay:1.0];
            
        }
        
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
    
    
    if (self.myUserInfo.username ) {
        
        [self uploadPostion];
        
    }
    
    
    
    
}

-(void)uploadPostion
{
    
    if (uploadPositionCount%30 != 0) {
        uploadPositionCount++;
        
        return;
    }
    
    uploadPositionCount++;
    
    
    if ((_myCoor.latitude > 0.001 || _myCoor.latitude < -0.001) && (_myCoor.longitude > 0.001 || _myCoor.longitude < -0.001)) {
        
        NSLog(@"updateMyLocation!!!!%f----%f",_myCoor.latitude,_myCoor.longitude);
        
        NSString *lati = [NSString stringWithFormat:@"%f",_myCoor.latitude];
        NSString *longi = [NSString stringWithFormat:@"%f",_myCoor.longitude];
        NSString *invis = [[NSUserDefaults standardUserDefaults] objectForKey:@"invisible"];
        
        NSDictionary *parameters = @{@"tag": @"uploadPosition",@"name":self.myUserInfo.username,@"lat": lati,@"long": longi,@"invisible": invis,@"isReviewed": self.myUserInfo.isReviewed,@"age": self.myUserInfo.age,@"sex":self.myUserInfo.sex,@"TTscore": @"888"};
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [manager.requestSerializer setTimeoutInterval:30];
        
        
        [manager POST:positionURL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            
            
            NSLog(@"position uploaded info: %@", responseObject);
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            uploadPositionCount = 0;
            NSLog(@"position uploaded Error: %@", error.localizedDescription);
            NSLog(@"JSON ERROR333: %@",  operation.responseString);
            
            
        }];
        
        
    }
    
    
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
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *info = [_nearbyInfos objectAtIndex:indexPath.row];
    cell.userInfo.text = [info objectForKey:@"username"];
    NSInteger distance = [[info objectForKey:@"juli"] integerValue];
    if(distance>1000)
    {
        cell.userDistance.text = [NSString stringWithFormat:@"%dKM", (int)distance/1000];
        
    }else
    {
        cell.userDistance.text = [NSString stringWithFormat:@"%d米", (int)distance];
    }
    
    NSString *headPath = [NSString stringWithFormat:@"%@%@.png",imagePath,[info objectForKey:@"username"]];
    
    NSURL *url = [NSURL URLWithString:[headPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *gender = [info objectForKey:@"sex"];
    NSString *age = [info objectForKey:@"age"];
    NSString *isReviewed = [info objectForKey:@"isReviewed"];
    
    
    if (gender && ![gender isEqualToString:@""]) {
        
        UIImage *defaultHead;
        if ([gender isEqualToString:@"male"])
        {
            defaultHead = [UIImage imageNamed:@"boy.png"];
            
        }else if([gender isEqualToString:@"female"])
        {
            defaultHead = [UIImage imageNamed:@"girl.png"];
            
        }
        
        [cell.userHead setImageWithURL:url placeholderImage:defaultHead];
        
        
        [cell.sexImage setImage:[UIImage imageNamed:gender]];
        [cell.ageLabel setText:[NSString stringWithFormat:@"%@岁",age]];
        if ([isReviewed isEqualToString:@"no"]) {
            [cell.confirmLevelImage setImage:[UIImage imageNamed:@"levelno"]];
            [cell.confirmLevelLabel setText:@"暂未认证"];
            [cell.confirmLevelLabel setTextColor:[UIColor colorWithRed:73/255.0f green:73/255.0f blue:73/255.0f alpha:1.0f]];
            [cell.scoreLabel setHidden:YES];
        }else
        {
            [cell.confirmLevelImage setImage:[UIImage imageNamed:@"levelyes"]];
            [cell.confirmLevelLabel setText:@"已认证"];
            [cell.confirmLevelLabel setTextColor:[UIColor colorWithRed:255/255.0f green:70/255.0f blue:0 alpha:1.0f]];
            //            [cell.scoreLabel setHidden:NO];
            //            [cell.scoreLabel setText:[NSString stringWithFormat:@"天梯:%@",userExtinfo[3] ]];
            
        }
    }
    
    
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [MobClick event:@"tapUser"];
    
    
    
    NSDictionary *info = [_nearbyInfos objectAtIndex:indexPath.row];
    
    CLLocationCoordinate2D pt;
    pt.latitude = [[info objectForKey:@"latitude"] doubleValue];
    pt.longitude = [[info objectForKey:@"longitude"] doubleValue];
    
    
    [self jumpToPlayer:[info objectForKey:@"username"] andDistance:[[info objectForKey:@"juli"] integerValue] andGeoInfo:pt];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    //
    [self updateMyLocation:userLocation];
    [lock lock];
    _curLocation.latitude = userLocation.location.coordinate.latitude;
    _curLocation.longitude = userLocation.location.coordinate.longitude;
    [lock unlock];
    //    NSLog(@"my Position:%f",_curLocation.latitude);
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
    MBProgressHUD *hud = (MBProgressHUD *)[self.containerView viewWithTag:345];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"定位失败";
    if (hud) {
        [hud hide:YES afterDelay:1.0];
        
    }
    NSLog(@"hud定位失败");
    //
    //    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //    NSString *doc = [NSString stringWithFormat:@"%@/22.txt",documentDir];
    //    NSLog(@"path:%@",doc);
    //    NSString *log = [NSString stringWithFormat:@"error:%@",error];
    //    NSError *error2;
    //
    //    [log writeToFile:doc atomically:YES encoding:NSUTF8StringEncoding error:&error2];
}

#pragma mark - BMKRadarManagerDelegate
/**
 *返回雷达 查询周边的用户信息结果
 *@param result 结果，类型为@see BMKRadarNearbyResult
 *@param error 错误号，@see BMKRadarErrorCode
 */
- (void)onGetRadarNearbySearchResult:(BMKRadarNearbyResult *)result error:(BMKRadarErrorCode)error {
    
    //    MBProgressHUD *hud = (MBProgressHUD *)[self.containerView viewWithTag:345];
    for (UIView *hud  in [self.containerView subviews]) {
        if ([hud isKindOfClass:[MBProgressHUD class]]) {
            MBProgressHUD *hudView = (MBProgressHUD *)hud;
            [hudView hide:YES];
        }
    }
    
    NSLog(@"onGetRadarNearbySearchResult  %d", error);
    if (error == BMK_RADAR_NO_ERROR) {
        NSLog(@"result.infoList.count:  %d", (int)result.infoList.count);
        
        
        //
        //        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        //        [manager.requestSerializer setTimeoutInterval:12];  //Time out after 25 seconds
        
        //        for (BMKRadarNearbyInfo *userInfo in result.infoList) {
        //            NSString *lat =[NSString stringWithFormat:@"%f",userInfo.pt.latitude];
        //            NSString *lon =[NSString stringWithFormat:@"%f",userInfo.pt.longitude];
        //            NSString *name = userInfo.userId;
        //            NSString *ext = userInfo.extInfo;
        //            NSArray *extArray = [ext componentsSeparatedByString:@"-"];
        //            if (extArray.count>4) {
        //                NSString *sex = extArray[0];
        //                NSString *age = extArray[1];
        //                NSString *isReviewd = extArray[2];
        //                NSString *TTscore = extArray[3];
        //                NSString *isvisible = extArray[4];
        //
        //
        //                NSDictionary *parameters = @{@"tag": @"trans",@"name":name,@"lat":lat,@"long":lon,@"invisible":isvisible,@"isReviewed":isReviewd,@"age":age,@"sex":sex,@"TTscore":TTscore};
        //
        
        //                [manager POST:@"http://localhost/~ericcao/position.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        //                    NSLog(@"topic Json: %@", responseObject);
        //
        //
        //
        //
        //                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //                    NSLog(@"topic JsonError: %@", error.localizedDescription);
        //                    NSLog(@"topic Json ERROR: %@",  operation.responseString);
        //
        //
        //
        //
        //
        //                }];
        
        
        
        //            }
        
        
        //        }
        
        NSMutableArray *tempArray =[NSMutableArray arrayWithArray:result.infoList];
        NSMutableArray *destArray = [[NSMutableArray alloc] init];
        for (BMKRadarNearbyInfo *info in tempArray) {
            NSArray *userExtinfo = [info.extInfo componentsSeparatedByString:@"-"];
            if (userExtinfo.count>4) {
                if (![userExtinfo[4] isEqualToString:@"yes"])
                {
                    [destArray addObject:info];
                    
                }
                
            }
        }
        
        self.nearbyInfos = destArray;
        
        
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
        
        [self.pageNumLabel setText:[NSString stringWithFormat:@"%d",_curPageIndex+1]];
        
        
    }else if (error == BMK_RADAR_NETWOKR_ERROR || error == BMK_RADAR_NETWOKR_TIMEOUT || error == BMK_RADAR_PERMISSION_UNFINISHED)
    {
        UIAlertView *alet = [[UIAlertView alloc] initWithTitle:@"错误" message:@"当前网络不稳定，请重新搜索" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alet show];
    }else if (error == BMK_RADAR_NO_RESULT)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.containerView animated:YES];
        
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"没有找到...";
        
        [hud hide:YES afterDelay:2.0];
        
        self.nearbyInfos = nil;
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
    
    double factor = annoRatio;
    
    if (IS_IPHONE_5)
    {
        factor = annoRatio *1.2;
    }else if (IS_IPHONE_6)
    {
        factor = annoRatio *1.3;
    }else if (IS_IPHONE_6P)
    {
        factor = annoRatio *1.4;
    }
    
    UIView *viewForImage;
    UIImageView *imageview;
    
    if ([annotationView viewWithTag:111]) {
        viewForImage = [annotationView viewWithTag:111];
        imageview = (UIImageView *)[viewForImage viewWithTag:101];
        if ([imageview viewWithTag:102]) {
            [[imageview viewWithTag:102] removeFromSuperview];
        }
        if ([imageview viewWithTag:103]) {
            [[imageview viewWithTag:103] removeFromSuperview];
        }
    }else
    {
        viewForImage =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 112*factor, 144*factor)];
        UIImageView *backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 112*factor, 144*factor)];
        [backImageView setImage:[UIImage imageNamed:@"MapAnnotationBG"]];
        
        imageview = [[UIImageView alloc]initWithFrame:CGRectMake(8*factor, 8*factor, 96*factor, 96*factor)];
        
        imageview.tag =101;
        
        [viewForImage addSubview:backImageView];
        [viewForImage addSubview:imageview];
        
        viewForImage.tag = 111;
    }
    
    
    
    
    
    
    if ([annotation isKindOfClass:[myPointAnnotation class]]) {
        
        
        myPointAnnotation *anno = (myPointAnnotation *)annotation;
        NSString *headPath = [NSString stringWithFormat:@"%@%@.png",imagePath,anno.title];
        
        NSLog(@"anno.title---%@",anno.title);
        
        NSURL *url = [NSURL URLWithString:[headPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        UIImage *defaultHead;
        if ([anno.annoUserSex isEqualToString:@"male"])
        {
            defaultHead = [UIImage imageNamed:@"boy.png"];
            
        }else if([anno.annoUserSex isEqualToString:@"female"])
        {
            defaultHead = [UIImage imageNamed:@"girl.png"];
            
        }
        
        [imageview setImageWithURL:url placeholderImage:defaultHead ];
        //        [imageview setImageWithURL:url placeholderImage:defaultHead ];
        //        [imageview setImageWithURLRequest:[NSURLRequest requestWithURL:url]
        //                         placeholderImage:defaultHead
        //                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        //
        //                                      UIImageView *imageview2=[[UIImageView alloc]initWithFrame:CGRectMake(8*factor, 8*factor, 96*factor, 96*factor)];
        //                                      [viewForImage addSubview:imageview2];
        //                                      [imageview2 setImage:image];
        //
        //                                      annotationView.image = [self getImageFromView:viewForImage];
        //                                  }
        //                                  failure:nil];
        //
        
        
        
        
        //        NSData *data = [NSData dataWithContentsOfURL:url];
        //        NSData *data = [NSData data];
        //
        //        UIImage *img = [[UIImage alloc] initWithData:data];
        //        if (img) {
        //            [imageview setImage:img];
        //
        //        }
        
        if (anno.containUsers.count>0) {
            
            
            
            UIImageView *countBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(112*factor-6-15, 112*factor-6-15, 15, 15)];
            [countBackImage setImage:[UIImage imageNamed:@"MapUserCountBG"]];
            countBackImage.tag = 102;
            
            [imageview addSubview:countBackImage];
            
            UILabel *userCount = [[UILabel alloc] initWithFrame:CGRectMake(112*factor-6-14, 112*factor-6-13, 16, 16)];
            userCount.textAlignment = NSTextAlignmentCenter;
            [userCount setText:[NSString stringWithFormat:@"%lu",anno.containUsers.count + 1 ]];
            userCount.font = [UIFont boldSystemFontOfSize:8.2f];
            userCount.tag = 103;
            
            [imageview addSubview:userCount];
        }
    }
    
    
    //    BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:viewForImage];
    //    pView.frame = CGRectMake(0, 0, 112*factor, 144*factor);
    //    ((BMKPinAnnotationView*)annotationView).paopaoView = nil;
    //    ((BMKPinAnnotationView*)annotationView).paopaoView = pView;
    
    //    annotationView.image=[self getImageFromView:viewForImage];
    //    annotationView.image= [self imageByScaling:imageview.image ProportionallyToSize:imageview.frame.size];
    //    annotationView.contentMode = UIViewContentModeScaleToFill;
    //    [annotationView sizeToFit];
    annotationView.image = nil;
    [annotationView setFrame:viewForImage.frame];
    
    if ([annotationView viewWithTag:111]) {
        
    }else
    {
        [annotationView addSubview: viewForImage];
    }
    
    NSLog(@"viewForAnnotation");
    
    return annotationView;
    
}

- (UIImage *)imageByScaling:(UIImage *)sourceImage ProportionallyToSize:(CGSize)targetSize {
    
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
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
    [MobClick event:@"annoTap"];
    
    myPointAnnotation *anno;
    if ([view.annotation isKindOfClass:[myPointAnnotation class]]) {
        anno = (myPointAnnotation *)view.annotation;
    }
    
    if (anno.containUsers.count>0)
    {
        favorViewController * allUserVC = [[favorViewController alloc] initWithNibName:@"favorViewController" bundle:nil];
        allUserVC.isFromFavor = NO;
        allUserVC.distance = anno.annoUserDistance;
        allUserVC.userPosition = anno.coordinate;
        allUserVC.favorArray = [NSMutableArray arrayWithObjects:anno.title, nil];
        for (myPointAnnotation *tempAnno in anno.containUsers) {
            [allUserVC.favorArray addObject:tempAnno.title];
        }
        
        [self.navigationController pushViewController:allUserVC animated:YES];
        
    }else
    {
        [self jumpToPlayer:anno.title andDistance:anno.annoUserDistance andGeoInfo:anno.coordinate];
        
    }
    
    [_mapView deselectAnnotation:view.annotation animated:YES];
    
}


-(void)jumpToPlayer:(NSString *)playerName andDistance:(NSUInteger)distance andGeoInfo:(CLLocationCoordinate2D)position
{
    playerPageViewController *playInfo = [[playerPageViewController alloc] initWithNibName:@"playerPageViewController" bundle:nil];
    
    playInfo.playerName = playerName;
    playInfo.distance = distance;
    playInfo.userPosition = position;
    
    [self.navigationController pushViewController:playInfo animated:YES];
    
    
}

#pragma mark TTscore delegate
-(void)fillTTScore:(NSString *)score
{
    self.myUserInfo.TTscore = score;
    self.myUserInfo.isReviewed = @"yes";
    
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoDic"]];
    
    if (![score isKindOfClass:[NSNull class]] && ![score isEqualToString:@""])
    {
        
        [userDic setObject:score forKey:@"TTscore"];
        [userDic setObject:@"yes" forKey:@"isReviewed"];
        
        [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:@"userInfoDic"];
    }
    
    
}
- (void) dealloc {
    self.mapView.delegate = nil; // 不用时，置nil
    _locServer.delegate = nil;
    _locServer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _mapView = nil;
}


- (BOOL)shouldAutorotate {
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; // your own style
}

- (BOOL)prefersStatusBarHidden {
    return NO; // your own visibility code
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView

{
    NSLog(@"ad received");
}
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"error AD .. %@",error);
}
@end
