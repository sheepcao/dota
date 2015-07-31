//
//  globalVar.h
//  dotaer
//
//  Created by Eric Cao on 7/6/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#ifndef dotaer_globalVar_h
#define dotaer_globalVar_h


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define registerService @"http://localhost/~ericcao/upload.php"
#define playerInfoService @"http://localhost/~ericcao/playerInfo.php"
#define signatureService @"http://localhost/~ericcao/signature.php"
#define noteService @"http://localhost/~ericcao/note.php"

#define imagePath @"http://localhost/~ericcao/upload/"

#define client_secret @"2d43c235b66c114fece5f67ae504f70a"


#define videoInfoService @"http://localhost/~ericcao/videoURL.php"

#import "MBProgressHUD.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "MobClick.h"


#define REVIEW_URL @"https://itunes.apple.com/us/app/anime-face/id983454917?ls=1&mt=8"
#define VERSIONNUMBER   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#endif


