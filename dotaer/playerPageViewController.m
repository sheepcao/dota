//
//  playerPageViewController.m
//  dotaer
//
//  Created by Eric Cao on 7/16/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "playerPageViewController.h"
#import "globalVar.h"
#import "noteTableViewCell.h"
#import "achieveTableViewCell.h"
#import "AFHTTPRequestOperationManager.h"
//#import "levelInfoViewController.h"
#import "AFURLSessionManager.h"
#import "DataCenter.h"

#import "submitScoreViewController.h"
#import "scoreSearchViewController.h"
#import "testSearchViewController.h"
#import "popView.h"

@interface playerPageViewController ()<UITextFieldDelegate,BMKGeoCodeSearchDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) UITextField *invisibleTextFiled;

@property (nonatomic,strong) NSMutableDictionary *NoteInfoDic;
@property (nonatomic,strong) NSMutableArray *notesArray;
@property (nonatomic,strong) NSMutableArray *visitorArray;
@property (nonatomic,strong) NSMutableArray *createTimeArray;

@property (nonatomic,strong) NSDictionary *JJCinfoDic;
@property (nonatomic,strong) NSDictionary *TTinfoDic;
@property (nonatomic,strong) NSDictionary *MJinfoDic;
@property (nonatomic,strong) NSDictionary *AllinfoDic;

@property (nonatomic,strong) NSMutableDictionary *playerLevelInfoDic;

@property (nonatomic,strong) NSMutableDictionary *cellDic;


@property (nonatomic,strong) BMKGeoCodeSearch *geocodesearch;


@property (nonatomic, strong) NSString *loginURL;

@property (nonatomic, strong) NSString *VIEWSTATEGENERATOR ;
@property (nonatomic, strong) NSString *VIEWSTATE;
@property (nonatomic, strong) NSString *EVENTVALIDATION;


@property (nonatomic, strong) popView *PopAlert;
@end

@implementation playerPageViewController
@synthesize loginURL;
@synthesize VIEWSTATEGENERATOR;
@synthesize VIEWSTATE;
@synthesize EVENTVALIDATION;




@synthesize geocodesearch;
@synthesize contentView;
@synthesize invisibleTextFiled;

bool needRefresh;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    needRefresh = NO;
    [self.navigationController.navigationItem.backBarButtonItem setTitle:@"附近"];
    self.title = self.playerName;
    
    self.cellDic = [[NSMutableDictionary alloc] init];
    
    if(![[DataCenter sharedDataCenter] isGuest] && [[[[NSUserDefaults standardUserDefaults]  objectForKey:@"userInfoDic"] objectForKey:@"username"] isEqualToString:self.playerName])
    {
//        [self.ageLabel setFrame:CGRectMake(251, 47, 42, 31)];
//        [self.sexImage setFrame:CGRectMake(35, 57, 19, 22)];
        
        self.title = @"个人主页";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"绑定变更" style:UIBarButtonItemStylePlain target:self action:@selector(updateLevel)];
        [self.favorBtn setHidden:YES];
        [self.distanceImage setHidden:YES];
        [self.distanceLabel setHidden:YES];
        [self.addressLabel setHidden:YES];



    }else
    {
        
      
        
        self.favorBtn.layer.cornerRadius = 4.2f;
        self.favorBtn.layer.shadowOffset = CGSizeMake(0.2, 0.2);
        self.favorBtn.layer.shadowRadius = 0.5;
        self.favorBtn.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.favorBtn.layer.shadowOpacity = 0.4;
        self.favorBtn.layer.borderWidth = 1.0;
        self.favorBtn.layer.borderColor = [UIColor colorWithRed:255/255.0f green:145/255.0f blue:0 alpha:1.0].CGColor;

        [self.favorBtn setHidden:NO];
        [self.distanceImage setHidden:NO];
        [self.distanceLabel setHidden:NO];
        [self.addressLabel setHidden:NO];
        
       if( [[DataCenter sharedDataCenter] checkFavor:self.playerName])
       {
           [self.favorBtn setTitle:@"已关注" forState:UIControlStateNormal];
           [self.favorBtn setBackgroundColor:[UIColor colorWithRed:49/255.0f green:185/255.0f blue:163/255.0f alpha:1.0f]];
       }else
       {
           [self.favorBtn setTitle:@"+关注" forState:UIControlStateNormal];
           [self.favorBtn setBackgroundColor:[UIColor colorWithRed:255/255.0f green:55/255.0f blue:28/255.0f alpha:1.0f]];

       }
        

    }
    
    self.blurView.blurRadius = 7.0f;
    self.headImage.layer.cornerRadius = 49.0f;
    self.headImage.layer.masksToBounds = YES;
    self.notConfirmLevel.layer.cornerRadius = 4.5f;
    self.notConfirmLevel.layer.shadowOffset = CGSizeMake(1.5, 1.8);
    self.notConfirmLevel.layer.shadowRadius = 0.5;
    self.notConfirmLevel.layer.shadowOpacity = 0.4;

    self.visitorArray = nil;
    self.createTimeArray = nil;
    self.notesArray = nil;
    //for custom text view
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDismiss:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self initCustomTextViewWithY:SCREEN_HEIGHT];


    
    [self requestReverseGeocode];
    
    

    
    [self requestPlayerInfo];

    
    
}


-(void)popValidationCodeWithImage:(UIImage *)img
{

    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"popView"
                            
                                                         owner:nil                                                               	options:nil];
    
    self.PopAlert= 	(popView *)[nibContents objectAtIndex:0];
    [self.PopAlert roundBack];
    
    [self.PopAlert.codeImage setBackgroundImage:img forState:UIControlStateNormal];
    [self.PopAlert setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT+50)];
    [self.view addSubview:self.PopAlert];
    
    [UIView animateWithDuration:0.45 delay:0.05 usingSpringWithDamping:1.0 initialSpringVelocity:0.4 options:0 animations:^{
        [self.PopAlert setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-100)];
    } completion:nil];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(needRefresh)
    {
        [self requestPlayerInfo];
        needRefresh = NO;
    }

}

