//
//  favorTableViewCell.m
//  dotaer
//
//  Created by Eric Cao on 7/31/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "favorTableViewCell.h"

@implementation favorTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.userHeadImg.layer.cornerRadius = self.userHeadImg.frame.size.height/2;
    self.userHeadImg.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
