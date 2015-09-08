//
//  commentTableViewCell.h
//  dotaer
//
//  Created by Eric Cao on 9/2/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userButton.h"

@interface commentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet userButton *userBtn;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UIImageView *headIMG;
@property (strong, nonatomic) NSString *commentID;

- (IBAction)likeTap:(id)sender;

- (IBAction)userTapped:(id)sender;
@end