-(void)requestReverseGeocode
{
    geocodesearch =[[BMKGeoCodeSearch alloc]init];
    geocodesearch.delegate = self;
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = self.userPosition;
    BOOL flag = [geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}

#pragma mark reverseGeo delegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{

    if (error == 0) {
        
        NSString *streetName = result.addressDetail.streetName;
        NSString *district = result.addressDetail.district;
        NSString *city = result.addressDetail.city;
        
        NSString *address = [NSString stringWithFormat:@"%@,%@\n%@",city,district,streetName];
        [self.addressLabel setText:address];
        
    }else
    {
        NSLog(@"error geo reverse%u",error);
    }
}

- (void)updateLevel {

    [self.view endEditing:YES];// this will do the trick

    
//    levelInfoViewController *levelInfo = [[levelInfoViewController alloc] initWithNibName:@"levelInfoViewController" bundle:nil];
//
    submitScoreViewController *levelInfo = [[submitScoreViewController alloc] initWithNibName:@"submitScoreViewController" bundle:nil];
    
    [self presentViewController:levelInfo animated:YES completion:nil];
    needRefresh = YES;
}


-(void)requestPlayerInfo
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.tag = 123;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
    
    NSDictionary *parameters = @{@"tag": @"playerInfo",@"name":self.playerName};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30];
    
    
    [manager POST:playerInfoService parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        

        NSLog(@"JSON player info: %@", responseObject);
        
        [self setupPageWithDic:responseObject withHUD:hud];
        

        

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR2222: %@",  operation.responseString);
        
        [hud hide:YES];
        
        
        UIView *noRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.infoTableView.frame.size.width, self.infoTableView.frame.size.height)];
        noRecordView.tag = 666;

        UILabel *noRecordLabel = [[UILabel alloc] initWithFrame:noRecordView.frame];
        [noRecordLabel setText:@"暂未战绩认证"];
        [noRecordLabel setTextColor:[UIColor colorWithRed:21/255.0f green:21/255.0f blue:21/255.0f alpha:1.0f]];
        noRecordLabel.textAlignment = NSTextAlignmentCenter;
        [noRecordLabel setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *backIMG = [[UIImageView alloc] initWithFrame:noRecordView.frame];
        [backIMG setImage:[UIImage imageNamed:@"mainBack.png"]];
        
//        UIVisualEffect *blurEffect;
//        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        UIVisualEffectView *visualEffectView2;
//        visualEffectView2 = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        visualEffectView2.frame = backIMG.bounds;
//        [backIMG addSubview:visualEffectView2];
//        NSLog(@"6666666");

        [noRecordView addSubview:backIMG];
        [noRecordView addSubview:noRecordLabel];
        
        [self.infoTableView addSubview:noRecordView];
        
        
        
        [self.notConfirmLevel setHidden:YES];

//        
//        UILabel *noNoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, self.infoTableView.frame.size.width, self.infoTableView.frame.size.height-35) ];
//        [noNoteLabel setText:@"暂无留言"];
//        noNoteLabel.tag = 555;
//        noNoteLabel.textAlignment = NSTextAlignmentCenter;
//        [noNoteLabel setBackgroundColor:[UIColor whiteColor]];
//        
//        [self.notePadTable addSubview:noNoteLabel];
        
        UIAlertView *alet = [[UIAlertView alloc] initWithTitle:@"错误" message:@"网络请求失败，请检查您的网络状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alet show];
        

        
    }];
    

}


