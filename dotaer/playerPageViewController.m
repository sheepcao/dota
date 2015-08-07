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
#import "levelInfoViewController.h"
#import "AFURLSessionManager.h"
#import "DataCenter.h"



@interface playerPageViewController ()<UITextFieldDelegate,BMKGeoCodeSearchDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) UITextField *invisibleTextFiled;

@property (nonatomic,strong) NSMutableDictionary *NoteInfoDic;
@property (nonatomic,strong) NSMutableArray *notesArray;
@property (nonatomic,strong) NSMutableArray *visitorArray;
@property (nonatomic,strong) NSMutableArray *createTimeArray;

@property (nonatomic,strong) NSMutableDictionary *JJCinfoDic;
@property (nonatomic,strong) NSMutableDictionary *TTinfoDic;
@property (nonatomic,strong) NSMutableDictionary *MJinfoDic;
@property (nonatomic,strong) NSMutableDictionary *playerLevelInfoDic;

@property (nonatomic,strong) NSMutableDictionary *cellDic;


@property (nonatomic,strong) BMKGeoCodeSearch *geocodesearch;


@end

@implementation playerPageViewController

@synthesize geocodesearch;
@synthesize contentView;
@synthesize invisibleTextFiled;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationItem.backBarButtonItem setTitle:@"附近"];
    self.title = self.playerName;
    
    self.cellDic = [[NSMutableDictionary alloc] init];
    
    if(![[DataCenter sharedDataCenter] isGuest] && [[[[NSUserDefaults standardUserDefaults]  objectForKey:@"userInfoDic"] objectForKey:@"username"] isEqualToString:self.playerName])
    {
//        [self.ageLabel setFrame:CGRectMake(251, 47, 42, 31)];
//        [self.sexImage setFrame:CGRectMake(35, 57, 19, 22)];
        
        self.title = @"个人主页";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更新战绩" style:UIBarButtonItemStylePlain target:self action:@selector(updateLevel)];
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

    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView2;
    visualEffectView2 = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView2.frame = self.infoBackImage.bounds;
    [self.infoBackImage addSubview:visualEffectView2];
    
    
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
    
    
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestPlayerInfo];

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

    
    levelInfoViewController *levelInfo = [[levelInfoViewController alloc] initWithNibName:@"levelInfoViewController" bundle:nil];
    
    [self.navigationController pushViewController:levelInfo animated:YES];
}


