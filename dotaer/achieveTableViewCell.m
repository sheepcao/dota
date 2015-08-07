//
//  achieveTableViewCell.m
//  dotaer
//
//  Created by Eric Cao on 8/4/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "achieveTableViewCell.h"

@implementation achieveTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = self.cellBackImg.bounds;
    [self.cellBackImg addSubview:visualEffectView];
    
    
    
//    for (UILabel *btn in [self.detailInfoView subviews]) {
//        if ([btn isKindOfClass:[UILabel class]]) {
//            btn.layer.borderWidth = 0.5f;
//            btn.layer.borderColor = [UIColor colorWithRed:39/255.0f green:165/255.0f blue:215/255.0f alpha:1.0].CGColor;
//        }
//    }

    
    [self effectLabel:self.scoreType];
    [self effectLabel:self.totalGameTitleLabel];
    [self effectLabel:self.ratioTitleLabel];

    
}

-(void)effectLabel:(UILabel *)label
{
    label.layer.cornerRadius = 5.2f;
    label.layer.masksToBounds = NO;
    label.layer.shadowOffset = CGSizeMake(2, -1.2);
    label.layer.shadowRadius = 0.9;
    label.layer.shadowOpacity = 0.7;
    label.layer.shadowColor = [UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1.0f].CGColor;

    
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title.png"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
