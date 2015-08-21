//
//  settingViewController.m
//  dotaer
//
//  Created by Eric Cao on 8/20/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "settingViewController.h"
#import "globalVar.h"
#import "passwordViewController.h"
#import "DataCenter.h"

@interface settingViewController ()

@end

@implementation settingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"圈子设置";
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
#pragma mark - UITableViewDataSource




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([[DataCenter sharedDataCenter] isGuest])
    {
        return 1;
    }else
    {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([[DataCenter sharedDataCenter] isGuest])
    {
        return 3;
    }else{
        
        NSInteger rowCount = 0;
        if (section == 0 ) {
            
            rowCount = 1;
            
        }else if(section == 1 )
        {
            rowCount = 1;
        }else if (section ==2)
        {
            rowCount = 3;
        }
        
        return rowCount;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.textLabel setTextColor:[UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f]];
    cell.textLabel.font = [UIFont systemFontOfSize:15.5f];
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(30, 59, SCREEN_WIDTH-45, 0.55)];
    [bottomLine setBackgroundColor:[UIColor colorWithRed:138/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f]];
    [cell addSubview:bottomLine];
   
    if([[DataCenter sharedDataCenter] isGuest])
    {
        
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"团队作品"];
            
        }else if (indexPath.row == 1)
        {
            [cell.textLabel setText:@"意见反馈"];
            
        }else if (indexPath.row == 2)
        {
            [cell.textLabel setText:@"官方QQ:82107815"];
            cell.accessoryType = UITableViewCellAccessoryNone;

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
                
                UISwitch *visibleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 15, 100, 30)];
                visibleSwitch.transform = CGAffineTransformMakeScale(1.05, 1.0);
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"invisible"] isEqualToString:@"yes"]) {
                    visibleSwitch.on = YES;
                }else
                {
                    visibleSwitch.on = NO;
                }
                
                
                [visibleSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
                [cell addSubview:visibleSwitch];
                break;
            }
            case 2:
            {
                if (indexPath.row == 0) {
                    [cell.textLabel setText:@"团队作品"];

                    
                }else if (indexPath.row == 1)
                {
                    [cell.textLabel setText:@"意见反馈"];

                    
                }else if (indexPath.row == 2)
                {
                    [cell.textLabel setText:@"官方QQ:82107815"];
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
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
//// fixed font style. use custom view (UILabel) if you want something different
//{
//    NSString *title = @"";
//    switch (section) {
//        case 0:
//            title = @"账号设置";
//            break;
//        case 1:
//            title = @"隐私设置";
//            break;
//        case 2:
//            title = @"关于我们";
//            break;
//        default:
//            break;
//    }
//    return  title;
//}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";

    if([[DataCenter sharedDataCenter] isGuest])
    {
        title = @"关于我们";
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
                title = @"关于我们";
                break;
            default:
                break;
        }
    }
    
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
        
        [headerView setBackgroundColor:[UIColor colorWithRed:70/255.0f green:100/255.0f blue:90/255.0f alpha:0.5f]];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 4, 80, 27)];
        [titleLabel setText:title];
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [titleLabel setTextColor:[UIColor colorWithRed:255/255.0f green:152/255.0f blue:25/255.0f alpha:1.0f]];
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
        if (indexPath.row == 0) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ALLAPP_URL]];
        }else if(indexPath.row == 1)
        {
            [self contactTapped];
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
                if (indexPath.row == 0) {
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ALLAPP_URL]];
                }else if(indexPath.row == 1)
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
    
    [MobClick event:@"email"];
    
    
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

- (BOOL)shouldAutorotate {
    return NO;
}


@end
