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


@implementation SideMenuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.headImage.layer.cornerRadius = 55.0f;
    self.headImage.layer.masksToBounds = YES;
    

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
    
    cell.textLabel.text = self.items[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        levelInfoViewController *levelInfo = [[levelInfoViewController alloc] initWithNibName:@"levelInfoViewController" bundle:nil];
        
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSMutableArray *temp = [NSMutableArray arrayWithArray:navigationController.viewControllers];
        [temp addObject:levelInfo];
        navigationController.viewControllers = temp;


    }
//    loginViewController *demoController = [[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
//    demoController.title = [NSString stringWithFormat:@"login #%d-%d", indexPath.section, indexPath.row];
//    
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
        
        NSLog(@"Json: %@", responseObject);
        
        NSLog(@"content:%@",[responseObject objectForKey:@"content"]);
        
        [self.signatureTextView setText:[responseObject objectForKey:@"content"]];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR233: %@",  operation.responseString);
        
        
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

@end