-(void)setupPageWithDic:(NSDictionary *)dic withHUD:(MBProgressHUD *)hud
{
//    NSString *headPath = [imagePath stringByAppendingString:self.playerName];
    NSString *headPath = [NSString stringWithFormat:@"%@%@.png",imagePath,self.playerName];

    NSURL *url = [NSURL URLWithString:[headPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    UIImage *defaultHead;
    if ([[dic objectForKey:@"sex"] isEqualToString:@"male"])
    {
        defaultHead = [UIImage imageNamed:@"boy.png"];
        
    }else if([[dic objectForKey:@"sex"] isEqualToString:@"female"])
    {
        defaultHead = [UIImage imageNamed:@"girl.png"];
        
    }
    
    [self.headImage setImageWithURL:url placeholderImage:defaultHead];


    
    [self.ageLabel setText:[NSString stringWithFormat:@"%@岁",[dic objectForKey:@"age"]]];
    [self.sexImage setImage:[UIImage imageNamed:[dic objectForKey:@"sex"]]];
  
    if(self.distance>1000)
    {
        [self.distanceLabel setText:[NSString stringWithFormat:@"%ldKM",(unsigned long)self.distance/1000]];

    }else
    {
          [self.distanceLabel setText:[NSString stringWithFormat:@"%ld米",(unsigned long)self.distance]];
    }
    
    if ([[dic objectForKey:@"content"] isKindOfClass:[NSNull class]] || [[dic objectForKey:@"content"] isEqualToString:@"编辑个人签名..."]) {
        [self.signatureLabel setText:@"签名的力气都用去打dota了!"];

    }else
    {
        [self.signatureLabel setText:[dic objectForKey:@"content"]];
    }

    
    //level info...
    
    
    UIView *noRecordView = [self.infoTableView viewWithTag:666];
    if (noRecordView) {
        [noRecordView removeFromSuperview];
    }
    
//
    if ( [[dic objectForKey:@"isReviewed"] isKindOfClass:[NSNull class]] || [[dic objectForKey:@"isReviewed"] isEqualToString:@"no"]) {
       
        UIView *noRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.infoTableView.frame.size.width, self.infoTableView.frame.size.height)];
        noRecordView.tag = 666;
        
        UILabel *noRecordLabel = [[UILabel alloc] initWithFrame:noRecordView.frame];
        [noRecordLabel setText:@"暂未战绩认证"];
        [noRecordLabel setTextColor:[UIColor colorWithRed:21/255.0f green:21/255.0f blue:21/255.0f alpha:1.0f]];
        noRecordLabel.textAlignment = NSTextAlignmentCenter;
        [noRecordLabel setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *backIMG = [[UIImageView alloc] initWithFrame:noRecordView.frame];
        [backIMG setImage:[UIImage imageNamed:@"mainBack.png"]];
//        


        [noRecordView addSubview:backIMG];
        [noRecordView addSubview:noRecordLabel];
        
        [self.infoTableView addSubview:noRecordView];
        
        [self.ttBtn setEnabled:NO];
        [self.jjcBtn setEnabled:NO];
        [self.mjBtn setEnabled:NO];
//        [self.infoTableView setScrollEnabled:NO];
        
        [self.notConfirmLevel setHidden:YES];
        
        if(![[DataCenter sharedDataCenter] isGuest] && [[[[NSUserDefaults standardUserDefaults]  objectForKey:@"userInfoDic"] objectForKey:@"username"] isEqualToString:self.playerName])
        {
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"战绩认证" style:UIBarButtonItemStylePlain target:self action:@selector(updateLevel)];
        }
        
        [hud hide:YES];

        
    }else
    {
        [self.ttBtn setEnabled:YES];
        [self.jjcBtn setEnabled:YES];
        [self.mjBtn setEnabled:YES];
        [self.ttBtn setSelected:YES];

//        [self.infoTableView setScrollEnabled:YES];

        
        if(![[DataCenter sharedDataCenter] isGuest] && [[[[NSUserDefaults standardUserDefaults]  objectForKey:@"userInfoDic"] objectForKey:@"username"] isEqualToString:self.playerName])
        {
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"绑定变更" style:UIBarButtonItemStylePlain target:self action:@selector(updateLevel)];
        }
        
        [self.notConfirmLevel setHidden:YES];
        self.playerLevelInfoDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        

//        [self requestExtroInfoWithUser:[dic objectForKey:@"gameName"]];
        [self requestGamerID:[dic objectForKey:@"gameName"]];


//        
//        
//        self.JJCinfoDic = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"JJCinfo"]];
//        self.TTinfoDic = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"TTinfo"]];
//        self.MJinfoDic = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"MJinfo"]];
//        [self.infoTableView reloadData];
    }
//
//
//        
////        [self.gameIDLabel setText:@"ID:不是故意的啥了"];
//        [self.gameIDLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"gameID"]]];
//
//        [self.JJCLabel setText:[dic objectForKey:@"JJCscore"]];
//        [self.TTLabel setText:[dic objectForKey:@"TTscore"]];
//        [self.soldierLabel setText:[dic objectForKey:@"soldier"]];
//        [self.ratioLabel setText:[NSString stringWithFormat:@"%@%%",[dic objectForKey:@"WinRatio"]]];
//        [self.heroFirstLabel setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[dic objectForKey:@"heroFirst"] ofType:@"jpg"]]];
//        [self.heroSecondLabel setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[dic objectForKey:@"heroSecond"] ofType:@"jpg"]]];
//        [self.heroThirdLabel setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[dic objectForKey:@"heroThird"] ofType:@"jpg"]]];
//    }
    
    
    if(![[DataCenter sharedDataCenter] isGuest] && [[[[NSUserDefaults standardUserDefaults]  objectForKey:@"userInfoDic"] objectForKey:@"username"] isEqualToString:self.playerName])
    {
        [self.ageLabel setFrame:CGRectMake(self.headImage.frame.origin.x+self.headImage.frame.size.width + 30, 51, 42, 31)];
        [self.sexImage setFrame:CGRectMake(self.headImage.frame.origin.x - 30 -19, 55, 19, 22)];
    }else
    {
        if(self.distance == -1)
        {
            [self.ageLabel setFrame:CGRectMake(self.headImage.frame.origin.x+self.headImage.frame.size.width + 30, 45, 42, 31)];
            [self.sexImage setFrame:CGRectMake(self.headImage.frame.origin.x - 30-19, 37, 19, 22)];
            [self.distanceImage setHidden:YES];
            [self.distanceLabel setHidden:YES];
            [self.addressLabel setHidden:YES];
        }
    }
    
    
}

#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    if (tableView == self.notePadTable) {
        return 60;
    }else
    {
        return tableView.frame.size.height;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.notePadTable) {
        return 35;
    }else
    {
        return 0;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
 
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView             // Default is 1 if not implemented
{
    return 1;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section   // fixed font style. use custom view (UILabel) if you want something different
//{
//    return @"留言板";
//}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.notePadTable) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 1, 60, 28)];
        title.backgroundColor = [UIColor clearColor];
        title.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];
        title.textColor = [UIColor colorWithRed:20/255.0f green:20/255.0f blue:20/255.0f alpha:1.0];
        [title setText:@"留言板"];
        
        
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-75, 3.5, 55, 25)];
        [btn setBackgroundImage:[UIImage imageNamed:@"listButton.png"] forState:UIControlStateNormal];
