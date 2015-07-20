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

@end
