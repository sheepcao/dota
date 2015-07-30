//
//  DataCenter.m
//  dotaer
//
//  Created by Eric Cao on 7/20/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "DataCenter.h"

@implementation DataCenter


+ (id)sharedDataCenter {
    static DataCenter *sharedMyDataCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyDataCenter = [[self alloc] init];
    });
    return sharedMyDataCenter;
}


- (BOOL)checkFavor:(NSString *)username {

    NSMutableArray *favorArray =[NSMutableArray arrayWithArray: [[NSUserDefaults standardUserDefaults] objectForKey:@"favor"]];

    for (NSString *ele in favorArray) {
        if ([ele isEqualToString:username]) {
            return YES;
        }
    }
    return NO;
}
- (void)addFavor:(NSString *)username {
    
    NSMutableArray *favorArray =[NSMutableArray arrayWithArray: [[NSUserDefaults standardUserDefaults] objectForKey:@"favor"]];
    
    [favorArray addObject:username];
    NSArray *saveArray = [NSArray arrayWithArray:favorArray];
    
    [[NSUserDefaults standardUserDefaults] setObject:saveArray forKey:@"favor"];
    
}
- (void)removeFavor:(NSString *)username {
    
    NSMutableArray *favorArray =[NSMutableArray arrayWithArray: [[NSUserDefaults standardUserDefaults] objectForKey:@"favor"]];
    

    if ([self checkFavor:username]) {
        [favorArray removeObject:username];
    } ;
    NSArray *saveArray = [NSArray arrayWithArray:favorArray];
    
    [[NSUserDefaults standardUserDefaults] setObject:saveArray forKey:@"favor"];
    
}

@end