//        btn.backgroundColor = [UIColor purpleColor];
//        btn.layer.cornerRadius = 4.2f;
//        btn.layer.shadowOffset = CGSizeMake(1.5, 1.8);
//        btn.layer.shadowRadius = 0.5;
//        btn.layer.shadowOpacity = 0.4;
        
        btn.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];
        [btn setTitle:@"留言" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(leaveMesg) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
        [sectionView setBackgroundColor:[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0]];
        
//        UIImageView *backImg = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"blackBack.png"]];
//        
//        [backImg setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
//        
//        [sectionView addSubview:backImg];
        [sectionView addSubview:btn];
        [sectionView addSubview:title];
        
        
        if(![[DataCenter sharedDataCenter] isGuest] && [[[[NSUserDefaults standardUserDefaults]  objectForKey:@"userInfoDic"] objectForKey:@"username"] isEqualToString:self.playerName])
        {
            [btn setHidden:YES];
        }else
        {
            [btn setHidden:NO];

        }
        
        return sectionView;
    }else
    {
        UIView *tet = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1.5)];
        [tet setBackgroundColor:[UIColor colorWithRed:1 green:152/255.0f blue:25/255.0f alpha:1.0]];
        return tet;
    }

}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.notePadTable) {
        return self.notesArray.count;
    }else
    {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.notePadTable) {
        
        noteTableViewCell *cell =(noteTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"noteCell"];
        if (nil == cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"noteTableViewCell" owner:self options:nil] objectAtIndex:0];//加载nib文件
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        cell.backgroundColor = [UIColor clearColor];
        
        cell.usernameLabel.text = self.visitorArray[indexPath.row];
        cell.noteTextLabel.text = self.notesArray[indexPath.row];
        
        NSArray *timeArray = [self.createTimeArray[indexPath.row] componentsSeparatedByString:@":"];
        if (timeArray.count == 3) {
            NSString *timeCreated = [[timeArray[0] stringByAppendingString:@":"] stringByAppendingString:timeArray[1]];
            cell.noteTimeLabel.text = timeCreated;
            
        }
        
        NSString *headPath = [NSString stringWithFormat:@"%@%@.png",imagePath,self.visitorArray[indexPath.row]];

        NSURL *url = [NSURL URLWithString:[headPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        [cell.userHeadImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultHead.png"]];


        
        [cell.cellNumber setText:[NSString stringWithFormat:@"%u.",self.notesArray.count - indexPath.row]];
        
        if (![self.visitorArray[indexPath.row] isEqualToString: @"匿名游客"]) {
            cell.visitorDetailBtn.tag = indexPath.row;
            [cell.visitorDetailBtn addTarget:self action:@selector(visotorDetail:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.replyBtn.tag = indexPath.row + 100;
        [cell.replyBtn addTarget:self action:@selector(replyNote:) forControlEvents:UIControlEventTouchUpInside];

        
        
        
        return cell;
    
    }else
    {
        UITableViewCell *cell;
        
        if (indexPath.row == 3)
        {
            

            
            cell = [tableView dequeueReusableCellWithIdentifier:@"SysCell"];
            
            if( cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SysCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                self.notePadTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.infoTableView.frame.size.width, self.infoTableView.frame.size.height) style:UITableViewStylePlain];
                
                self.notePadTable.allowsSelection = NO;
                self.notePadTable.separatorStyle = UITableViewCellSeparatorStyleNone;
                self.notePadTable.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1.0f];
                
                self.notePadTable.delegate = self;
                self.notePadTable.dataSource =self;
                
                [cell addSubview:self.notePadTable];
                [self fetchNote];

                
            }
            
            
            

        }else
        {
            achieveTableViewCell *achieveCell =(achieveTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"achieveTableViewCell"];
            if (nil == achieveCell)
            {
                achieveCell = [[[NSBundle mainBundle]loadNibNamed:@"achieveTableViewCell" owner:self options:nil] objectAtIndex:0];//加载nib文件
                achieveCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [achieveCell.gameNameLabel setText:[self.playerLevelInfoDic objectForKey:@"gameName"]];
            if (indexPath.row == 0) {
                
                
                UIView *noRecordView = [achieveCell viewWithTag:888];
                if (noRecordView) {
                    [noRecordView removeFromSuperview];
                }
                if ([[self.AllinfoDic objectForKey:@"ttInfos"] isKindOfClass:[NSNull class]] || ![self.AllinfoDic objectForKey:@"rating"]) {
                    
                    UIView *noRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.infoTableView.frame.size.width, self.infoTableView.frame.size.height)];
                    noRecordView.tag = 888;
                    
                    UILabel *noRecordLabel = [[UILabel alloc] initWithFrame:noRecordView.frame];
                    [noRecordLabel setText:@"暂未战斗"];
                    [noRecordLabel setTextColor:[UIColor colorWithRed:21/255.0f green:21/255.0f blue:21/255.0f alpha:1.0f]];
                    noRecordLabel.textAlignment = NSTextAlignmentCenter;
                    [noRecordLabel setBackgroundColor:[UIColor clearColor]];
                    
                    UIImageView *backIMG = [[UIImageView alloc] initWithFrame:noRecordView.frame];
                    [backIMG setImage:[UIImage imageNamed:@"mainBack.png"]];
                    

                    [noRecordView addSubview:backIMG];
                    [noRecordView addSubview:noRecordLabel];
                    
                    [achieveCell addSubview:noRecordView];
                    

                }else
                {
                    
                    
                    [achieveCell.scoreType setText:@"天梯积分"];
                    [achieveCell.scoreLabel setText:[NSString stringWithFormat:@"%d",[[self.AllinfoDic objectForKey:@"rating"] intValue]]];
                    [achieveCell.totalGameLabel setText:[NSString stringWithFormat:@"%d",[[self.TTinfoDic objectForKey:@"Total"] intValue]]];
                    [achieveCell.mvpLabel setText:[NSString stringWithFormat:@"%d",[[self.TTinfoDic objectForKey:@"MVP"] intValue]]];
                    [achieveCell.pianjiangLabel setText:[NSString stringWithFormat:@"%d",[[self.TTinfoDic objectForKey:@"PianJiang"] intValue]]];
                    [achieveCell.podiLabel setText:[NSString stringWithFormat:@"%d",[[self.TTinfoDic objectForKey:@"PoDi"] intValue]]];
                    [achieveCell.pojunLabel setText:[NSString stringWithFormat:@"%d",[[self.TTinfoDic objectForKey:@"PoJun"] intValue]]];
                    [achieveCell.yinghunLabel setText:[NSString stringWithFormat:@"%d",[[self.TTinfoDic objectForKey:@"YingHun"] intValue]]];
                    [achieveCell.buwangLabel setText:[NSString stringWithFormat:@"%d",[[self.TTinfoDic objectForKey:@"BuWang"] intValue]]];
                    [achieveCell.fuhaoLabel setText:[NSString stringWithFormat:@"%d",[[self.TTinfoDic objectForKey:@"FuHao"] intValue]]];
                    [achieveCell.doubleKillLabel setText:[NSString stringWithFormat:@"%d",[[self.TTinfoDic objectForKey:@"DoubleKill"] intValue]]];
                    [achieveCell.tripleKillLabel setText:[NSString stringWithFormat:@"%d",[[self.TTinfoDic objectForKey:@"TripleKill"] intValue]]];
                    [achieveCell.winRatioLabel setText:[self.TTinfoDic objectForKey:@"R_Win"]];
                    
                    
                    [achieveCell.heroFirstImg setImageWithURL:[self loadheroImg:[self.TTinfoDic objectForKey:@"AdeptHero1"]]];
                    [achieveCell.heroSecondImg setImageWithURL:[self loadheroImg:[self.TTinfoDic objectForKey:@"AdeptHero2"]]];
                    [achieveCell.heroThirdImg setImageWithURL:[self loadheroImg:[self.TTinfoDic objectForKey:@"AdeptHero3"]]];
                    
                    [achieveCell.heroDetailButton addTarget:self action:@selector(heroDetail:) forControlEvents:UIControlEventTouchUpInside];
                    
 
                }

            }else if(indexPath.row == 1)
            {

                UIView *noRecordView = [achieveCell viewWithTag:888];
                if (noRecordView) {
                    [noRecordView removeFromSuperview];
                }
                if ([[self.AllinfoDic objectForKey:@"jjcInfos"] isKindOfClass:[NSNull class]] || ![self.AllinfoDic objectForKey:@"jjcRating"]) {
                    
                    UIView *noRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.infoTableView.frame.size.width, self.infoTableView.frame.size.height)];
                    noRecordView.tag = 888;
                    
                    UILabel *noRecordLabel = [[UILabel alloc] initWithFrame:noRecordView.frame];
                    [noRecordLabel setText:@"暂未战斗"];
                    [noRecordLabel setTextColor:[UIColor colorWithRed:21/255.0f green:21/255.0f blue:21/255.0f alpha:1.0f]];
                    noRecordLabel.textAlignment = NSTextAlignmentCenter;
                    [noRecordLabel setBackgroundColor:[UIColor clearColor]];
                    
                    UIImageView *backIMG = [[UIImageView alloc] initWithFrame:noRecordView.frame];
                    [backIMG setImage:[UIImage imageNamed:@"mainBack.png"]];
                    
//                    UIVisualEffect *blurEffect;
//                    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//                    UIVisualEffectView *visualEffectView2;
//                    visualEffectView2 = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//                    visualEffectView2.frame = backIMG.frame;
//                    [backIMG addSubview:visualEffectView2];
//                     NSLog(@"2222222");
                    [noRecordView addSubview:backIMG];
                    [noRecordView addSubview:noRecordLabel];
                    
                    [achieveCell addSubview:noRecordView];
                }else
                {
                    
                    [achieveCell.scoreType setText:@"竞技场积分"];
                [achieveCell.scoreLabel setText:[NSString stringWithFormat:@"%d",[[self.AllinfoDic objectForKey:@"jjcRating"] intValue]]];
                [achieveCell.totalGameLabel setText:[NSString stringWithFormat:@"%d",[[self.JJCinfoDic objectForKey:@"Total"] intValue]]];
                [achieveCell.mvpLabel setText:[NSString stringWithFormat:@"%d",[[self.JJCinfoDic objectForKey:@"MVP"] intValue]]];
                [achieveCell.pianjiangLabel setText:[NSString stringWithFormat:@"%d",[[self.JJCinfoDic objectForKey:@"PianJiang"] intValue]]];
                [achieveCell.podiLabel setText:[NSString stringWithFormat:@"%d",[[self.JJCinfoDic objectForKey:@"PoDi"] intValue]]];
                [achieveCell.pojunLabel setText:[NSString stringWithFormat:@"%d",[[self.JJCinfoDic objectForKey:@"PoJun"] intValue]]];
                [achieveCell.yinghunLabel setText:[NSString stringWithFormat:@"%d",[[self.JJCinfoDic objectForKey:@"YingHun"] intValue]]];
                [achieveCell.buwangLabel setText:[NSString stringWithFormat:@"%d",[[self.JJCinfoDic objectForKey:@"BuWang"] intValue]]];
                [achieveCell.fuhaoLabel setText:[NSString stringWithFormat:@"%d",[[self.JJCinfoDic objectForKey:@"FuHao"] intValue]]];
                [achieveCell.doubleKillLabel setText:[NSString stringWithFormat:@"%d",[[self.JJCinfoDic objectForKey:@"DoubleKill"] intValue]]];
                [achieveCell.tripleKillLabel setText:[NSString stringWithFormat:@"%d",[[self.JJCinfoDic objectForKey:@"TripleKill"] intValue]]];
                [achieveCell.winRatioLabel setText:[self.JJCinfoDic objectForKey:@"R_Win"]];
                
                
                [achieveCell.heroFirstImg setImageWithURL:[self loadheroImg:[self.JJCinfoDic objectForKey:@"AdeptHero1"]]];
                [achieveCell.heroSecondImg setImageWithURL:[self loadheroImg:[self.JJCinfoDic objectForKey:@"AdeptHero2"]]];
                [achieveCell.heroThirdImg setImageWithURL:[self loadheroImg:[self.JJCinfoDic objectForKey:@"AdeptHero3"]]];
                    
                    
                    [achieveCell.heroDetailButton addTarget:self action:@selector(heroDetail:) forControlEvents:UIControlEventTouchUpInside];

                }
                


            }else if(indexPath.row == 2)
            {
                UIView *noRecordView = [achieveCell viewWithTag:888];
                if (noRecordView) {
                    [noRecordView removeFromSuperview];
                }
                if ([[self.AllinfoDic objectForKey:@"mjInfos"] isKindOfClass:[NSNull class]] || ![self.MJinfoDic objectForKey:@"MingJiang"]) {
                    UIView *noRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.infoTableView.frame.size.width, self.infoTableView.frame.size.height)];
                    noRecordView.tag = 888;
                    
                    UILabel *noRecordLabel = [[UILabel alloc] initWithFrame:noRecordView.frame];
                    [noRecordLabel setText:@"暂未战斗"];
                    [noRecordLabel setTextColor:[UIColor colorWithRed:21/255.0f green:21/255.0f blue:21/255.0f alpha:1.0f]];
                    noRecordLabel.textAlignment = NSTextAlignmentCenter;
                    [noRecordLabel setBackgroundColor:[UIColor clearColor]];
                    
                    UIImageView *backIMG = [[UIImageView alloc] initWithFrame:noRecordView.frame];
                    [backIMG setImage:[UIImage imageNamed:@"mainBack.png"]];
                    


                    [noRecordView addSubview:backIMG];
                    [noRecordView addSubview:noRecordLabel];
                    
                    [achieveCell addSubview:noRecordView];
                }else
                {
                    
                    
                    
                    [achieveCell.scoreType setText:@"名将等级"];
                    [achieveCell.scoreLabel setText:[self.MJinfoDic objectForKey:@"MingJiang"]];
                    [achieveCell.totalGameLabel setText:[NSString stringWithFormat:@"%d",[[self.MJinfoDic objectForKey:@"Total"] intValue]]];
                    [achieveCell.mvpLabel setText:[NSString stringWithFormat:@"%d",[[self.MJinfoDic objectForKey:@"MVP"] intValue]]];
                    [achieveCell.pianjiangLabel setText:[NSString stringWithFormat:@"%d",[[self.MJinfoDic objectForKey:@"PianJiang"] intValue]]];
                    [achieveCell.podiLabel setText:[NSString stringWithFormat:@"%d",[[self.MJinfoDic objectForKey:@"PoDi"] intValue]]];
                    [achieveCell.pojunLabel setText:[NSString stringWithFormat:@"%d",[[self.MJinfoDic objectForKey:@"PoJun"] intValue]]];
                    [achieveCell.yinghunLabel setText:[NSString stringWithFormat:@"%d",[[self.MJinfoDic objectForKey:@"YingHun"] intValue]]];
                    [achieveCell.buwangLabel setText:[NSString stringWithFormat:@"%d",[[self.MJinfoDic objectForKey:@"BuWang"] intValue]]];
                    [achieveCell.fuhaoLabel setText:[NSString stringWithFormat:@"%d",[[self.MJinfoDic objectForKey:@"FuHao"] intValue]]];
                    [achieveCell.doubleKillLabel setText:[NSString stringWithFormat:@"%d",[[self.MJinfoDic objectForKey:@"DoubleKill"] intValue]]];
                    [achieveCell.tripleKillLabel setText:[NSString stringWithFormat:@"%d",[[self.MJinfoDic objectForKey:@"TripleKill"] intValue]]];
                    [achieveCell.winRatioLabel setText:[self.MJinfoDic objectForKey:@"R_Win"]];
                    
                    
                    [achieveCell.heroFirstImg setImageWithURL:[self loadheroImg:[self.MJinfoDic objectForKey:@"AdeptHero1"]]];
                    [achieveCell.heroSecondImg setImageWithURL:[self loadheroImg:[self.MJinfoDic objectForKey:@"AdeptHero2"]]];
                    [achieveCell.heroThirdImg setImageWithURL:[self loadheroImg:[self.MJinfoDic objectForKey:@"AdeptHero3"]]];
                    
                    
                    [achieveCell.heroDetailButton addTarget:self action:@selector(heroDetail:) forControlEvents:UIControlEventTouchUpInside];
                }
            }

          

            
            
            
            cell = achieveCell;
        }
        
        return cell;

        

    }
    
    
}

