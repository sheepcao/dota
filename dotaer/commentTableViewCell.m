//
//  commentTableViewCell.m
//  dotaer
//
//  Created by Eric Cao on 9/2/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "commentTableViewCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "DataCenter.h"

@implementation commentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    UIImageView *headIMG = [[UIImageView alloc] initWithFrame:CGRectMake(self.userBtn.frame.size.width/5, 5, self.userBtn.frame.size.width*3/5, self.userBtn.frame.size.width*3/5)];
 
    headIMG.layer.cornerRadius = headIMG.frame.size.height/2;
    headIMG.layer.masksToBounds = YES;
    
    [self.userBtn addSubview:headIMG];
    
    self.headIMG = headIMG;
    
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, headIMG.frame.size.height + headIMG.frame.origin.y+2, self.userBtn.frame.size.width-4, 30)];
    usernameLabel.numberOfLines = 2;
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    usernameLabel.font = [UIFont systemFontOfSize:11.0f];
    
    [self.userBtn addSubview:usernameLabel];
    self.usernameLabel = usernameLabel;
    
    if ([[DataCenter sharedDataCenter] isGuest]) {
        [self.likeBtn setEnabled:NO];
    }else
    {
        [self.likeBtn setEnabled:YES];

    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeTap:(id)sender {
    if ([self.likeCountLabel.text isEqualToString:@""]) {
        
    }else
    {
        [self requestComments];
    }
}

-(void)requestComments
{
    NSString *username;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"haveDefaultUser"] isEqualToString:@"yes"]) {
        
         NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoDic"];
        username = [userDic objectForKey:@"username"];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
    
    NSDictionary *parameters;
    if (self.commentID && username) {
         parameters = @{@"tag": @"addUps",@"commentID":self.commentID,@"commentUser":username};
    }else
    {
        parameters = @{@"tag": @"none"};
    }

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:12];  //Time out after 25 seconds
    
    
    [manager POST:@"http://localhost/~ericcao/comments.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"ups Json: %@", responseObject);
        
        if ([[responseObject objectForKey:@"ups_count"] intValue] == -1) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请勿重复点赞";
            [hud hide:YES afterDelay:1.5];
        }else
        {
            [self.likeCountLabel setText:[responseObject objectForKey:@"ups_count"]];
            [hud hide:YES];

        }

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ups JsonError: %@", error.localizedDescription);
        NSLog(@"ups Json ERROR: %@",  operation.responseString);
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"网络请求失败,请稍后重试";
        [hud hide:YES afterDelay:1.5];
        
    }];
    
    
}

- (IBAction)userTapped:(id)sender {
    

}



@end
