//
//  commentDetailViewController.h
//  dotaer
//
//  Created by Eric Cao on 9/8/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//
@class GADBannerView;
#import <UIKit/UIKit.h>

@interface commentDetailViewController : UIViewController

@property(nonatomic, strong)  GADBannerView *bannerView;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *likeCount;
@property (nonatomic, strong) NSString *commentContent;
@property (nonatomic, strong) NSString *commentID;


@property (weak, nonatomic) IBOutlet UIImageView *headIMG;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@property (weak, nonatomic) IBOutlet UITextView *commentBody;
- (IBAction)likeTapped:(id)sender;
- (IBAction)userButtonTap:(id)sender;
@end
