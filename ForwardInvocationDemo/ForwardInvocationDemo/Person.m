//
//  Person.m
//  ForwardInvocationDemo
//
//  Created by coderyi on 15/10/30.
//  Copyright © 2015年 coderyi. All rights reserved.
//

#import "Person.h"
#import "Bird.h"
@implementation Person
-(NSMethodSignature*) methodSignatureForSelector:(SEL)selector
{
    //首先调用父类的方法
    NSMethodSignature *signature=
    [super methodSignatureForSelector: selector];
    
    //如果当前对象无法回应此selector，那么selector构造的方法签名必然为nil
    if (!signature)
    {
        //首先判断Bird的实例是否有能力回应此selector
        if ([Bird instancesRespondToSelector:selector])
        {
            //获取Bird的selector的方法签名对象
            signature=[Bird instanceMethodSignatureForSelector:selector];
        }
    }
    
    return signature;
}

-(void) forwardInvocation: (NSInvocation*) invocation
{
    //首先验证Bird是否有能力回应invocation中包含的selector
    if ([Bird instancesRespondToSelector:[invocation selector]])
    {
        //创建要移交消息响应权的实例bird
        Bird *bird=[Bird new];
        
        //激活invocation中的消息，但是消息的响应者是bird，而不是默认的self。
        [invocation invokeWithTarget:bird];
    }
}
@end
