//
//  listCellTableViewCell.h
//  dotaer
//
//  Created by Eric Cao on 7/8/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface listCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userHead;
@property (weak, nonatomic) IBOutlet UILabel *userInfo;
@property (weak, nonatomic) IBOutlet UILabel *userDistance;
@property (weak, nonatomic) IBOutlet UIImageView *confirmLevelImage;
@property (weak, nonatomic) IBOutlet UILabel *confirmLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;







@end
