//
//  achieveTableViewCell.h
//  dotaer
//
//  Created by Eric Cao on 8/4/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface achieveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellBackImg;
@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalGameLabel;
@property (weak, nonatomic) IBOutlet UILabel *winRatioLabel;


@property (weak, nonatomic) IBOutlet UILabel *mvpLabel;
@property (weak, nonatomic) IBOutlet UILabel *pojunLabel;
@property (weak, nonatomic) IBOutlet UILabel *podiLabel;
@property (weak, nonatomic) IBOutlet UILabel *buwangLabel;
@property (weak, nonatomic) IBOutlet UILabel *pianjiangLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuhaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *yinghunLabel;


@property (weak, nonatomic) IBOutlet UILabel *doubleKillLabel;

@property (weak, nonatomic) IBOutlet UILabel *tripleKillLabel;


@property (weak, nonatomic) IBOutlet UIImageView *heroFirstImg;
@property (weak, nonatomic) IBOutlet UIImageView *heroSecondImg;
@property (weak, nonatomic) IBOutlet UIImageView *heroThirdImg;



@property (weak, nonatomic) IBOutlet UIView *detailInfoView;
@property (weak, nonatomic) IBOutlet UILabel *mvp;
@property (weak, nonatomic) IBOutlet UILabel *buwang;
@property (weak, nonatomic) IBOutlet UILabel *pianjiang;
@property (weak, nonatomic) IBOutlet UILabel *yinghun;
@property (weak, nonatomic) IBOutlet UILabel *podi;
@property (weak, nonatomic) IBOutlet UILabel *fuhao;

@property (weak, nonatomic) IBOutlet UILabel *pojun;

@property (weak, nonatomic) IBOutlet UILabel *scoreType;
@property (weak, nonatomic) IBOutlet UILabel *ratioTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalGameTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *heroDetailButton;

@end
