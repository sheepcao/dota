//
//  SideMenuViewController.h
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>

@interface SideMenuViewController : UIViewController<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong,nonatomic) NSArray *items;
@property (weak, nonatomic) IBOutlet UITableView *itemsTable;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
- (IBAction)logoutTap:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UILabel *unLoginLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UITextView *signatureTextView;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property (weak, nonatomic) IBOutlet UIImageView *sideBackImage;
-(NSString *)requestSignature;
- (IBAction)changeHeadImg:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *cycleIMG;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginOut_upConstrains;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstrains;


@property (strong,nonatomic) NSString *topicDay;
@property (strong,nonatomic) NSString *topic;

@end