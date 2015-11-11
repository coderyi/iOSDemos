//
//  NetworkObserver.h
//  ObjCInjectCodeDemo
//
//  Created by coderyi on 15/11/10.
//  Copyright © 2015年 coderyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkObserver : NSObject
+ (void)setEnabled:(BOOL)enabled;
+ (BOOL)isEnabled;
@end
