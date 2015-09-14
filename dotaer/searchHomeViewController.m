//
//  searchHomeViewController.m
//  dotaer
//
//  Created by Eric Cao on 9/14/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "searchHomeViewController.h"
#import "scoreSearchViewController.h"
#import "MBProgressHUD.h"

@interface searchHomeViewController ()

@end

@implementation searchHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"战绩小秘书";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)search {
    if (self.keywordField.text && ![[self.keywordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        scoreSearchViewController *scoreSearchVC = [[scoreSearchViewController alloc] initWithNibName:@"scoreSearchViewController" bundle:nil];
        scoreSearchVC.keyword = self.keywordField.text;
        [self.navigationController pushViewController:scoreSearchVC animated:YES];
        

    
    }else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入合法的11账号";
        [hud hide:YES afterDelay:1.2f];
    }
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

@end
