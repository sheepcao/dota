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

+ (id)sharedDataCenter ;
@end
