//
//  DataCenter.h
//  dotaer
//
//  Created by Eric Cao on 7/20/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DataCenter : NSObject

@property BOOL isGuest;
@property BOOL needConfirmLevelInfo;
@property BOOL needLoginDefault;

@property BOOL guestFromLogin;
@property BOOL memberFromLogin;

@property (strong,nonatomic) NSMutableDictionary *userImgDic;
//@property (nonatomic,strong) NSMutableArray *favorArray;


+ (id)sharedDataCenter ;

- (void)clearRequestCache;
- (id)fetchFavors;
- (BOOL)checkFavor:(NSString *)username;
- (void)addFavor:(NSString *)username;
- (void)removeFavor:(NSString *)username;

+ (BOOL)myContainsStringFrom:(NSString*)str ForSting:(NSString*)other;

-(UIImage *)compressImage:(UIImage *)image;
@end
