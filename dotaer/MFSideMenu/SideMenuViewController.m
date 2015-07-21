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
    self.headImage.layer.cornerRadius = 65.0f;
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

-(void)requestSignature
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
