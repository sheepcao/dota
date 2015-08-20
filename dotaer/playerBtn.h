//
//  playerBtn.h
//  dotaer
//
//  Created by Eric Cao on 8/19/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface playerBtn : UIButton

@property (nonatomic, strong) NSString *playerName;
@property (nonatomic, strong) UIImageView *head;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *update;

@end
