//
//  myPointAnnotation.m
//  dotaer
//
//  Created by Eric Cao on 7/15/15.
//  Copyright © 2015 sheepcao. All rights reserved.
//

#import "myPointAnnotation.h"

@implementation myPointAnnotation


-(id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.containUsers = [[NSMutableArray alloc] init];
    return self;
 
}

@end
