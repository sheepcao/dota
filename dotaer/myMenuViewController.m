//
//  myMenuViewController.m
//  dotaer
//
//  Created by Eric Cao on 7/6/15.
//  Copyright (c) 2015 sheepcao. All rights reserved.
//

#import "myMenuViewController.h"
#import "IIViewDeckController.h"

@interface myMenuViewController ()<IIViewDeckControllerDelegate>

@end

@implementation myMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)viewDeckController:(IIViewDeckController *)viewDeckController applyShadow:(CALayer *)shadowLayer withBounds:(CGRect)rect {
//
//    NSLog(@"shadow~~~~");
//    
//    shadowLayer.masksToBounds = NO;
//    shadowLayer.shadowRadius = 10;
//    shadowLayer.shadowOpacity = 0.9;
//    shadowLayer.shadowColor = [[UIColor yellowColor] CGColor];
//    shadowLayer.shadowOffset = CGSizeZero;
//    shadowLayer.shadowPath = [[UIBezierPath bezierPathWithRect:rect] CGPath];
//}
@end
