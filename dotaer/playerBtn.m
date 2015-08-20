//
//  playerBtn.m
//  dotaer
//
//  Created by Eric Cao on 8/19/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "playerBtn.h"

@implementation playerBtn


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBtnWithFrame:frame];
    }
    return self;
}

-(void)setupBtnWithFrame:(CGRect)frame
{
    self.head = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/6, 8, frame.size.width*2/3, frame.size.width*2/3)];
    
    self.head.layer.cornerRadius = self.head.frame.size.height/2;
    self.head.layer.masksToBounds = YES;
    [self addSubview:self.head];

    self.name = [[UILabel alloc] initWithFrame:CGRectMake(2, self.head.frame.size.height*1.2+self.head.frame.origin.y, frame.size.width-4, self.head.frame.size.height/5)];
    [self.name setText:@"2009伍声"];
    [self.name setTextColor:[UIColor whiteColor]];
    self.name.textAlignment = NSTextAlignmentCenter;
    self.name.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:self.name];
   
    self.update = [[UILabel alloc] initWithFrame:CGRectMake(2, self.name.frame.size.height*1.2+self.name.frame.origin.y, frame.size.width-4, self.head.frame.size.height/5)];
    [self.update setText:@"更新于   "];
    [self.update setTextColor:[UIColor whiteColor]];
    self.update.textAlignment = NSTextAlignmentCenter;
    self.update.font = [UIFont systemFontOfSize:11.0f];


    [self addSubview:self.update];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
