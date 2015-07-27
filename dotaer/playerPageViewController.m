//
//  playerPageViewController.m
//  dotaer
//
//  Created by Eric Cao on 7/16/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "playerPageViewController.h"
#import "globalVar.h"
#import "noteTableViewCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLSessionManager.h"
#import "DataCenter.h"

@interface playerPageViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UITextField *invisibleTextFiled;

@property (nonatomic,strong) NSMutableDictionary *NoteInfoDic;
@property (nonatomic,strong) NSMutableArray *notesArray;
@property (nonatomic,strong) NSMutableArray *visitorArray;
@property (nonatomic,strong) NSMutableArray *createTimeArray;



@end

@implementation playerPageViewController

@synthesize contentView;
@synthesize invisibleTextFiled;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationItem.backBarButtonItem setTitle:@"附近"];
    self.title = self.playerName;

    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = self.achieveBlur.bounds;
    [self.achieveBlur addSubview:visualEffectView];
    
    self.blurView.blurRadius = 4.2;
    self.headImage.layer.cornerRadius = 49.0f;
    self.headImage.layer.masksToBounds = YES;
    self.visitorArray = nil;
    self.createTimeArray = nil;
    self.notesArray = nil;
    //for custom text view
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDismiss:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self initCustomTextViewWithY:SCREEN_HEIGHT];

    
    [self requestPlayerInfo];
}

-(void)requestPlayerInfo
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
    
    NSDictionary *parameters = @{@"tag": @"playerInfo",@"name":self.playerName};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //    [manager.requestSerializer setTimeoutInterval:25];  //Time out after 25 seconds
    
    
    [manager POST:playerInfoService parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        [hud hide:YES];

        NSLog(@"JSON: %@", responseObject);
        
        [self setupPageWithDic:responseObject];
        
        [self fetchNote];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        [hud hide:YES];

        
    }];
    

}


-(void)setupPageWithDic:(NSDictionary *)dic
{
    NSString *headPath = [imagePath stringByAppendingString:self.playerName];
    
    NSURL *url = [NSURL URLWithString:headPath];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img;
    if (data) {
        img = [[UIImage alloc] initWithData:data];
    }else
    {
        img = [UIImage imageNamed:@"defaultHead"];
    }
    [self.headImage setImage:img];
    
    [self.ageLabel setText:[dic objectForKey:@"age"]];
    [self.sexImage setImage:[UIImage imageNamed:[dic objectForKey:@"sex"]]];
    [self.distanceLabel setText:[NSString stringWithFormat:@"%ld米",self.distance]];
    
    if ([[dic objectForKey:@"content"] isKindOfClass:[NSNull class]] || [[dic objectForKey:@"content"] isEqualToString:@"编辑个人签名..."]) {
        [self.signatureLabel setText:@"签名的力气都用去打dota了!"];

    }else
    {
        [self.signatureLabel setText:[dic objectForKey:@"content"]];
    }

    
    if ( [[dic objectForKey:@"isReviewed"] isKindOfClass:[NSNull class]] || [[dic objectForKey:@"isReviewed"] isEqualToString:@"no"]) {
       
        UILabel *noRecordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.achieveView.frame.size.width, self.achieveView.frame.size.height)];
        [noRecordLabel setText:@"暂无战绩认证"];
        noRecordLabel.textAlignment = NSTextAlignmentCenter;
        noRecordLabel.tag = 666;
        [noRecordLabel setBackgroundColor:[UIColor whiteColor]];
        
        [self.achieveView addSubview:noRecordLabel];
        
    }else
    {
        
       
        
        
//        [self.gameIDLabel setText:@"ID:不是故意的啥了"];
        [self.gameIDLabel setText:[NSString stringWithFormat:@"ID:%@",[dic objectForKey:@"gameID"]]];

        [self.JJCLabel setText:[dic objectForKey:@"JJCscore"]];
        [self.TTLabel setText:[dic objectForKey:@"TTscore"]];
        [self.soldierLabel setText:[dic objectForKey:@"soldier"]];
        [self.ratioLabel setText:[NSString stringWithFormat:@"胜率:%@%%",[dic objectForKey:@"WinRatio"]]];
        [self.heroFirstLabel setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[dic objectForKey:@"heroFirst"] ofType:@"jpg"]]];
        [self.heroSecondLabel setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[dic objectForKey:@"heroSecond"] ofType:@"jpg"]]];
        [self.heroThirdLabel setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[dic objectForKey:@"heroThird"] ofType:@"jpg"]]];
    }
    
    
}

