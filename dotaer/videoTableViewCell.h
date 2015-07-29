//
//  videoTableViewCell.h
//  dotaer
//
//  Created by Eric Cao on 7/28/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "videoButton.h"

@interface videoTableViewCell : UITableViewCell
//- (IBAction)vedioBtnTap:(id)sender;
@property (weak, nonatomic) IBOutlet videoButton *videoBtn;

@end