-(void)requestPlayerInfo
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
    
    NSDictionary *parameters = @{@"tag": @"playerInfo",@"name":self.playerName};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30];
    
    
    [manager POST:playerInfoService parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        [hud hide:YES];

        NSLog(@"JSON player info: %@", responseObject);
        
        [self setupPageWithDic:responseObject];
        

        

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        [hud hide:YES];
        
        
        UIView *noRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.infoTableView.frame.size.width, self.infoTableView.frame.size.height)];
        noRecordView.tag = 666;

        UILabel *noRecordLabel = [[UILabel alloc] initWithFrame:noRecordView.frame];
        [noRecordLabel setText:@"暂未战绩认证"];
        [noRecordLabel setTextColor:[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f]];
        noRecordLabel.textAlignment = NSTextAlignmentCenter;
        [noRecordLabel setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *backIMG = [[UIImageView alloc] initWithFrame:noRecordView.frame];
        [backIMG setImage:[UIImage imageNamed:@"黑.jpg"]];
        
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualEffectView2;
        visualEffectView2 = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView2.frame = backIMG.bounds;
        [backIMG addSubview:visualEffectView2];
        
        [noRecordView addSubview:backIMG];
        [noRecordView addSubview:noRecordLabel];
        
        [self.infoTableView addSubview:noRecordView];
        
        
        
        [self.notConfirmLevel setHidden:NO];

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


-(void)setupPageWithDic:(NSDictionary *)dic
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

//    NSData *data = [NSData dataWithContentsOfURL:url];
//    UIImage *img;
//    if (data) {
//        img = [[UIImage alloc] initWithData:data];
//    }else
//    {
//        img = [UIImage imageNamed:@"defaultHead"];
//    }
//    [self.headImage setImage:img];
    
    [self.ageLabel setText:[NSString stringWithFormat:@"%@岁",[dic objectForKey:@"age"]]];
    [self.sexImage setImage:[UIImage imageNamed:[dic objectForKey:@"sex"]]];
    [self.distanceLabel setText:[NSString stringWithFormat:@"%ld米",(unsigned long)self.distance]];
    
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
        [noRecordLabel setTextColor:[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f]];
        noRecordLabel.textAlignment = NSTextAlignmentCenter;
        [noRecordLabel setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *backIMG = [[UIImageView alloc] initWithFrame:noRecordView.frame];
        [backIMG setImage:[UIImage imageNamed:@"黑.jpg"]];
        
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualEffectView2;
        visualEffectView2 = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView2.frame = backIMG.bounds;
        [backIMG addSubview:visualEffectView2];
        
        [noRecordView addSubview:backIMG];
        [noRecordView addSubview:noRecordLabel];
        
        [self.infoTableView addSubview:noRecordView];
        
        [self.ttBtn setEnabled:NO];
        [self.jjcBtn setEnabled:NO];
        [self.mjBtn setEnabled:NO];
//        [self.infoTableView setScrollEnabled:NO];
        
        [self.notConfirmLevel setHidden:NO];
        
        if(![[DataCenter sharedDataCenter] isGuest] && [[[[NSUserDefaults standardUserDefaults]  objectForKey:@"userInfoDic"] objectForKey:@"username"] isEqualToString:self.playerName])
        {
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"战绩认证" style:UIBarButtonItemStylePlain target:self action:@selector(updateLevel)];
        }
        
    }else
    {
        [self.ttBtn setEnabled:YES];
        [self.jjcBtn setEnabled:YES];
        [self.mjBtn setEnabled:YES];
//        [self.infoTableView setScrollEnabled:YES];

        
        if(![[DataCenter sharedDataCenter] isGuest] && [[[[NSUserDefaults standardUserDefaults]  objectForKey:@"userInfoDic"] objectForKey:@"username"] isEqualToString:self.playerName])
        {
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更新战绩" style:UIBarButtonItemStylePlain target:self action:@selector(updateLevel)];
        }
        
        [self.notConfirmLevel setHidden:YES];
        self.playerLevelInfoDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        self.JJCinfoDic = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"JJCinfo"]];
        self.TTinfoDic = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"TTinfo"]];
        self.MJinfoDic = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"MJinfo"]];
        [self.infoTableView reloadData];
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
        [self.ageLabel setFrame:CGRectMake(235, 51, 42, 31)];
        [self.sexImage setFrame:CGRectMake(50, 55, 19, 22)];
    }else
    {
        if(self.distance == -1)
        {
            [self.ageLabel setFrame:CGRectMake(235, 45, 42, 31)];
            [self.sexImage setFrame:CGRectMake(50, 37, 19, 22)];
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
        title.textColor = [UIColor colorWithRed:255/255.0f green:145/255.0f blue:0 alpha:1.0];
        [title setText:@"留言板"];
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60-30, 3.5, 47, 25)];
        btn.backgroundColor = [UIColor purpleColor];
        btn.layer.cornerRadius = 4.2f;
        btn.layer.shadowOffset = CGSizeMake(1.5, 1.8);
        btn.layer.shadowRadius = 0.5;
        btn.layer.shadowOpacity = 0.4;
        
        btn.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];
        [btn setTitle:@"留言" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(leaveMesg) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
        [sectionView setBackgroundColor:[UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1.0]];
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

//        NSData *data = [NSData dataWithContentsOfURL:url];
//        UIImage *img;
//        
//        if (data) {
//            img = [[UIImage alloc] initWithData:data];
//        }else
//        {
//            img = [UIImage imageNamed:@"defaultHead"];
//        }
//        
//        [cell.userHeadImage setImage:img];
        
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
                if ([[self.TTinfoDic objectForKey:@"TTscore"] isKindOfClass:[NSNull class]] || ![self.TTinfoDic objectForKey:@"TTscore"]) {
                    
                    UIView *noRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.infoTableView.frame.size.width, self.infoTableView.frame.size.height)];
                    noRecordView.tag = 888;
                    
                    UILabel *noRecordLabel = [[UILabel alloc] initWithFrame:noRecordView.frame];
                    [noRecordLabel setText:@"暂未战斗"];
                    [noRecordLabel setTextColor:[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f]];
                    noRecordLabel.textAlignment = NSTextAlignmentCenter;
                    [noRecordLabel setBackgroundColor:[UIColor clearColor]];
                    
                    UIImageView *backIMG = [[UIImageView alloc] initWithFrame:noRecordView.frame];
                    [backIMG setImage:[UIImage imageNamed:@"黑.jpg"]];
                    
                    UIVisualEffect *blurEffect;
                    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
                    UIVisualEffectView *visualEffectView2;
                    visualEffectView2 = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
                    visualEffectView2.frame = backIMG.bounds;
                    [backIMG addSubview:visualEffectView2];
                    
                    [noRecordView addSubview:backIMG];
                    [noRecordView addSubview:noRecordLabel];
                    
                    [achieveCell addSubview:noRecordView];
                    

                }else
                {
                    
                    
                    [achieveCell.scoreType setText:@"天梯积分"];
                    [achieveCell.scoreLabel setText:[self.TTinfoDic objectForKey:@"TTscore"]];
                    [achieveCell.totalGameLabel setText:[self.TTinfoDic objectForKey:@"TTtotal"]];
                    [achieveCell.mvpLabel setText:[self.TTinfoDic objectForKey:@"TTmvp"]];
                    [achieveCell.pianjiangLabel setText:[self.TTinfoDic objectForKey:@"TTPianJiang"]];
                    [achieveCell.podiLabel setText:[self.TTinfoDic objectForKey:@"TTPoDi"]];
                    [achieveCell.pojunLabel setText:[self.TTinfoDic objectForKey:@"TTPoJun"]];
                    [achieveCell.yinghunLabel setText:[self.TTinfoDic objectForKey:@"TTYingHun"]];
                    [achieveCell.buwangLabel setText:[self.TTinfoDic objectForKey:@"TTBuWang"]];
                    [achieveCell.fuhaoLabel setText:[self.TTinfoDic objectForKey:@"TTFuHao"]];
                    [achieveCell.doubleKillLabel setText:[self.TTinfoDic objectForKey:@"TTDoubleKill"]];
                    [achieveCell.tripleKillLabel setText:[self.TTinfoDic objectForKey:@"TTTripleKill"]];
                    [achieveCell.winRatioLabel setText:[self.TTinfoDic objectForKey:@"TTWinRatio"]];
                    
                    
                    [achieveCell.heroFirstImg setImageWithURL:[self loadheroImg:[self.TTinfoDic objectForKey:@"TTheroFirst"]]];
                    [achieveCell.heroSecondImg setImageWithURL:[self loadheroImg:[self.TTinfoDic objectForKey:@"TTheroSecond"]]];
                    [achieveCell.heroThirdImg setImageWithURL:[self loadheroImg:[self.TTinfoDic objectForKey:@"TTheroThird"]]];
                    
 
                }

            }else if(indexPath.row == 1)
            {

                UIView *noRecordView = [achieveCell viewWithTag:888];
                if (noRecordView) {
                    [noRecordView removeFromSuperview];
                }
                if ([[self.JJCinfoDic objectForKey:@"JJCscore"] isKindOfClass:[NSNull class]] || ![self.JJCinfoDic objectForKey:@"JJCscore"]) {
                    
                    UIView *noRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.infoTableView.frame.size.width, self.infoTableView.frame.size.height)];
                    noRecordView.tag = 888;
                    
                    UILabel *noRecordLabel = [[UILabel alloc] initWithFrame:noRecordView.frame];
                    [noRecordLabel setText:@"暂未战斗"];
                    [noRecordLabel setTextColor:[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f]];
                    noRecordLabel.textAlignment = NSTextAlignmentCenter;
                    [noRecordLabel setBackgroundColor:[UIColor clearColor]];
                    
                    UIImageView *backIMG = [[UIImageView alloc] initWithFrame:noRecordView.frame];
                    [backIMG setImage:[UIImage imageNamed:@"黑.jpg"]];
                    
                    UIVisualEffect *blurEffect;
                    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
                    UIVisualEffectView *visualEffectView2;
                    visualEffectView2 = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
                    visualEffectView2.frame = backIMG.bounds;
                    [backIMG addSubview:visualEffectView2];
                    
                    [noRecordView addSubview:backIMG];
                    [noRecordView addSubview:noRecordLabel];
                    
                    [achieveCell addSubview:noRecordView];
                }else
                {
                    
                    [achieveCell.scoreType setText:@"竞技场积分"];
                [achieveCell.scoreLabel setText:[self.JJCinfoDic objectForKey:@"JJCscore"]];
                [achieveCell.totalGameLabel setText:[self.JJCinfoDic objectForKey:@"JJCtotal"]];
                [achieveCell.mvpLabel setText:[self.JJCinfoDic objectForKey:@"JJCmvp"]];
                [achieveCell.pianjiangLabel setText:[self.JJCinfoDic objectForKey:@"JJCPianJiang"]];
                [achieveCell.podiLabel setText:[self.JJCinfoDic objectForKey:@"JJCPoDi"]];
                [achieveCell.pojunLabel setText:[self.JJCinfoDic objectForKey:@"JJCPoJun"]];
                [achieveCell.yinghunLabel setText:[self.JJCinfoDic objectForKey:@"JJCYingHun"]];
                [achieveCell.buwangLabel setText:[self.JJCinfoDic objectForKey:@"JJCBuWang"]];
                [achieveCell.fuhaoLabel setText:[self.JJCinfoDic objectForKey:@"JJCFuHao"]];
                [achieveCell.doubleKillLabel setText:[self.JJCinfoDic objectForKey:@"JJCDoubleKill"]];
                [achieveCell.tripleKillLabel setText:[self.JJCinfoDic objectForKey:@"JJCTripleKill"]];
                [achieveCell.winRatioLabel setText:[self.JJCinfoDic objectForKey:@"JJCWinRatio"]];
                
                
                [achieveCell.heroFirstImg setImageWithURL:[self loadheroImg:[self.JJCinfoDic objectForKey:@"JJCheroFirst"]]];
                [achieveCell.heroSecondImg setImageWithURL:[self loadheroImg:[self.JJCinfoDic objectForKey:@"JJCheroSecond"]]];
                [achieveCell.heroThirdImg setImageWithURL:[self loadheroImg:[self.JJCinfoDic objectForKey:@"JJCheroThird"]]];

                }
                


            }else if(indexPath.row == 2)
            {
                UIView *noRecordView = [achieveCell viewWithTag:888];
                if (noRecordView) {
                    [noRecordView removeFromSuperview];
                }
                if ([[self.MJinfoDic objectForKey:@"MJscore"] isKindOfClass:[NSNull class]] || ![self.MJinfoDic objectForKey:@"MJscore"]) {
                    UIView *noRecordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.infoTableView.frame.size.width, self.infoTableView.frame.size.height)];
                    noRecordView.tag = 888;
                    
                    UILabel *noRecordLabel = [[UILabel alloc] initWithFrame:noRecordView.frame];
                    [noRecordLabel setText:@"暂未战斗"];
                    [noRecordLabel setTextColor:[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f]];
                    noRecordLabel.textAlignment = NSTextAlignmentCenter;
                    [noRecordLabel setBackgroundColor:[UIColor clearColor]];
                    
                    UIImageView *backIMG = [[UIImageView alloc] initWithFrame:noRecordView.frame];
                    [backIMG setImage:[UIImage imageNamed:@"黑.jpg"]];
                    
                    UIVisualEffect *blurEffect;
                    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
                    UIVisualEffectView *visualEffectView2;
                    visualEffectView2 = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
                    visualEffectView2.frame = backIMG.bounds;
                    [backIMG addSubview:visualEffectView2];
                    
                    [noRecordView addSubview:backIMG];
                    [noRecordView addSubview:noRecordLabel];
                    
                    [achieveCell addSubview:noRecordView];
                }else
                {
                    
                    
                    
                    [achieveCell.scoreType setText:@"名将积分"];
                    [achieveCell.scoreLabel setText:[self.MJinfoDic objectForKey:@"MJscore"]];
                    [achieveCell.totalGameLabel setText:[self.MJinfoDic objectForKey:@"MJtotal"]];
                    [achieveCell.mvpLabel setText:[self.MJinfoDic objectForKey:@"MJmvp"]];
                    [achieveCell.pianjiangLabel setText:[self.MJinfoDic objectForKey:@"MJPianJiang"]];
                    [achieveCell.podiLabel setText:[self.MJinfoDic objectForKey:@"MJPoDi"]];
                    [achieveCell.pojunLabel setText:[self.MJinfoDic objectForKey:@"MJPoJun"]];
                    [achieveCell.yinghunLabel setText:[self.MJinfoDic objectForKey:@"MJYingHun"]];
                    [achieveCell.buwangLabel setText:[self.MJinfoDic objectForKey:@"MJBuWang"]];
                    [achieveCell.fuhaoLabel setText:[self.MJinfoDic objectForKey:@"MJFuHao"]];
                    [achieveCell.doubleKillLabel setText:[self.MJinfoDic objectForKey:@"MJDoubleKill"]];
                    [achieveCell.tripleKillLabel setText:[self.MJinfoDic objectForKey:@"MJTripleKill"]];
                    [achieveCell.winRatioLabel setText:[self.MJinfoDic objectForKey:@"MJWinRatio"]];
                    
                    
                    [achieveCell.heroFirstImg setImageWithURL:[self loadheroImg:[self.MJinfoDic objectForKey:@"MJheroFirst"]]];
                    [achieveCell.heroSecondImg setImageWithURL:[self loadheroImg:[self.MJinfoDic objectForKey:@"MJheroSecond"]]];
                    [achieveCell.heroThirdImg setImageWithURL:[self loadheroImg:[self.MJinfoDic objectForKey:@"MJheroThird"]]];
                }
            }

          

            
            
            
            cell = achieveCell;
        }
        
        return cell;

        

    }
    
    
}

