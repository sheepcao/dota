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

@end
