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
//#import "levelInfoViewController.h"
#import "submitScoreViewController.h"

#import "playerPageViewController.h"
#import "favorViewController.h"
#import "publisherViewController.h"
#import "settingViewController.h"
#import "topicsViewController.h"
#import "searchHomeViewController.h"

@interface SideMenuViewController()<cancelNewImgDelegate>
@end

@implementation SideMenuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.headImage.layer.cornerRadius = 55.0f;
    self.headImage.layer.masksToBounds = YES;
    

    self.menuContainerViewController.leftMenuWidth = SCREEN_WIDTH*4/7;
    self.menuContainerViewController.menuWidth = SCREEN_WIDTH*4/7;

//    UIVisualEffect *blurEffect;
//    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    
//    UIVisualEffectView *visualEffectView;
//    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    
//    visualEffectView.frame = self.sideBackImage.bounds;
//    [self.sideBackImage addSubview:visualEffectView];
//    
//    
    [self.usernameLabel setTextColor:[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f]];


    
    NSLog(@"SideMenuViewController did load");
    
    
}


-(void)viewDidLayoutSubviews
{
    if(IS_IPHONE_5)
    {
        [self.loginOut_upConstrains setConstant:40];
        [self.logoutBtn setNeedsUpdateConstraints];
        
        [self.tableYConstrains setConstant:15];


        [self.tableHeightConstrains setConstant:210];
        [self.itemsTable setNeedsUpdateConstraints];

        [self.view setNeedsUpdateConstraints];
        [self.view layoutIfNeeded];
        
    }else if(IS_IPHONE_6)
    {
        [self.loginOut_upConstrains setConstant:70];
        [self.logoutBtn setNeedsUpdateConstraints];
        
        [self.tableYConstrains setConstant:-10];
        [self.tableHeightConstrains setConstant:230];
        [self.itemsTable setNeedsUpdateConstraints];
        
        [self.view setNeedsUpdateConstraints];
        [self.view layoutIfNeeded];
        
    }else if(IS_IPHONE_6P)
    {
        [self.loginOut_upConstrains setConstant:75];
        [self.logoutBtn setNeedsUpdateConstraints];
        
        [self.tableYConstrains setConstant:-25];

        [self.tableHeightConstrains setConstant:235];
        [self.itemsTable setNeedsUpdateConstraints];
        
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
    cell.textLabel.textColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f];
    


    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.5f];
    if([[DataCenter sharedDataCenter] isGuest] && indexPath.row == 1)
    {
        [cell setUserInteractionEnabled:NO];
        cell.textLabel.textColor = [UIColor colorWithRed:160/255.0f green:150/255.0f blue:160/255.0f alpha:1.0f];

    }else
    {
        [cell setUserInteractionEnabled:YES];

    }
    
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPHONE_4_OR_LESS){
        return 33;
    }else if(IS_IPHONE_5)
    {
        return 42;
    }else if(IS_IPHONE_6)
    {
        return 48;
    }else 
    {
        return 50;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
        return 0;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        [MobClick event:@"videoMenu"];

        publisherViewController *VideoVC = [[publisherViewController alloc] initWithNibName:@"publisherViewController" bundle:nil];
        
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSMutableArray *temp = [NSMutableArray arrayWithArray:navigationController.viewControllers];
        [temp addObject:VideoVC];
        navigationController.viewControllers = temp;
        
        
    }else if (indexPath.row == 1) {
        
        [MobClick event:@"selfPage"];

        
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
            submitScoreViewController *levelInfo = [[submitScoreViewController alloc] initWithNibName:@"submitScoreViewController" bundle:nil];
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSMutableArray *temp = [NSMutableArray arrayWithArray:navigationController.viewControllers];
            [temp addObject:levelInfo];
            navigationController.viewControllers = temp;
        }

    }else if(indexPath.row == 2)
    {
        
        [MobClick event:@"todayTopic"];

        
        topicsViewController *topicVC = [[topicsViewController alloc] initWithNibName:@"topicsViewController" bundle:nil];
        topicVC.imgDelegate = self;
        topicVC.isFromHistory = NO;

        
        if ([self.topic isEqualToString:@""]) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            hud.mode = MBProgressHUDModeIndeterminate;
            
            
            NSDictionary *parameters = @{@"tag": @"todayTopic"};
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
            [manager.requestSerializer setTimeoutInterval:12];  //Time out after 25 seconds
            
            
            [manager POST:topicURL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                NSLog(@"topic Json: %@", responseObject);
                
                self.topic = [responseObject objectForKey:@"topic_content"];
                self.topicDay = [responseObject objectForKey:@"topic_day"] ;
                
                UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                NSMutableArray *temp = [NSMutableArray arrayWithArray:navigationController.viewControllers];
                [temp addObject:topicVC];
                navigationController.viewControllers = temp;
               
                [hud hide:YES];

                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"topic JsonError: %@", error.localizedDescription);
                NSLog(@"topic Json ERROR: %@",  operation.responseString);
                
                
                
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"获取今日话题失败，请检查网络并重试";
                
                [hud hide:YES afterDelay:1];
                
                
                
            }];
            


        }else
        {
            topicVC.topic = self.topic;
            topicVC.topicDay = self.topicDay;
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSMutableArray *temp = [NSMutableArray arrayWithArray:navigationController.viewControllers];
            [temp addObject:topicVC];
            navigationController.viewControllers = temp;
        }
        

//        [self shareAppTapped];
    }else if (indexPath.row == 3)
    {
        [MobClick event:@"mySetting"];

        
        settingViewController *settingVC = [[settingViewController alloc] initWithNibName:@"settingViewController" bundle:nil];
        
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSMutableArray *temp = [NSMutableArray arrayWithArray:navigationController.viewControllers];
        [temp addObject:settingVC];
        navigationController.viewControllers = temp;
        
        
    } else if (indexPath.row == 4)
    {
        searchHomeViewController *scoreSearchVC = [[searchHomeViewController alloc] initWithNibName:@"searchHomeViewController" bundle:nil];
        
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSMutableArray *temp = [NSMutableArray arrayWithArray:navigationController.viewControllers];
        [temp addObject:scoreSearchVC];
        navigationController.viewControllers = temp;
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
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

-(void)uploadNewHead:(UIImage *)headIMG forImagePicker:(UIImagePickerController *)picker
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"正在上传";
    hud.dimBackground = YES;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    NSDictionary *parameters = @{@"tag": @"uploadNewHead"};
    
    
    //upload head image
    UIImage *image = headIMG;
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager.requestSerializer setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30];

    
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
        
        [self.headImage setImage:headIMG];
        [MobClick event:@"changeHead"];

        
        
        
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
    [manager.requestSerializer setTimeoutInterval:30];

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
    [manager.requestSerializer setTimeoutInterval:30];

    [manager POST:signatureService parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        [hud hide:YES];
        
        NSLog(@"Json: %@", responseObject);
        
        NSLog(@"content:%@",[responseObject objectForKey:@"content"]);

        [self.signatureTextView setText:[responseObject objectForKey:@"content"]];
        
        [MobClick event:@"signature"];


        
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


-(void)cancelNewImg
{
    for (UIView *img in [self.itemsTable subviews]) {
        if (img.tag == 101) {
            [img removeFromSuperview];
        }
    }
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
