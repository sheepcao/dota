//
//  topicsViewController.h
//  dotaer
//
//  Created by Eric Cao on 9/2/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol cancelNewImgDelegate <NSObject>

-(void)cancelNewImg;

@end

@interface topicsViewController : UIViewController

@property(nonatomic,weak) id <cancelNewImgDelegate> imgDelegate;

@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *myComment;
@property (weak, nonatomic) IBOutlet UITableView *commentTable;

@property (strong,nonatomic) NSString *topic;
@property (strong,nonatomic) NSString *topicDay;

@property BOOL isFromHistory;

- (IBAction)checkMyComment:(id)sender;

- (IBAction)addComment:(id)sender;
@end
