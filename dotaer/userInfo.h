//
//  userInfo.h
//  dotaer
//
//  Created by Eric Cao on 7/14/15.
//  Copyright © 2015 sheepcao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userInfo : NSObject

@property (nonatomic ,strong) NSString *username;
@property (nonatomic ,strong) NSString *age;
@property (nonatomic ,strong) NSString *sex;
@property (nonatomic ,strong) NSString *email;
@property (nonatomic ,strong) NSString *createTime;
@property (nonatomic ,strong) NSString *id_DB;

@property (nonatomic ,strong) NSString *headImagePath;

@end
