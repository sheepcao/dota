//
//  SideMenuViewController.h
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SideMenuViewController : UIViewController<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong,nonatomic) NSArray *items;
@property (weak, nonatomic) IBOutlet UITableView *itemsTable;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
- (IBAction)logoutTap:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *unLoginLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UITextView *signatureTextView;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;

-(void)requestSignature;
- (IBAction)changeHeadImg:(UIButton *)sender;

@end