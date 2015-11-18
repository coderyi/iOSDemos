//
//  ViewController.m
//  HostToAddressDemo
//
//  Created by coderyi on 15/11/13.
//  Copyright © 2015年 coderyi. All rights reserved.
//

#import "ViewController.h"
#import <arpa/inet.h>
#import <CFNetwork/CFHost.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testCF];
    [self hostToAddress];
}

//http://www.zhihu.com/question/30145194
//ios通过域名获取ip问题？
- (void)testCF{
    
    
    NSString *hostname = @"baidu.com";
    CFHostRef hostRef = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)hostname);
    if (hostRef)
    {
        Boolean result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL);
        if (result == TRUE)
        {
            NSArray *addresses = (__bridge NSArray*)CFHostGetAddressing(hostRef, &result);
            
            NSMutableArray *tempDNS = [[NSMutableArray alloc] init];
            for(int i = 0; i < addresses.count; i++)
            {
                struct sockaddr_in* remoteAddr;
                CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex((__bridge CFArrayRef)addresses, i);
                remoteAddr = (struct sockaddr_in*)CFDataGetBytePtr(saData);
                
                if(remoteAddr != NULL)
                {
                    const char *strIP41 = inet_ntoa(remoteAddr->sin_addr);
                    
                    NSString *strDNS =[NSString stringWithCString:strIP41 encoding:NSASCIIStringEncoding];
                    NSLog(@"RESOLVED %d:<%@>", i, strDNS);
                    [tempDNS addObject:strDNS];
                }
            }
        }
    }
}

//http://stackoverflow.com/questions/11481610/how-to-create-cfarrayref  跟上面一样的
- (void)hostToAddress{
    Boolean result;
    CFHostRef hostRef;
    NSArray *addresses;
    NSString *hostname = @"baidu.com";
    hostRef = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)hostname);
    if (hostRef) {
        result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL); // pass an error instead of NULL here to find out why it failed
        if (result == TRUE) {
            addresses = (__bridge NSArray*)CFHostGetAddressing(hostRef, &result);
        }
    }
    if (result == TRUE) {
        NSMutableArray *tempDNS = [[NSMutableArray alloc] init];
        for(int i = 0; i < CFArrayGetCount( (__bridge CFArrayRef)addresses); i++){
            struct sockaddr_in* remoteAddr;
            CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex( (__bridge CFArrayRef)addresses, i);
            remoteAddr = (struct sockaddr_in*)CFDataGetBytePtr(saData);
            
            if(remoteAddr != NULL){
                // Extract the ip address
                //const char *strIP41 = inet_ntoa(remoteAddr->sin_addr);
                NSString *strDNS =[NSString stringWithCString:inet_ntoa(remoteAddr->sin_addr) encoding:NSASCIIStringEncoding];
                NSLog(@"Resolved %d:<%@>", i, strDNS);
                [tempDNS addObject:strDNS];
            }
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
