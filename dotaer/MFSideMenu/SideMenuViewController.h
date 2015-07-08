//
//  SideMenuViewController.h
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import <UIKit/UIKit.h>

@interface SideMenuViewController : UIViewController

@property (strong,nonatomic) NSArray *items;
@property (weak, nonatomic) IBOutlet UITableView *itemsTable;

@end