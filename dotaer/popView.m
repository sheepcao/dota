//
//  popView.m
//  dotaer
//
//  Created by Eric Cao on 11/23/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "popView.h"


@implementation popView
@synthesize hud;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    

    
    return self;
}

-(void)roundBack
{
    self.backImage.layer.cornerRadius = 10;
    self.backImage.layer.masksToBounds = YES;
    self.backImage.layer.borderColor = [UIColor blackColor].CGColor;
    self.backImage.layer.borderWidth = 1.0f;
}

-(void)loadingOn:(UIView *)view withDim:(BOOL)dim
{
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.margin = 5;
    hud.color = [UIColor darkGrayColor];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.cornerRadius = 3.8f;
    hud.dimBackground = dim;

}

-(void)loadOver
{
    if (hud) {
        [hud hide:YES];
    }
}

-(BOOL)isLoading
{
    if (hud) {
        return YES;
    }else
        return NO;
}

@end
