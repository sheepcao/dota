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
@property (strong,nonatomic) NSMutableDictionary *userImgDic;
//@property (nonatomic,strong) NSMutableArray *favorArray;


+ (id)sharedDataCenter ;
- (id)fetchFavors;
- (BOOL)checkFavor:(NSString *)username;
- (void)addFavor:(NSString *)username;
- (void)removeFavor:(NSString *)username;

-(UIImage *)compressImage:(UIImage *)image;
@end
