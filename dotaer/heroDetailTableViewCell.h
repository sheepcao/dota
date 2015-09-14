//
//  heroDetailTableViewCell.h
//  dotaer
//
//  Created by Eric Cao on 9/14/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface heroDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headIMG;
@property (weak, nonatomic) IBOutlet UILabel *gameTotal;
@property (weak, nonatomic) IBOutlet UILabel *winningRate;
@property (weak, nonatomic) IBOutlet UILabel *killCount;
@property (weak, nonatomic) IBOutlet UILabel *heroScore;
@property (weak, nonatomic) IBOutlet UILabel *MVPCount;

@end
