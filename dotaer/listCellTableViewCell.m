//
//  listCellTableViewCell.m
//  dotaer
//
//  Created by Eric Cao on 7/8/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "listCellTableViewCell.h"

@implementation listCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.userHead.layer.cornerRadius = self.userHead.frame.size.height/2;
    self.userHead.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