-(NSURL *)loadheroImg:(NSString *)ImgName
{
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"http://score.5211game.com/RecordCenter/img/dota/hero/%@.jpg",ImgName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    return url;
}

-(void)heroDetail:(UIButton *)sender
{
   NSString *gameName = [self.playerLevelInfoDic objectForKey:@"gameName"];
    
    scoreSearchViewController *scoreSearchVC = [[scoreSearchViewController alloc] initWithNibName:@"scoreSearchViewController" bundle:nil];
    scoreSearchVC.keyword = gameName;
    [self.navigationController pushViewController:scoreSearchVC animated:YES];

    [MobClick event:@"heroDetail"];

}

-(void)visotorDetail:(UIButton *)sender

{
    [self.view endEditing:YES];// this will do the trick

    playerPageViewController *playInfo = [[playerPageViewController alloc] initWithNibName:@"playerPageViewController" bundle:nil];
    
    playInfo.playerName =  self.visitorArray[sender.tag];
    
    playInfo.distance = -1;
    
    [self.navigationController pushViewController:playInfo animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)replyNote:(UIButton *)sender
{
    [invisibleTextFiled setHidden:NO];
    invisibleTextFiled.placeholder = [NSString stringWithFormat:@"回复:%@",self.visitorArray[sender.tag-100]];
    invisibleTextFiled.tag = 1;
    [invisibleTextFiled becomeFirstResponder];
}

-(void)leaveMesg
{
    NSLog(@"tao leave message...");
    
    [invisibleTextFiled setHidden:NO];
    invisibleTextFiled.placeholder = @"留言:";
    invisibleTextFiled.tag = 2;

    [invisibleTextFiled becomeFirstResponder];
}



-(void)initCustomTextViewWithY:(CGFloat)pos_Y
{
    UIView *customTextView = [[UIView alloc] initWithFrame:CGRectMake(0, pos_Y, SCREEN_WIDTH, 40)];
    [customTextView setBackgroundColor:[UIColor whiteColor]];
    customTextView.tag = 777;
    invisibleTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(3, 2, customTextView.frame.size.width-6, 36)];
    invisibleTextFiled.placeholder = @"回复:";
    invisibleTextFiled.layer.borderWidth = 0.5;
    invisibleTextFiled.layer.cornerRadius = 7;
    invisibleTextFiled.layer.borderColor = [UIColor lightGrayColor].CGColor;
    invisibleTextFiled.delegate = self;
    invisibleTextFiled.returnKeyType = UIReturnKeyDone;
    
    invisibleTextFiled.tag = 0;
    
//    UIButton *doInput = [[UIButton alloc] initWithFrame:CGRectMake(customTextView.frame.size.width-78, 2, 75, 36)];
//    [doInput setTitle:@"输入" forState:UIControlStateNormal];
//    doInput.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
//    [doInput setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [doInput addTarget:self action:@selector(inputText) forControlEvents:UIControlEventTouchUpInside];
//    [customTextView addSubview:invisibleTextFiled];
//    [customTextView addSubview:doInput];
    [customTextView addSubview:invisibleTextFiled];

    //    [customTextView setHidden:YES];
    
    [self.view addSubview:customTextView];
    
    
    
}

