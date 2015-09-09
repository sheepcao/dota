//
//  topicHistoryTableViewCell.h
//  dotaer
//
//  Created by Eric Cao on 9/8/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface topicHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
