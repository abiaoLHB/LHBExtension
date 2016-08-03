//
//  ViewController.m
//  LHBExtension
//
//  Created by LHB on 16/8/3.
//  Copyright © 2016年 LHB. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+LHBColorExtension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = [UIColor lhb_colorWithHexString:@"FF0000"];

    [self.view addSubview:view];
}

@end