#pragma mark -
#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView             // Default is 1 if not implemented
{
    return 1;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section   // fixed font style. use custom view (UILabel) if you want something different
//{
//    return @"留言板";
//}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 1, 60, 28)];
    title.backgroundColor = [UIColor clearColor];
    title.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];
    title.textColor = [UIColor colorWithRed:255/255.0f green:145/255.0f blue:0 alpha:1.0];
    [title setText:@"留言板"];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 3.5, 47, 25)];
    btn.backgroundColor = [UIColor purpleColor];
    btn.layer.cornerRadius = 4.2f;
    btn.layer.shadowOffset = CGSizeMake(1.5, 1.8);
    btn.layer.shadowRadius = 0.5;
    btn.layer.shadowOpacity = 0.4;
    
    btn.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13];
    [btn setTitle:@"留言" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leaveMesg) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
    [sectionView setBackgroundColor:[UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1.0]];
    [sectionView addSubview:btn];
    [sectionView addSubview:title];

    return sectionView;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    noteTableViewCell *cell =(noteTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"noteCell"];
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"noteTableViewCell" owner:self options:nil] objectAtIndex:0];//加载nib文件
    }
    cell.backgroundColor = [UIColor clearColor];
    
    cell.usernameLabel.text = self.visitorArray[indexPath.row];
    cell.noteTextLabel.text = self.notesArray[indexPath.row];
    
    NSArray *timeArray = [self.createTimeArray[indexPath.row] componentsSeparatedByString:@":"];
    if (timeArray.count == 3) {
        NSString *timeCreated = [[timeArray[0] stringByAppendingString:@":"] stringByAppendingString:timeArray[1]];
        cell.noteTimeLabel.text = timeCreated;

    }
    
    NSString *headPath = [imagePath stringByAppendingString:self.visitorArray[indexPath.row]];
    
    NSURL *url = [NSURL URLWithString:headPath];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img;

    if (data) {
        img = [[UIImage alloc] initWithData:data];
    }else
    {
        img = [UIImage imageNamed:@"defaultHead"];
    }

    [cell.userHeadImage setImage:img];
    
    [cell.cellNumber setText:[NSString stringWithFormat:@"%ld.",self.notesArray.count - indexPath.row]];
    
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leaveMesg
{
    NSLog(@"tao leave message...");
    
    [invisibleTextFiled setHidden:NO];
    invisibleTextFiled.placeholder = @"留言:";
    [invisibleTextFiled becomeFirstResponder];
//    UIView *sendNoteView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [sendNoteView setBackgroundColor:[UIColor clearColor]];
//
//    
//    [self.view addSubview:sendNoteView];
//    
//    UIView *sendNoteBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [sendNoteBack setBackgroundColor:[UIColor darkGrayColor]];
//    sendNoteBack.alpha = 0.6;
//    [sendNoteView addSubview:sendNoteBack];
//    
//    
//    
//    UITextView *noteText = [[UITextView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/10, SCREEN_HEIGHT*3/11, SCREEN_WIDTH*4/5, SCREEN_HEIGHT/3)];
//    [noteText setBackgroundColor:[UIColor yellowColor]];
//    
//    [sendNoteView addSubview:noteText];
//    
//    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(noteText.frame.origin.x+noteText.frame.size.width-80, noteText.frame.origin.y-32, 60, 30)];
//    [submit setTitle:@"提交" forState:UIControlStateNormal];
//    [sendNoteView addSubview:submit];
//    
//
//    [UIView animateWithDuration:0.2 delay:0.4 options:UIViewAnimationOptionCurveLinear animations:^{
//        [sendNoteView setCenter:CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT)/2)];
//    } completion:^(BOOL finished) {
//        
//    }];
//    [noteText becomeFirstResponder];
//
}



-(void)initCustomTextViewWithY:(CGFloat)pos_Y
{
    UIView *customTextView = [[UIView alloc] initWithFrame:CGRectMake(0, pos_Y, SCREEN_WIDTH, 40)];
    [customTextView setBackgroundColor:[UIColor whiteColor]];
    customTextView.tag = 777;
    invisibleTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(3, 2, customTextView.frame.size.width-6, 36)];
    invisibleTextFiled.placeholder = @"回复：";
    invisibleTextFiled.layer.borderWidth = 0.5;
    invisibleTextFiled.layer.cornerRadius = 7;
    invisibleTextFiled.layer.borderColor = [UIColor lightGrayColor].CGColor;
    invisibleTextFiled.delegate = self;
    invisibleTextFiled.returnKeyType = UIReturnKeyDone;
    
    invisibleTextFiled.tag = 7;
    
