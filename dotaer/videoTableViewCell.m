//
//  videoTableViewCell.m
//  dotaer
//
//  Created by Eric Cao on 7/28/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "videoTableViewCell.h"
@implementation videoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.cellView.layer.cornerRadius = 10.0f;
    self.cellView.layer.borderWidth = 0.7f;
    self.cellView.layer.borderColor = [UIColor colorWithRed:138/255.0f green:211/255.0f blue:221/255.0f alpha:1.0f].CGColor;

    self.headImg.layer.cornerRadius = 10.0f;
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.borderWidth = 0.8f;
    self.headImg.layer.borderColor = [UIColor colorWithRed:160/255.0f green:160/255.0f blue:160/255.0f alpha:1.0f].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (IBAction)vedioBtnTap:(id)sender {
//    NSLog(@"video tap...");
//    playVideoViewController *playVideo = [[playVideoViewController alloc] initWithNibName:@"playVideoViewController" bundle:nil];
//
//    
//}
@end