-(void)addNewNote:(NSString *)content OfVisitor:(NSString *)visitorName
{
    if([content isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"留言不能为空,请确认" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
    
    NSString *replyTo = @"none";
    NSArray *replyArray = [content componentsSeparatedByString:@"回复:"];
    if (replyArray.count>1) {
        replyTo = [replyArray[1] componentsSeparatedByString:@","][0];
    }
    
    
    NSDictionary *parameters = @{@"tag": @"addNote",@"username":self.playerName, @"content":content,@"visitor":visitorName,@"replyTo":replyTo};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30];

    [manager POST:noteService parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        [hud hide:YES];
        
        NSLog(@"JSON: %@", responseObject);
        
        self.visitorArray = [responseObject objectForKey:@"visitor"];
        self.notesArray = [responseObject objectForKey:@"content"];
        self.createTimeArray = [responseObject objectForKey:@"createdAt"];


        [self.notePadTable reloadData];

        UIView *noRecordView = [self.notePadTable viewWithTag:555];
        if (noRecordView) {
            [noRecordView removeFromSuperview];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        [hud hide:YES];
        
        
    }];
    
    
}



-(void)fetchNote
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
    
    NSDictionary *parameters = @{@"tag": @"getNote",@"username":self.playerName};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30];

    [manager POST:noteService parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        [hud hide:YES];
        
        NSLog(@"JSON: %@", responseObject);
        

        
        self.visitorArray = [responseObject objectForKey:@"visitor"];
        self.notesArray = [responseObject objectForKey:@"content"];
        self.createTimeArray = [responseObject objectForKey:@"createdAt"];
        
        
        [self.notePadTable reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        
        UIView *noRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.notePadTable.frame.size.width, self.notePadTable.frame.size.height)];
        noRecordView.tag = 555;
        
        UILabel *noRecordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, noRecordView.frame.size.width, 100)];
        [noRecordLabel setText:@"暂无留言"];
        [noRecordLabel setTextColor:[UIColor colorWithRed:21/255.0f green:21/255.0f blue:21/255.0f alpha:1.0f]];
        noRecordLabel.textAlignment = NSTextAlignmentCenter;
        [noRecordLabel setBackgroundColor:[UIColor clearColor]];
        
        UIButton *noteBtn = [[UIButton alloc] initWithFrame:CGRectMake(noRecordView.frame.size.width/2-50, 150, 100,50)];
        [noteBtn setTitle:@"抢沙发" forState:UIControlStateNormal];
        [noteBtn addTarget:self action:@selector(leaveMesg) forControlEvents:UIControlEventTouchUpInside];
        noteBtn.layer.cornerRadius = 10.0f;
        noteBtn.layer.borderWidth = 0.7f;
        noteBtn.layer.borderColor = [UIColor colorWithRed:21/255.0f green:21/255.0f blue:21/255.0f alpha:1.0f].CGColor;
        
        [noteBtn setTitleColor:[UIColor colorWithRed:21/255.0f green:21/255.0f blue:21/255.0f alpha:1.0f] forState:UIControlStateNormal];
        
        UIImageView *backIMG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, noRecordView.frame.size.width, noRecordView.frame.size.height)];
        [backIMG setImage:[UIImage imageNamed:@"mainBack.png"]];
        
