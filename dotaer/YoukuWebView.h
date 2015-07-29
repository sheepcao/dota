//
//  YoukuWebView.h
//  dotaer
//
//  Created by Eric Cao on 7/28/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YoukuWebView : UIWebView
@property (nonatomic, strong) UIActivityIndicatorView *ai;
@property (nonatomic, strong) NSString *embsig;

- (id)initWithFrame:(CGRect)frame andVideoId:(NSString*)vid;
-(void)startPlayWithID;
@end
