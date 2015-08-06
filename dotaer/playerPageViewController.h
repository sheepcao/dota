//
//  playerPageViewController.h
//  dotaer
//
//  Created by Eric Cao on 7/16/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userInfo.h"
#import "FXBlurView.h"
#import <BaiduMapAPI/BMapKit.h>


@interface playerPageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *achieveView;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIImageView *infoBackImage;
//@property (strong, nonatomic) UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) UITableView *notePadTable;

@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet FXBlurView *blurView;
@property (weak, nonatomic) IBOutlet UIButton *favorBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *notConfirmLevel;

@property (weak, nonatomic) IBOutlet UILabel *gameIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *TTLabel;
@property (weak, nonatomic) IBOutlet UILabel *JJCLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldierLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratioLabel;
@property (weak, nonatomic) IBOutlet UIImageView *achieveBlur;


@property (weak, nonatomic) IBOutlet UIImageView *heroFirstLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heroSecondLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heroThirdLabel;

@property (weak, nonatomic) IBOutlet UIImageView *distanceImage;


@property (weak, nonatomic) IBOutlet UITableView *infoTableView;



@property (strong, nonatomic) userInfo *playerInfo;
@property (strong, nonatomic) NSString *playerName;
@property NSUInteger distance;
@property (nonatomic, assign) CLLocationCoordinate2D userPosition;

- (IBAction)favorTap:(UIButton *)sender;
- (IBAction)segChange:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *ttBtn;
@property (weak, nonatomic) IBOutlet UIButton *mjBtn;
@property (weak, nonatomic) IBOutlet UIButton *jjcBtn;
@end
