//
//  settingViewController.m
//  dotaer
//
//  Created by Eric Cao on 8/20/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//
#import <GoogleMobileAds/GoogleMobileAds.h>

#import "settingViewController.h"
#import "globalVar.h"
#import "passwordViewController.h"
#import "DataCenter.h"
#import "favorViewController.h"
#import "MBProgressHUD.h"

@interface settingViewController ()<GADBannerViewDelegate>

@property (nonatomic,strong) UISwitch *visibleSwitch;
@end

@implementation settingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的圈子";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    

    self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-50-64,SCREEN_WIDTH, 50)];
    self.bannerView.delegate = self;
    self.bannerView.adUnitID =ADMOB_ID;
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    
    
    [self.bannerView loadRequest:request];
    [self.view addSubview:self.bannerView];
    
    
    self.visibleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 15, 100, 30)];
    self.visibleSwitch.transform = CGAffineTransformMakeScale(1.05, 1.0);
    
    [self.visibleSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UITableViewDataSource




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([[DataCenter sharedDataCenter] isGuest])
    {
        return 2;
    }else
    {
        return 4;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([[DataCenter sharedDataCenter] isGuest])
    {
        if (section == 0) {
            return 1;
        }else{
            return 6;
        }
    }else{
        
        NSInteger rowCount = 0;
        if (section == 0 ) {
            
            rowCount = 1;
            
        }else if(section == 1 )
        {
            rowCount = 1;
        }else if (section ==2)
        {
            rowCount = 1;
        }
        else if (section ==3)
        {
            rowCount = 6;
        }
        
        return rowCount;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    }
    
//    if (self.visibleSwitch.superview) {
//        [self.visibleSwitch removeFromSuperview];
//    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.textLabel setTextColor:[UIColor colorWithRed:35/255.0f green:35/255.0f blue:35/255.0f alpha:1.0f]];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    
    [cell.detailTextLabel setTextColor:[UIColor colorWithRed:35/255.0f green:35/255.0f blue:35/255.0f alpha:1.0f]];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(30, 60, SCREEN_WIDTH-45, 0.75)];
    [bottomLine setBackgroundColor:[UIColor colorWithRed:110/255.0f green:110/255.0f blue:110/255.0f alpha:1.0f]];
    [cell addSubview:bottomLine];
   
    if([[DataCenter sharedDataCenter] isGuest])
    {
        switch (indexPath.section) {
            case 0:
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                [cell.textLabel setText:@"关注的人"];

                
                break;
            case 1:
            {
                if (indexPath.row == 0) {
                    [cell.textLabel setText:@"分享好友"];
                    
                }else if (indexPath.row == 1) {
                    [cell.textLabel setText:@"好评鼓励"];
                    
                }else if (indexPath.row == 2) {
                    [cell.textLabel setText:@"团队作品"];
                    
                }else if (indexPath.row == 3)
                {
                    [cell.textLabel setText:@"意见反馈"];
                    
                }else if (indexPath.row == 4)
                {
                    [cell.textLabel setText:@"官方QQ:82107815"];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    
                }else if (indexPath.row == 5)
                {
                    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                    
                    
                    [cell.textLabel setText:[NSString stringWithFormat:@"版本: %@",version]];
//                    [cell.detailTextLabel setText:version];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    
                }

                break;
            }
                default:
                break;
        }
        
         

    }else
    {
        switch (indexPath.section) {
            case 0:
            {

                if (indexPath.row == 0) {
                    [cell.textLabel setText:@"修改密码"];
                    
                }
                break;
            }
            case 1:
            {
                cell.accessoryType = UITableViewCellAccessoryNone;

                [cell.textLabel setText:@"隐身(对他人不可见)"];
                

                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"invisible"] isEqualToString:@"yes"]) {
                    self.visibleSwitch.on = YES;
                }else
                {
                    self.visibleSwitch.on = NO;
                }
                
                
                [cell addSubview:self.visibleSwitch];
                break;
            }
            case 2:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                [cell.textLabel setText:@"关注的人"];
                
                
                
                break;
            }
            case 3:
            {
                if (indexPath.row == 0) {
                    [cell.textLabel setText:@"分享好友"];
                    
                }else if (indexPath.row == 1) {
                    [cell.textLabel setText:@"好评鼓励"];
                    
                }else if (indexPath.row == 2) {
                    [cell.textLabel setText:@"团队作品"];

                    
                }else if (indexPath.row == 3)
                {
                    [cell.textLabel setText:@"意见反馈"];

                    
                }else if (indexPath.row == 4)
                {
                    [cell.textLabel setText:@"官方QQ:82107815"];
                    cell.accessoryType = UITableViewCellAccessoryNone;

                }else if (indexPath.row == 5)
                {
                    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

                    
                    [cell.textLabel setText:[NSString stringWithFormat:@"版本: %@",version]];
//                    [cell.detailTextLabel setText:version];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    
                }

                
                
                break;
            }
                
            default:
                
                break;
        }

    }
    
    return cell;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";

    if([[DataCenter sharedDataCenter] isGuest])
    {
        if(section == 0)
        {
            title = @"关注";
        }else
        {
            title = @"关于我们";
        }
    }else
    {
        switch (section) {
            case 0:
                title = @"账号设置";
                break;
            case 1:
                title = @"隐私设置";
                break;
            case 2:
                title = @"关注";
                break;
            case 3:
                title = @"关于我们";
                break;
            default:
                break;
        }
    }
    
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
        
        [headerView setBackgroundColor:[UIColor colorWithRed:130/255.0f green:130/255.0f blue:130/255.0f alpha:1.0f]];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 4, 80, 27)];
        [titleLabel setText:title];
        titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [titleLabel setTextColor:[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f]];
        [headerView addSubview:titleLabel];
        

        
        return headerView;
    
    

}

