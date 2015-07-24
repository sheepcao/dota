//
//  noteTableViewCell.h
//  dotaer
//
//  Created by Eric Cao on 7/17/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface noteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *cellNumber;

@end