//    UIButton *doInput = [[UIButton alloc] initWithFrame:CGRectMake(customTextView.frame.size.width-78, 2, 75, 36)];
//    [doInput setTitle:@"输入" forState:UIControlStateNormal];
//    doInput.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
//    [doInput setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [doInput addTarget:self action:@selector(inputText) forControlEvents:UIControlEventTouchUpInside];
//    [customTextView addSubview:invisibleTextFiled];
//    [customTextView addSubview:doInput];
    [customTextView addSubview:invisibleTextFiled];

    //    [customTextView setHidden:YES];
    
    [self.view addSubview:customTextView];
    
    
    
}

-(void)addNewNote:(NSString *)content OfVisitor:(NSString *)visitorName
{
    if([content isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"留言不能为空,请确认" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
    
    NSDictionary *parameters = @{@"tag": @"addNote",@"username":self.playerName, @"content":content,@"visitor":visitorName};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:noteService parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        [hud hide:YES];
        
        NSLog(@"JSON: %@", responseObject);
        
        self.visitorArray = [responseObject objectForKey:@"visitor"];
        self.notesArray = [responseObject objectForKey:@"content"];
        self.createTimeArray = [responseObject objectForKey:@"createdAt"];


        [self.notePadTable reloadData];

        UIView *noRecordView = [self.view viewWithTag:555];
        if (noRecordView) {
            [noRecordView removeFromSuperview];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        [hud hide:YES];
        
        
    }];
    
    
}



-(void)fetchNote
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.dimBackground = YES;
    
    NSDictionary *parameters = @{@"tag": @"getNote",@"username":self.playerName};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:noteService parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        [hud hide:YES];
        
        NSLog(@"JSON: %@", responseObject);
        

        
        self.visitorArray = [responseObject objectForKey:@"visitor"];
        self.notesArray = [responseObject objectForKey:@"content"];
        self.createTimeArray = [responseObject objectForKey:@"createdAt"];
        
        
        [self.notePadTable reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        NSLog(@"JSON ERROR: %@",  operation.responseString);
        
        
        UILabel *noRecordLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.notePadTable.frame.origin.x, self.notePadTable.frame.origin.y+35, self.notePadTable.frame.size.width, self.notePadTable.frame.size.height-35) ];
        [noRecordLabel setText:@"暂无留言"];
        noRecordLabel.tag = 555;
        noRecordLabel.textAlignment = NSTextAlignmentCenter;
        [noRecordLabel setBackgroundColor:[UIColor whiteColor]];
        
        [self.view addSubview:noRecordLabel];
        
        [hud hide:YES];
        
        
    }];
    
    
}


-(void)inputText
{
    UIView *customTextView = [self.view viewWithTag:777];
    UITextField *txtField = (UITextField *)[customTextView viewWithTag:7];
    
    if ([[DataCenter sharedDataCenter] isGuest]) {
        
        [self addNewNote:txtField.text OfVisitor:@"匿名游客"];
    }else
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"haveDefaultUser"] isEqualToString:@"yes"]) {
            
            NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoDic"];
            
            [self addNewNote:txtField.text OfVisitor:[userDic objectForKey:@"username"]];

        }else
        {
            NSLog(@"unknown error..");
        }
        
    }
    
}



-(void)hideCustomTextView
{
    UIView *customTextView = [self.view viewWithTag:777];
    [invisibleTextFiled setText:@""];
    [UIView animateWithDuration: 0.01
                     animations: ^{
                         [customTextView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 40)];
                         
                     }
                     completion:nil
     ];
    
    
}




-(void)keyboardWasShown:(NSNotification*)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIView *customTextView = [self.view viewWithTag:777];
    [UIView animateWithDuration: 0.05
                     animations: ^{
                         [customTextView setFrame:CGRectMake(0, SCREEN_HEIGHT-keyboardSize.height-40, SCREEN_WIDTH, 40)];
                         
                     }
                     completion:nil
     ];
    [self.view layoutIfNeeded];
}
-(void)keyboardWillDismiss:(NSNotification*)notification
{
    [invisibleTextFiled resignFirstResponder];
    [self hideCustomTextView];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self inputText];
    
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}
@end
