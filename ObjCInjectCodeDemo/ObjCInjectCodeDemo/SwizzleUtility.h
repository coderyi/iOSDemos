//
//  SwizzleUtility.h
//  ObjCInjectCodeDemo
//
//  Created by coderyi on 15/11/10.
//  Copyright © 2015年 coderyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface SwizzleUtility : NSObject

// Swizzling utilities

+ (SEL)swizzledSelectorForSelector:(SEL)selector;
+ (void)replaceImplementationOfKnownSelector:(SEL)originalSelector onClass:(Class)class withBlock:(id)block swizzledSelector:(SEL)swizzledSelector;
+ (void)replaceImplementationOfSelector:(SEL)selector withSelector:(SEL)swizzledSelector forClass:(Class)cls withMethodDescription:(struct objc_method_description)methodDescription implementationBlock:(id)implementationBlock undefinedBlock:(id)undefinedBlock;

@end
