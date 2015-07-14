//
//  SideMenuViewController.h
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SideMenuViewController : UIViewController

@property (strong,nonatomic) NSArray *items;
@property (weak, nonatomic) IBOutlet UITableView *itemsTable;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
- (IBAction)logoutTap:(id)sender;

@end