-(NSURL *)loadheroImg:(NSString *)ImgName
{
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"http://i.5211game.com/img/dota/hero/%@.jpg",ImgName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    return url;
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
//    UIView *sendNoteView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [sendNoteView setBackgroundColor:[UIColor clearColor]];
//
//    
//    [self.view addSubview:sendNoteView];
//    
//    UIView *sendNoteBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [sendNoteBack setBackgroundColor:[UIColor darkGrayColor]];
//    sendNoteBack.alpha = 0.6;
//    [sendNoteView addSubview:sendNoteBack];
//    
//    
//    
//    UITextView *noteText = [[UITextView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/10, SCREEN_HEIGHT*3/11, SCREEN_WIDTH*4/5, SCREEN_HEIGHT/3)];
//    [noteText setBackgroundColor:[UIColor yellowColor]];
//    
//    [sendNoteView addSubview:noteText];
//    
//    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(noteText.frame.origin.x+noteText.frame.size.width-80, noteText.frame.origin.y-32, 60, 30)];
//    [submit setTitle:@"提交" forState:UIControlStateNormal];
//    [sendNoteView addSubview:submit];
//    
//
//    [UIView animateWithDuration:0.2 delay:0.4 options:UIViewAnimationOptionCurveLinear animations:^{
//        [sendNoteView setCenter:CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT)/2)];
//    } completion:^(BOOL finished) {
//        
//    }];
//    [noteText becomeFirstResponder];
//
}



