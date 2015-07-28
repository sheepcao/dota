//
//  noteTableViewCell.m
//  dotaer
//
//  Created by Eric Cao on 7/17/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "noteTableViewCell.h"

@implementation noteTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.userHeadImage.layer.cornerRadius = 22.0f;
    self.userHeadImage.layer.masksToBounds = YES;
    
    self.bubbleView.layer.cornerRadius = 4.2f;
    self.bubbleView.layer.masksToBounds = NO;
    self.bubbleView.layer.shadowOffset = CGSizeMake(0.8, 1);
    self.bubbleView.layer.shadowRadius = 0.3;
    self.bubbleView.layer.shadowOpacity = 0.4;
    
    self.bubbleArrow.layer.shadowOffset = CGSizeMake(0.8, 1);
    self.bubbleArrow.layer.shadowRadius = 0.3;
    self.bubbleArrow.layer.shadowOpacity = 0.1;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
