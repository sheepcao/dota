//
//  myPointAnnotation.h
//  dotaer
//
//  Created by Eric Cao on 7/15/15.
//  Copyright © 2015 sheepcao. All rights reserved.
//

#import <BaiduMapAPI/BMKPointAnnotation.h>
#import "userInfo.h"

@interface myPointAnnotation : BMKPointAnnotation

@property (nonatomic ,strong) NSMutableArray *containUsers;
@property (nonatomic ,strong) NSString *annoUserInfo;
@property NSUInteger annoUserDistance;
@property (nonatomic ,strong) NSString *annoUserGeo;
@property (nonatomic ,strong) NSString *annoUserSex;


@end
