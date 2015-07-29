//
//  YoukuWebView.m
//  dotaer
//
//  Created by Eric Cao on 7/28/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "YoukuWebView.h"
//#import "CocoaSecurity.h"
#import "globalVar.h"
#import <CommonCrypto/CommonDigest.h>

@implementation YoukuWebView


- (NSString *)md5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result[i]];
    }
    return ret;
}

- (id)initWithFrame:(CGRect)frame andVideoId:(NSString*)vid{
    self = [super initWithFrame:frame];
    if (self) {
        [self.scrollView setScrollEnabled:NO];
        [self setBackgroundColor:[UIColor blackColor]];
        time_t stamp = [[NSDate date] timeIntervalSince1970];
        NSString *md5 = [self md5HexDigest:[NSString stringWithFormat:@"%@_%lu_%@", vid, stamp, client_secret]];
        self.embsig = [NSString stringWithFormat:@"1_%lu_%@", stamp, md5];
        
        NSString *youkuPlayHtml = [NSString stringWithFormat:[[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"youku_play" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil], vid, self.embsig];
        
        [self loadHTMLString:youkuPlayHtml baseURL:[[NSBundle mainBundle] bundleURL]];
    }
    return self;
}


-(void)startPlayWithID
{
    
    
   NSString *result = [self stringByEvaluatingJavaScriptFromString:@"playVideo();"];
    NSLog(@"resu:%@",result);

    
}


@end
