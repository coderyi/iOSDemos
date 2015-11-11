//
//  ViewController.m
//  ObjCInjectCodeDemo
//
//  Created by coderyi on 15/11/10.
//  Copyright © 2015年 coderyi. All rights reserved.
//

#import "ViewController.h"
#import "NetworkObserver.h"
@interface ViewController ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NetworkObserver setEnabled:YES];

    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btSendRequest=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btSendRequest];
    [btSendRequest addTarget:self action:@selector(btSendRequestAction) forControlEvents:UIControlEventTouchUpInside];
    btSendRequest.frame=CGRectMake(([[UIScreen mainScreen] bounds].size.width-190)/2, 170, 190, 40);
    [btSendRequest setTitle:@"send request" forState:UIControlStateNormal];
    [btSendRequest setTitleColor:[UIColor colorWithRed:0.24f green:0.51f blue:0.78f alpha:1.00f] forState:UIControlStateNormal];
    btSendRequest.layer.borderColor=[UIColor colorWithRed:0.24f green:0.51f blue:0.78f alpha:1.00f].CGColor;
    btSendRequest.layer.borderWidth=0.4;
    
    UIButton *btRequestWithDelegate=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btRequestWithDelegate];
    [btRequestWithDelegate addTarget:self action:@selector(btRequestWithDelegateAction) forControlEvents:UIControlEventTouchUpInside];
    btRequestWithDelegate.frame=CGRectMake(([[UIScreen mainScreen] bounds].size.width-190)/2, 225, 190, 40);
    [btRequestWithDelegate setTitle:@"request with delegate" forState:UIControlStateNormal];
    [btRequestWithDelegate setTitleColor:[UIColor colorWithRed:0.24f green:0.51f blue:0.78f alpha:1.00f] forState:UIControlStateNormal];
    btRequestWithDelegate.layer.borderColor=[UIColor colorWithRed:0.24f green:0.51f blue:0.78f alpha:1.00f].CGColor;
    btRequestWithDelegate.layer.borderWidth=0.4;
    
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)btSendRequestAction{
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.github.com/search/users?q=language:objective-c&sort=followers&order=desc"]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"[get normal response] send request %@",response.URL);
    }];
    
}

- (void)btRequestWithDelegateAction{

    NSString *urlString =@"https://api.github.com/repos/coderyi/Monkey";
    NSString *encodeURLString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodeURLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];
    
}
#pragma clang diagnostic pop

- (nullable NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(nullable NSURLResponse *)response{
    
    NSLog(@"[get normal request]request with delegate ");
    return request;
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSLog(@"[get normal response] request with delegate");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
