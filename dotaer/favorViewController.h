//
//  favorViewController.h
//  dotaer
//
//  Created by Eric Cao on 7/31/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>


@interface favorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *favorTable;
@property(strong,nonatomic) NSMutableArray *favorArray;

@property BOOL isFromFavor;
@property NSUInteger distance;
@property (nonatomic, assign) CLLocationCoordinate2D userPosition;
@end
