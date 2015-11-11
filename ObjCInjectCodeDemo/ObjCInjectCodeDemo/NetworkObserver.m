//
//  NetworkObserver.m
//  ObjCInjectCodeDemo
//
//  Created by coderyi on 15/11/10.
//  Copyright © 2015年 coderyi. All rights reserved.
//

#import "NetworkObserver.h"
#import "SwizzleUtility.h"
#import <objc/message.h>

@interface NetworkObserver (NSURLConnectionHelpers)

- (void)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response delegate:(id <NSURLConnectionDelegate>)delegate;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response delegate:(id <NSURLConnectionDelegate>)delegate;

@end


@interface NetworkObserver ()

@end


@implementation NetworkObserver


+ (void)setEnabled:(BOOL)enabled
{
    
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"com.coderyi.enableOnLaunch"];
    if (enabled) {
        //注入的时候用dispatch_once保护，所以你可以调用多次
        [self injectIntoAllNSURLConnectionDelegateClasses];
    }
    
}

+ (BOOL)isEnabled
{
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.coderyi.enableOnLaunch"] boolValue];
    
}

+ (instancetype)sharedObserver
{
    static NetworkObserver *sharedObserver = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObserver = [[[self class] alloc] init];
    });
    return sharedObserver;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//扫描项目中所有的类
+ (void)injectIntoAllNSURLConnectionDelegateClasses
{

    // Only allow swizzling once.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        const SEL selectors[] = {
            @selector(connection:willSendRequest:redirectResponse:),
            @selector(connection:didReceiveResponse:),
        };
        
        const int numSelectors = sizeof(selectors) / sizeof(SEL);
        
        Class *classes = NULL;
        int numClasses = objc_getClassList(NULL, 0);
        
        if (numClasses > 0) {
            classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
            numClasses = objc_getClassList(classes, numClasses);//获取项目中所有的类
            for (NSInteger classIndex = 0; classIndex < numClasses; ++classIndex) {
                Class class = classes[classIndex];
                
                if (class == [NetworkObserver class]) {
                    continue;
                }
                
                unsigned int methodCount = 0;
                Method *methods = class_copyMethodList(class, &methodCount);
                BOOL matchingSelectorFound = NO;
                for (unsigned int methodIndex = 0; methodIndex < methodCount; methodIndex++) {
                    for (int selectorIndex = 0; selectorIndex < numSelectors; ++selectorIndex) {
                        if (method_getName(methods[methodIndex]) == selectors[selectorIndex]) {
                            [self injectWillSendRequestIntoDelegateClass:class];
                            [self injectDidReceiveResponseIntoDelegateClass:class];
                            matchingSelectorFound = YES;
                            break;
                        }
                    }
                    if (matchingSelectorFound) {
                        break;
                    }
                }
                free(methods);
            }
            
            free(classes);
        }
        
        [self injectIntoNSURLConnectionAsynchronousClassMethod];
        
    });
    
}

//注入代码到类方法sendAsynchronousRequest:queue:completionHandler:
+ (void)injectIntoNSURLConnectionAsynchronousClassMethod
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = objc_getMetaClass(class_getName([NSURLConnection class]));
        SEL selector = @selector(sendAsynchronousRequest:queue:completionHandler:);
        SEL swizzledSelector = [SwizzleUtility swizzledSelectorForSelector:selector];
        
        typedef void (^NSURLConnectionAsyncCompletion)(NSURLResponse* response, NSData* data, NSError* connectionError);
        
        void (^asyncSwizzleBlock)(Class, NSURLRequest *, NSOperationQueue *, NSURLConnectionAsyncCompletion) = ^(Class slf, NSURLRequest *request, NSOperationQueue *queue, NSURLConnectionAsyncCompletion completion) {
            if ([NetworkObserver isEnabled]) {
          
                NSLog(@"[runtime catch request] send request %@",request.URL);

                NSURLConnectionAsyncCompletion completionWrapper = ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    
                    // Call through to the original completion handler
                    if (completion) {
                        completion(response, data, connectionError);
                    }
                };
                ((void(*)(id, SEL, id, id, id))objc_msgSend)(slf, swizzledSelector, request, queue, completionWrapper);
            } else {
                ((void(*)(id, SEL, id, id, id))objc_msgSend)(slf, swizzledSelector, request, queue, completion);
            }
        };
        
        [SwizzleUtility replaceImplementationOfKnownSelector:selector onClass:class withBlock:asyncSwizzleBlock swizzledSelector:swizzledSelector];
    });
    
}

//注入代码到delegate方法的connection:willSendRequest:redirectResponse:
+ (void)injectWillSendRequestIntoDelegateClass:(Class)cls
{
    
    SEL selector = @selector(connection:willSendRequest:redirectResponse:);
    SEL swizzledSelector = [SwizzleUtility swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLConnectionDataDelegate);
    if (!protocol) {
        protocol = @protocol(NSURLConnectionDelegate);
    }
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef NSURLRequest *(^NSURLConnectionWillSendRequestBlock)(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLRequest *request, NSURLResponse *response);
    
    NSURLConnectionWillSendRequestBlock undefinedBlock = ^NSURLRequest *(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLRequest *request, NSURLResponse *response) {
        [[NetworkObserver sharedObserver] connection:connection willSendRequest:request redirectResponse:response delegate:slf];
        
        return request;
    };
    
    NSURLConnectionWillSendRequestBlock implementationBlock = ^NSURLRequest *(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLRequest *request, NSURLResponse *response) {
        __block NSURLRequest *returnValue = nil;
        undefinedBlock(slf, connection, request, response);
        returnValue = ((id(*)(id, SEL, id, id, id))objc_msgSend)(slf, swizzledSelector, connection, request, response);
        
        
        return returnValue;
    };
    
    [SwizzleUtility replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
    
}

//注入到delegate方法的connection:didReceiveResponse:
+ (void)injectDidReceiveResponseIntoDelegateClass:(Class)cls
{
    
    SEL selector = @selector(connection:didReceiveResponse:);
    SEL swizzledSelector = [SwizzleUtility swizzledSelectorForSelector:selector];
    
    Protocol *protocol = @protocol(NSURLConnectionDataDelegate);
    if (!protocol) {
        protocol = @protocol(NSURLConnectionDelegate);
    }
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    
    typedef void (^NSURLConnectionDidReceiveResponseBlock)(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLResponse *response);
    
    NSURLConnectionDidReceiveResponseBlock undefinedBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLResponse *response) {
        [[NetworkObserver sharedObserver] connection:connection didReceiveResponse:response delegate:slf];
    };
    
    NSURLConnectionDidReceiveResponseBlock implementationBlock = ^(id <NSURLConnectionDelegate> slf, NSURLConnection *connection, NSURLResponse *response) {
        undefinedBlock(slf, connection, response);
        ((void(*)(id, SEL, id, id))objc_msgSend)(slf, swizzledSelector, connection, response);


    };
    
    [SwizzleUtility replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription implementationBlock:implementationBlock undefinedBlock:undefinedBlock];
    
}



@end


@implementation NetworkObserver (NSURLConnectionHelpers)

- (void)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response delegate:(id<NSURLConnectionDelegate>)delegate
{
    
    NSLog(@"[runtime catch request] request with delegate   %@",request.URL);

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response delegate:(id<NSURLConnectionDelegate>)delegate
{
    
    NSLog(@"[runtime catch response]  request with delegate %@",response.URL);

}

@end
