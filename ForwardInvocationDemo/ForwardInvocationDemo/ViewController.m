//
//  ViewController.m
//  ForwardInvocationDemo
//
//  Created by coderyi on 15/10/30.
//  Copyright © 2015年 coderyi. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Person *person=[[Person alloc] init];
    [person performSelector:@selector(fly) withObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