-(void)initCustomTextViewWithY:(CGFloat)pos_Y
{
    UIView *customTextView = [[UIView alloc] initWithFrame:CGRectMake(0, pos_Y, SCREEN_WIDTH, 40)];
    [customTextView setBackgroundColor:[UIColor whiteColor]];
    customTextView.tag = 777;
    invisibleTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(3, 2, customTextView.frame.size.width-6, 36)];
    invisibleTextFiled.placeholder = @"回复：";
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
    
    NSDictionary *parameters = @{@"tag": @"addNote",@"username":self.playerName, @"content":content,@"visitor":visitorName};
    
    
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
        [noRecordLabel setTextColor:[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f]];
        noRecordLabel.textAlignment = NSTextAlignmentCenter;
        [noRecordLabel setBackgroundColor:[UIColor clearColor]];
        
        UIButton *noteBtn = [[UIButton alloc] initWithFrame:CGRectMake(noRecordView.frame.size.width/2-50, 150, 100,50)];
        [noteBtn setTitle:@"抢沙发" forState:UIControlStateNormal];
        [noteBtn addTarget:self action:@selector(leaveMesg) forControlEvents:UIControlEventTouchUpInside];
        noteBtn.layer.cornerRadius = 10.0f;
        noteBtn.layer.borderWidth = 0.7f;
        noteBtn.layer.borderColor = [UIColor colorWithRed:138/255.0f green:211/255.0f blue:221/255.0f alpha:1.0f].CGColor;
        
        [noteBtn setTitleColor:[UIColor colorWithRed:138/255.0f green:211/255.0f blue:221/255.0f alpha:1.0f] forState:UIControlStateNormal];
        
        UIImageView *backIMG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, noRecordView.frame.size.width, noRecordView.frame.size.height)];
        [backIMG setImage:[UIImage imageNamed:@"黑.jpg"]];
        
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualEffectView2;
        visualEffectView2 = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView2.frame = backIMG.bounds;
        [backIMG addSubview:visualEffectView2];
        
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
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIView *customTextView = [self.view viewWithTag:777];
    [UIView animateWithDuration: 0.05
                     animations: ^{
                         [customTextView setFrame:CGRectMake(0, SCREEN_HEIGHT-keyboardSize.height-40, SCREEN_WIDTH, 40)];
                         
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

//#pragma mark scroll delegate
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    
//    if (scrollView == self.infoTableView)
//    {
//        int page = scrollView.contentOffset.y/scrollView.frame.size.height;
//        
//        UIButton *optionBtn = (UIButton *)[self.optinView viewWithTag:page+1];
//        
//        [self.ttBtn setSelected:NO];
//        [self.jjcBtn setSelected:NO];
//        [self.mjBtn setSelected:NO];
//        [self.noteBtn setSelected:NO];
//        
//        [optionBtn setSelected:YES];
//    }
//  
//}
@end
