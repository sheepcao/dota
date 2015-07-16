//
//  SideMenuViewController.m
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.


#import "SideMenuViewController.h"
#import "MFSideMenu.h"
#import "dotaerViewController.h"
#import "loginViewController.h"

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
    
    
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    loginViewController *demoController = [[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
//    demoController.title = [NSString stringWithFormat:@"login #%d-%d", indexPath.section, indexPath.row];
//    
//    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//    NSMutableArray *temp = [NSMutableArray arrayWithArray:navigationController.viewControllers];
//    [temp addObject:demoController];
//    navigationController.viewControllers = temp;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

- (IBAction)logoutTap:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"注销成功";
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"haveDefaultUser"];
    
    [hud hide:YES afterDelay:1];

    [self performSelector:@selector(showLogin) withObject:nil afterDelay:1.15];

    

    
}

-(void)showLogin
{
 
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    dotaerViewController *dotaerVC = [navigationController.viewControllers objectAtIndex:0];
    [dotaerVC showLoginPage];
}
@end
