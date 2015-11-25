//
//  testSearchViewController.h
//  dotaer
//
//  Created by Eric Cao on 11/23/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "popView.h"

@interface testSearchViewController : UIViewController
//@property (weak, nonatomic) IBOutlet UIButton *validCode;
//- (IBAction)refreshCode:(UIButton *)sender;
//@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
//- (IBAction)login:(id)sender;
//@property (weak, nonatomic) IBOutlet popView *popAlert;


@property (nonatomic, strong) NSString *VIEWSTATEGENERATOR ;
@property (nonatomic, strong) NSString *VIEWSTATE;
@property (nonatomic, strong) NSString *EVENTVALIDATION;


-(NSString *)pickVIEWSTATEGENERATOR:(NSData *)responseObject;
-(NSString *)pickURL:(NSData *)responseObject;
-(NSString *)pickVIEWSTATE:(NSData *)responseObject;
-(NSString *)pickEVENTVALIDATION:(NSData *)responseObject;
-(NSString *)pickUserID:(NSData *)responseObject;
-(NSString *)pickGamerID:(NSData *)responseObject;
- (void)login:(id)sender;
@end
