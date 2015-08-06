//
//  SideMenuViewController.m
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.


#import "SideMenuViewController.h"
#import "MFSideMenu.h"
#import "dotaerViewController.h"
#import "loginViewController.h"
#import "globalVar.h"
#import "DataCenter.h"
#import "AFHTTPRequestOperationManager.h"
#import "levelInfoViewController.h"

#import "playerPageViewController.h"
#import "favorViewController.h"


@implementation SideMenuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.headImage.layer.cornerRadius = 55.0f;
    self.headImage.layer.masksToBounds = YES;
    

    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = self.sideBackImage.bounds;
    [self.sideBackImage addSubview:visualEffectView];
    
    
    
}


-(void)viewDidLayoutSubviews
{
    if(!IS_IPHONE_4_OR_LESS)
    {
        [self.loginOut_upConstrains setConstant:50];
        [self.logoutBtn setNeedsUpdateConstraints];

        [self.view setNeedsUpdateConstraints];
        [self.view layoutIfNeeded];
        
    }

}


#pragma mark -
#pragma mark - UITableViewDataSource




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.textLabel.text = self.items[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1.0f];

    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row == 0) {
//        videoViewController *videoInfo = [[videoViewController alloc] initWithNibName:@"videoViewController" bundle:nil];
//        
//        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//        NSMutableArray *temp = [NSMutableArray arrayWithArray:navigationController.viewControllers];
//        [temp addObject:videoInfo];
//        navigationController.viewControllers = temp;
//        
//        
//    }else
    if (indexPath.row == 0) {
        
        if([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"我的主页"])
        {
            playerPageViewController *playInfo = [[playerPageViewController alloc] initWithNibName:@"playerPageViewController" bundle:nil];
            
            playInfo.playerName = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"userInfoDic"] objectForKey:@"username"];
            
            playInfo.distance = 0;
            
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSMutableArray *temp = [NSMutableArray arrayWithArray:navigationController.viewControllers];
            [temp addObject:playInfo];
            navigationController.viewControllers = temp;
        }else
        {
            levelInfoViewController *levelInfo = [[levelInfoViewController alloc] initWithNibName:@"levelInfoViewController" bundle:nil];
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSMutableArray *temp = [NSMutableArray arrayWithArray:navigationController.viewControllers];
            [temp addObject:levelInfo];
            navigationController.viewControllers = temp;
        }

    } else if (indexPath.row == 1)
    {
        NSMutableArray *favorArray = [[DataCenter sharedDataCenter] fetchFavors];
        if (favorArray && favorArray.count>0)
        {
            favorViewController *favorVC = [[favorViewController alloc] initWithNibName:@"favorViewController" bundle:nil];
            favorVC.isFromFavor = YES;
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSMutableArray *temp = [NSMutableArray arrayWithArray:navigationController.viewControllers];
            [temp addObject:favorVC];
            navigationController.viewControllers = temp;
        }else
        {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            return;
        }
    }else if(indexPath.row == 2)
    {
        [self shareAppTapped];
    }else if (indexPath.row == 3)
    {
        [self contactTapped];
    }

   
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

- (IBAction)logoutTap:(id)sender {
    
    if ([[DataCenter sharedDataCenter] isGuest]) {
        [self showLogin];
    }else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"注销成功";
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"haveDefaultUser"];
        
        [hud hide:YES afterDelay:1];
        
        [self performSelector:@selector(showLogin) withObject:nil afterDelay:1.15];
        
        
    }

    
}

-(void)showLogin
{
 
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    dotaerViewController *dotaerVC = [navigationController.viewControllers objectAtIndex:0];
    [dotaerVC showLoginPage];
}

#pragma textView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"编辑个人签名..."]) {
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"编辑个人签名...";
    }
    
    [self uploadSignature:textView.text];
}



- (IBAction)changeHeadImg:(UIButton *)sender {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.title = @"更新头像";
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

#pragma mark image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
    
    
    [self.headImage setImage:image];
    [self uploadNewHead:image forImagePicker:picker];
    
    
}

-(void)uploadNewHead:(UIImage *)headIMG forImagePicker:(UIImagePickerController *)picker
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Uploading";
    hud.dimBackground = YES;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    NSDictionary *parameters = @{@"tag": @"uploadNewHead"};
    
    
    //upload head image
    UIImage *image = headIMG;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    
    AFHTTPRequestOperation *op = [manager POST:registerService parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        NSString *username = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"userInfoDic"] objectForKey:@"username"];
        
        
        
        NSString *fileName = [NSString stringWithFormat:@"%@.png",username];
        
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"Completed";
        [hud hide:YES afterDelay:1.0];
        
        [self performSelector:@selector(successUpload:) withObject:picker afterDelay:1.1];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"Error";
        [hud hide:YES afterDelay:1.5];
        
        NSLog(@"Error: %@ ***** %@", operation.responseString, error.localizedDescription);
        
        UIAlertView *registerFailedAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"上传失败，请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [registerFailedAlert show];
        
        
    }];
    
    
    [op setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                 long long totalBytesWritten,
                                 long long totalBytesExpectedToWrite) {
        
        
        hud.progress = totalBytesWritten/totalBytesExpectedToWrite;
        
        NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    [op start];
    
    
}

-(void)successUpload:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(NSString *)requestSignature
{
    
    NSString *username = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"userInfoDic"] objectForKey:@"username"];
    
    NSDictionary *parameters = @{@"tag": @"getSignature",@"username":username};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:signatureService parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        NSLog(@"Json  signature: %@", responseObject);
        
        NSLog(@"content:%@",[responseObject objectForKey:@"content"]);
        
        [self.signatureTextView setText:[responseObject objectForKey:@"content"]];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR233: %@",  operation.responseString);
        [self.signatureTextView setText:@"编辑个人签名..."];

        
    }];
    
    return self.signatureTextView.text;
}


-(void)uploadSignature:(NSString *)signature
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
    
    NSString *username = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"userInfoDic"] objectForKey:@"username"];
    
    NSDictionary *parameters = @{@"tag": @"signature",@"content":signature,@"username":username};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:signatureService parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        [hud hide:YES];
        
        NSLog(@"Json: %@", responseObject);
        
        NSLog(@"content:%@",[responseObject objectForKey:@"content"]);

        [self.signatureTextView setText:[responseObject objectForKey:@"content"]];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        [hud hide:YES];
        
        
    }];

}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }
    
    [txtView resignFirstResponder];
    return NO;
}


-(void)shareAppTapped

{
    [MobClick event:@"shareApp"];
    
    
    UIImage *icon = [UIImage imageNamed:@"ICON 512"];
    
    id<ISSContent> publishContent = [ShareSDK content:@"dota圈子"
                                       defaultContent:NSLocalizedString(@"",nil)
                                                image:[ShareSDK pngImageWithImage:icon]
                                                title:@"dota圈子"
                                                  url:REVIEW_URL
                                          description:NSLocalizedString(@"轻松组队，开黑必备！\n一个真实的dota社交圈子。",nil)
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
    [picker setSubject:@"意见反馈-dota圈子"];
    emailBody = @"感谢您使用dota圈子，请留下您的宝贵意见，我们将持续更新！";
    
    
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


@end
