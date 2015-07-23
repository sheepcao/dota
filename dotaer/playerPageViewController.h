//
//  playerPageViewController.h
//  dotaer
//
//  Created by Eric Cao on 7/16/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userInfo.h"

@interface playerPageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *achieveView;
@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIImageView *infoBackImage;
//@property (strong, nonatomic) UIScrollView *mainScroll;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *notePadTable;

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;


@property (weak, nonatomic) IBOutlet UILabel *gameIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *TTLabel;
@property (weak, nonatomic) IBOutlet UILabel *JJCLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldierLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratioLabel;


@property (weak, nonatomic) IBOutlet UIImageView *heroFirstLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heroSecondLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heroThirdLabel;



@property (strong, nonatomic) userInfo *playerInfo;
@property (strong, nonatomic) NSString *playerName;
@property NSUInteger distance;
@property (strong, nonatomic) NSString *userSignature;



@end
