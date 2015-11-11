//
//  SwizzleUtility.m
//  ObjCInjectCodeDemo
//
//  Created by coderyi on 15/11/10.
//  Copyright © 2015年 coderyi. All rights reserved.
//

#import "SwizzleUtility.h"

@implementation SwizzleUtility

//混淆某方法
+ (SEL)swizzledSelectorForSelector:(SEL)selector
{
    
    return NSSelectorFromString([NSString stringWithFormat:@"_coderyi_swizzle_%x_%@", arc4random(), NSStringFromSelector(selector)]);
    
}

//这个方法只适合混淆方法已经存在在类中的
+ (void)replaceImplementationOfKnownSelector:(SEL)originalSelector onClass:(Class)class withBlock:(id)block swizzledSelector:(SEL)swizzledSelector
{
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    if (!originalMethod) {
        return;
    }
    
    IMP implementation = imp_implementationWithBlock(block);
    class_addMethod(class, swizzledSelector, implementation, method_getTypeEncoding(originalMethod));
    Method newMethod = class_getInstanceMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, newMethod);
    
}

//混淆delegate的方法
+ (void)replaceImplementationOfSelector:(SEL)selector withSelector:(SEL)swizzledSelector forClass:(Class)cls withMethodDescription:(struct objc_method_description)methodDescription implementationBlock:(id)implementationBlock undefinedBlock:(id)undefinedBlock
{
    
    IMP implementation = imp_implementationWithBlock((id)([cls instancesRespondToSelector:selector] ? implementationBlock : undefinedBlock));
    
    Method oldMethod = class_getInstanceMethod(cls, selector);
    if (oldMethod) {
        class_addMethod(cls, swizzledSelector, implementation, methodDescription.types);
        
        Method newMethod = class_getInstanceMethod(cls, swizzledSelector);
        
        method_exchangeImplementations(oldMethod, newMethod);
    } else {
        class_addMethod(cls, selector, implementation, methodDescription.types);
    }
    
}

@end
