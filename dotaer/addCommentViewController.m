//
//  addCommentViewController.m
//  dotaer
//
//  Created by Eric Cao on 9/7/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "addCommentViewController.h"
#import "globalVar.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"

@interface addCommentViewController ()<UITextViewDelegate>
@property (nonatomic ,strong) UITextView *textbodyView;
@end

@implementation addCommentViewController
@synthesize textbodyView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
    self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
    self.title = @"发表见解";
    
    textbodyView = [[UITextView alloc] initWithFrame:CGRectMake(10, 34, SCREEN_WIDTH-20, 150)];
    textbodyView.delegate = self;
    [self.view addSubview:textbodyView];
    
    [textbodyView becomeFirstResponder];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIBarButtonItem *)leftMenuBarButtonItem {
    //    return [[UIBarButtonItem alloc] initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:self action:@selector(leftSideMenuButtonPressed:)];
    
    UIButton *btnNext1 =[[UIButton alloc] init];
    [btnNext1 setTitle:@"取消" forState:UIControlStateNormal];
    [btnNext1 setTitleColor:[UIColor colorWithRed:47/255.0f green:140/255.0f blue:255/255.0f alpha:1.0] forState:UIControlStateNormal];
    btnNext1.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    
    btnNext1.frame = CGRectMake(15, 17, 50, 35);
    UIBarButtonItem *btnNext =[[UIBarButtonItem alloc] initWithCustomView:btnNext1];
    btnNext1.tag = 0;
    [btnNext1 addTarget:self action:@selector(cancelPressed) forControlEvents:UIControlEventTouchUpInside];
    
    return btnNext;
    
    
}

- (UIBarButtonItem *)rightMenuBarButtonItem {
    
    
    UIButton *btnNext1 =[[UIButton alloc] init];
    [btnNext1 setTitle:@"发布" forState:UIControlStateNormal];
    [btnNext1 setTitleColor:[UIColor colorWithRed:47/255.0f green:140/255.0f blue:255/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    btnNext1.titleLabel.font = [UIFont systemFontOfSize:18.0f];

    btnNext1.frame = CGRectMake(15, SCREEN_WIDTH-65, 50, 35);
    UIBarButtonItem *btnNext =[[UIBarButtonItem alloc] initWithCustomView:btnNext1];
    btnNext1.tag = 0;
    [btnNext1 addTarget:self action:@selector(publishTapped) forControlEvents:UIControlEventTouchUpInside];
    
    return btnNext;
    
    
}

-(void)cancelPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)publishTapped
{
    if ([[textbodyView.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"发布内容不能为空";
        [hud hide:YES afterDelay:1.5];
        return;
    }
    
    [self pushComment:textbodyView.text];
    
    
    
}

- (void)keyboardWillChange:(NSNotification *)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    [textbodyView setFrame:CGRectMake(textbodyView.frame.origin.x, textbodyView.frame.origin.y, textbodyView.frame.size.width, SCREEN_HEIGHT - keyboardFrameBeginRect.size.height)];
    
}


-(void)pushComment:(NSString *)commentContent
{
    NSString *username;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"haveDefaultUser"] isEqualToString:@"yes"]) {
        
        NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoDic"];
        username = [userDic objectForKey:@"username"];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
    
    NSDictionary *parameters;
    if (self.topicDay && ![self.topicDay isEqualToString:@""] && username) {
        parameters = @{@"tag": @"addcomment",@"commentUser":username,@"commentContent":commentContent,@"commentDay":self.topicDay};
    }else
    {
        parameters = @{@"tag": @"none"};
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:12];  //Time out after 25 seconds
    
    
    [manager POST:@"http://localhost/~ericcao/comments.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"ups Json: %@", responseObject);
        

            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"成功发言";
            [hud hide:YES afterDelay:1.2];

        [self performSelector:@selector(cancelPressed) withObject:nil afterDelay:1.22];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ups JsonError: %@", error.localizedDescription);
        NSLog(@"ups Json ERROR: %@",  operation.responseString);
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"网络请求失败,请稍后重试";
        [hud hide:YES afterDelay:1.2];
        
    }];
    
    
}

@end