#pragma mark -
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return 60;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 35;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([[DataCenter sharedDataCenter] isGuest])
    {
        if(indexPath.section == 0)
        {
            NSMutableArray *favorArray = [[DataCenter sharedDataCenter] fetchFavors];
            if (favorArray && favorArray.count>0)
            {
                favorViewController *favorVC = [[favorViewController alloc] initWithNibName:@"favorViewController" bundle:nil];
                favorVC.isFromFavor = YES;
                
                [self.navigationController pushViewController:favorVC animated:YES];

                
            }else
            {
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"尚未关注任何人";
                [hud hide:YES afterDelay:1.2];
                return;
                
            }

        }else
        {
            if (indexPath.row == 0) {
                [self shareAppTapped];
                
            }if (indexPath.row == 1) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:REVIEW_URL]];
                [MobClick event:@"review"];

            }else if (indexPath.row == 2) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ALLAPP_URL]];
                [MobClick event:@"teamApp"];

            }else if(indexPath.row == 3)
            {
                [self contactTapped];
            }

        }
        
       
    }else
    {
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0) {
                    passwordViewController *passwordVC = [[passwordViewController alloc] initWithNibName:@"passwordViewController" bundle:nil];
                    [self.navigationController pushViewController:passwordVC animated:YES];
                }
                break;
                
                
            case 2:
            {
                NSMutableArray *favorArray = [[DataCenter sharedDataCenter] fetchFavors];
                if (favorArray && favorArray.count>0)
                {
                    favorViewController *favorVC = [[favorViewController alloc] initWithNibName:@"favorViewController" bundle:nil];
                    favorVC.isFromFavor = YES;
                    
                    [self.navigationController pushViewController:favorVC animated:YES];
                    
                    
                }else
                {
                    [tableView deselectRowAtIndexPath:indexPath animated:NO];
                    
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"尚未关注任何人";
                    [hud hide:YES afterDelay:1.2];

                    return;
                    
                }

                
                break;
            }
                
            case 3:
                if (indexPath.row == 0) {
                    [self shareAppTapped];
                }if (indexPath.row == 1) {
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:REVIEW_URL]];
                    [MobClick event:@"review"];

                }else if (indexPath.row == 2) {
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ALLAPP_URL]];
                    [MobClick event:@"teamApp"];

                }else if(indexPath.row == 3)
                {
                    [self contactTapped];
                }
                break;
                
            default:
                break;
        }

    }
        
    
    
}

-(void)switchAction:(UISwitch *)sender
{
    if (sender.on) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"invisible"];
    }else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"invisible"];

    }
}


-(void)contactTapped
{
    
//    [MobClick event:@"email"];
    
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    [picker.view setFrame:CGRectMake(0,20 , 320, self.view.frame.size.height-20)];
    picker.mailComposeDelegate = self;
    
    
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"sheepcao1986@163.com"];
    
    
    [picker setToRecipients:toRecipients];
    
    NSString *emailBody= @"";
    [picker setSubject:@"意见反馈-捣塔圈"];
    emailBody = @"感谢您使用捣塔圈，请留下您的宝贵意见，我们将持续更新！";
    
    
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)alertWithTitle: (NSString *)_title_ msg: (NSString *)msg

{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                          
                                                    message:msg
                          
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                          
                                          otherButtonTitles:nil];
    
    [alert show];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error

{
    
    NSString *title = @"发送状态";
    
    NSString *msg;
    
    switch (result)
    
    {
            
        case MFMailComposeResultCancelled:
            
            msg = @"Mail canceled";//@"邮件发送取消";
            
            break;
            
        case MFMailComposeResultSaved:
            
            msg = @"邮件保存成功";//@"邮件保存成功";
            
            [self alertWithTitle:title msg:msg];
            
            break;
            
        case MFMailComposeResultSent:
            
            msg = @"邮件发送成功";//@"邮件发送成功";
            
            [self alertWithTitle:title msg:msg];
            
            break;
            
        case MFMailComposeResultFailed:
            
            msg = @"邮件发送失败";//@"邮件发送失败";
            
            [self alertWithTitle:title msg:msg];
            
            break;
            
        default:
            
            msg = @"邮件尚未发送";
            
            [self alertWithTitle:title msg:msg];
            
            break;
            
    }
    
    [self  dismissViewControllerAnimated:YES completion:nil];
    
}



-(void)shareAppTapped

{
    [MobClick event:@"shareApp"];
    
    
    UIImage *icon = [UIImage imageNamed:@"ICON 512"];
    
    id<ISSContent> publishContent = [ShareSDK content:@"捣塔圈子,帅哥妹子，轻松组队，开黑必备！\n一个真实的dota社交圈子。"
                                       defaultContent:NSLocalizedString(@"捣塔圈子,帅哥妹子，轻松组队，开黑必备！\n一个真实的dota社交圈子。。",nil)
                                                image:[ShareSDK pngImageWithImage:icon]
                                                title:@"捣塔圈"
                                                  url:REVIEW_URL
                                          description:NSLocalizedString(@"捣塔圈子,帅哥妹子，轻松组队，开黑必备！\n一个真实的dota社交圈子。",nil)
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    //eric: to be sned da bai....
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
    
    
    
}


- (BOOL)shouldAutorotate {
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; // your own style
}

- (BOOL)prefersStatusBarHidden {
    return NO; // your own visibility code
}

@end
