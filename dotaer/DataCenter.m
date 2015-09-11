//
//  DataCenter.m
//  dotaer
//
//  Created by Eric Cao on 7/20/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "DataCenter.h"

@implementation DataCenter
@synthesize userImgDic;

+ (id)sharedDataCenter {
    static DataCenter *sharedMyDataCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyDataCenter = [[self alloc] init];
    });
    return sharedMyDataCenter;
}


-(id)init
{
    self = [super init];
    if (self)
    {
        userImgDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (id)fetchFavors {
    
    
    NSMutableArray *favorArray =[NSMutableArray arrayWithArray: [[NSUserDefaults standardUserDefaults] objectForKey:@"favor"]];
    if(favorArray)
        return favorArray;
    else
        return nil;
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


-(UIImage *)compressImage:(UIImage *)image{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 300.0;
    float maxWidth = 300.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.1;//20 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
}



+ (BOOL)myContainsStringFrom:(NSString*)str ForSting:(NSString*)other {
    NSRange range = [str rangeOfString:other];
    return range.length != 0;
}

@end