//        UIVisualEffect *blurEffect;
//        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        UIVisualEffectView *visualEffectView2;
//        visualEffectView2 = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        visualEffectView2.frame = backIMG.bounds;
//        [backIMG addSubview:visualEffectView2];
//        NSLog(@"4444444444");

        [noRecordView addSubview:backIMG];
        [noRecordView addSubview:noRecordLabel];
        [noRecordView addSubview:noteBtn];

        
        [self.notePadTable addSubview:noRecordView];
        
        
       
        [hud hide:YES];
        
        
    }];
    
    
}


-(void)inputTextFor:(UITextField *)txtfld;
{
//    UIView *customTextView = [self.view viewWithTag:777];
//    UITextField *txtField = (UITextField *)[customTextView viewWithTag:7];
    NSString *note;
    if (txtfld.tag == 1) {
        note = [NSString stringWithFormat:@"%@, %@",txtfld.placeholder,txtfld.text];
    }else
    {
        note = txtfld.text;
    }
    
    if ([[DataCenter sharedDataCenter] isGuest]) {
        
        [self addNewNote:note OfVisitor:@"匿名游客"];
    }else
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"haveDefaultUser"] isEqualToString:@"yes"]) {
            
            NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoDic"];
            
            [self addNewNote:note OfVisitor:[userDic objectForKey:@"username"]];

        }else
        {
            NSLog(@"unknown error..");
        }
        
    }
    
}



