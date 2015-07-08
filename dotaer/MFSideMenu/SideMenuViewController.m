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
    loginViewController *demoController = [[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
    demoController.title = [NSString stringWithFormat:@"login #%d-%d", indexPath.section, indexPath.row];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSMutableArray *temp = [NSMutableArray arrayWithArray:navigationController.viewControllers];
    [temp addObject:demoController];
    navigationController.viewControllers = temp;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

@end
