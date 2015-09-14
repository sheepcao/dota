//
//  scoreSearchViewController.h
//  dotaer
//
//  Created by Eric Cao on 9/12/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface scoreSearchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *heroInfoTable;

@property (strong, nonatomic) NSString *keyword;

@property (weak, nonatomic) IBOutlet UIButton *TTScores;
@property (weak, nonatomic) IBOutlet UIButton *JJCScores;

- (IBAction)TTtapped:(id)sender;
- (IBAction)JJCTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *ScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalGameLabel;
@property (weak, nonatomic) IBOutlet UILabel *winningLabel;
@property (weak, nonatomic) IBOutlet UILabel *MVPsLabel;


@end