-(void)hideCustomTextView
{
    UIView *customTextView = [self.view viewWithTag:777];
    [invisibleTextFiled setText:@""];
    [UIView animateWithDuration: 0.01
                     animations: ^{
                         [customTextView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 40)];
                         
                     }
                     completion:nil
     ];
    
    
}




-(void)keyboardWasShown:(NSNotification*)notification
{
    if (!invisibleTextFiled.isFirstResponder) {
        return;
    }
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    
    
    UIView *customTextView = [self.view viewWithTag:777];
    [UIView animateWithDuration: 0.05
                     animations: ^{
                         [customTextView setFrame:CGRectMake(0, SCREEN_HEIGHT-keyboardSize.height-103, SCREEN_WIDTH, 40)];
                         
                     }
                     completion:nil
     ];
    [self.view layoutIfNeeded];
}
-(void)keyboardWillDismiss:(NSNotification*)notification
{
    [invisibleTextFiled resignFirstResponder];
    [self hideCustomTextView];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self inputTextFor:textField];
    
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}
- (IBAction)favorTap:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"已关注"]) {
        [[DataCenter sharedDataCenter] removeFavor:self.playerName];
        [sender setTitle:@"+关注" forState:UIControlStateNormal];
        [self.favorBtn setBackgroundColor:[UIColor colorWithRed:255/255.0f green:55/255.0f blue:28/255.0f alpha:1.0f]];

    }else
    {
        [[DataCenter sharedDataCenter] addFavor:self.playerName];
        [sender setTitle:@"已关注" forState:UIControlStateNormal];
        [self.favorBtn setBackgroundColor:[UIColor colorWithRed:49/255.0f green:185/255.0f blue:163/255.0f alpha:1.0f]];

    }
}

- (IBAction)segChange:(UIButton *)sender {
    
    [self.view endEditing:YES];// this will do the trick

    [self.infoTableView setContentOffset:CGPointMake(0, self.infoTableView.frame.size.height*(sender.tag-1))];
    [self.ttBtn setSelected:NO];
    [self.jjcBtn setSelected:NO];
    [self.mjBtn setSelected:NO];
    [self.noteBtn setSelected:NO];
    [sender setSelected:YES];


    
}




#pragma mark request score from yaoyao

-(void)requestGamerID:(NSString *)username
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:37.0) Gecko/20100101 Firefox/37.0" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    [manager.requestSerializer setTimeoutInterval:30];
    
    NSURL *url = [NSURL URLWithString: [username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *infoURLstring =[NSString stringWithFormat: @"http://score.5211game.com/RecordCenter/?u=%@&t=10001",url];
    NSLog(@"infoURLstring-----%@",infoURLstring);
    
    
    //
    [manager GET:infoURLstring parameters:nil success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {
        
        NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"response: %@", aString);
        
        testSearchViewController *searVC = [[testSearchViewController alloc] init];
        NSString *gamerID = [searVC pickGamerID:responseObject];
        
        NSLog(@"gamerID----:%@",gamerID);
        if (gamerID) {
            [self requestScores:gamerID];

        }else
        {
            MBProgressHUD *hud =(MBProgressHUD *)[self.view viewWithTag:123];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请重新输入验证码";
            if (hud) {
                [hud hide:YES afterDelay:0.85];
            }
        }

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        
        
    }];
    
}



-(void)requestScores:(NSString *)userID
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30];


    NSString *infoURLstring = @"http://score.5211game.com/RecordCenter/request/record";

    NSDictionary *parameters = @{@"method": @"getrecord",@"u":userID,@"t":@"10001"};



    [manager POST:infoURLstring parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {

        NSLog(@"Scores: %@", responseObject);


        self.AllinfoDic = [NSMutableDictionary dictionaryWithDictionary:responseObject];


        self.JJCinfoDic = [responseObject objectForKey:@"jjcInfos"];
        self.TTinfoDic = [responseObject objectForKey:@"ttInfos"];
        self.MJinfoDic = [responseObject objectForKey:@"mjInfos"];
        [self.infoTableView reloadData];



        MBProgressHUD *hud =(MBProgressHUD *)[self.view viewWithTag:123];

        if (hud) {
            [hud hide:YES afterDelay:0.5];
        }







    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"Scores ERROR: %@",  operation.responseString);

        MBProgressHUD *hud =(MBProgressHUD *)[self.view viewWithTag:123];

        if (hud) {
            [hud hide:YES afterDelay:0.5];
        }


    }];

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
@end
