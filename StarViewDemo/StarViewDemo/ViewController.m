//
//  ViewController.m
//  StarViewDemo
//
//  Created by coderyi on 15/12/25.
//  Copyright © 2015年 coderyi. All rights reserved.
//

#import "ViewController.h"
#import "StarView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    StarView *starView=[[StarView alloc] initWithFrame:CGRectMake(100, 100, 67, 10)];
    [self.view addSubview:starView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
