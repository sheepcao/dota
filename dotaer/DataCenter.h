//
//  DataCenter.h
//  dotaer
//
//  Created by Eric Cao on 7/20/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCenter : NSObject

@property BOOL isGuest;
@property BOOL needConfirmLevelInfo;
//@property (nonatomic,strong) NSMutableArray *favorArray;


+ (id)sharedDataCenter ;
- (BOOL)checkFavor:(NSString *)username;
- (void)addFavor:(NSString *)username;
- (void)removeFavor:(NSString *)username;
@end
