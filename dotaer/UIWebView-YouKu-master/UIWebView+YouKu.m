//
//  UIWebView+YouKu.m
//  GameHouse
//
//  Created by wanyakun on 13-4-15.
//  Copyright (c) 2013年 the9. All rights reserved.
//

#import "UIWebView+YouKu.h"

@implementation UIWebView (YouKu)

-(NSString *)youKuVideoURLFromVideoID:(NSString *)videoID{
    return [NSString stringWithFormat:@"http://http://v.youku.com/v_show/%@",videoID];
}

-(NSString *)youKuEmbedHTMLFromVideoID:(NSString *)videoID{
    
    NSString *htmlString = @"<html><head> <meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = \"%f\"/></head> <body style=\"background:#000000;margin-top:0px;margin-left:0px\"> <iframe width= \"%f\" height=\"%f\" src = \"http://player.youku.com/embed/%@?=\" frameborder=\"0\" allowfullscreen></iframe></div></body></html>";
    
    //
    //    NSString *htmlString = @"<html><head> <meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = \"%f\"/></head> <body style=\"background:#000000;margin-top:0px;margin-left:0px\"> <div><object width=\"%f\" height=\"%f\"> <param name=\"movie\" value=\"%@\"></param> <param name=\"wmode\" value=\"transparent\"></param> <embed src=\"%@\" type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"%f\" height=\"%f\"></embed> </object></div></body></html>";
    
    // Populate HTML with the URL and requested frame size
    NSString *html = [NSString stringWithFormat:htmlString,self.frame.size.width,self.frame.size.width,self.frame.size.height,videoID];
    
    //  #ifdef DEBUG
    // #endif
    
    return html;
    
}

-(void)loadYouKuVideoID:(NSString*)videoID{
    
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = NO;
    
    NSString *fileName = [NSString stringWithFormat:@"id_%@=.html",videoID];
    
    //set local path for file
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",
                          [NSSearchPathForDirectoriesInDomains(
                                                               NSCachesDirectory
                                                               ,NSUserDomainMask, YES) objectAtIndex:0],
                          fileName];
    
    NSData *data = [[self youKuEmbedHTMLFromVideoID:videoID]
                    dataUsingEncoding:NSUTF8StringEncoding];
    
    //write data to file
    [data writeToFile:filePath atomically:YES];
#ifdef DEBUG
    NSLog(@"WebView Category about to load from HTML file!");
#endif
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: filePath]]];
}

@end
