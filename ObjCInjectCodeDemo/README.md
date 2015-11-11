##Objective-C代码注入－拦截NSURLConnection的消息

2015.11.11

#####混淆一个方法

<pre>
    Class class = objc_getMetaClass(class_getName([NSURLConnection class]));
    SEL originalSelector = @selector(sendAsynchronousRequest:queue:completionHandler:);
    SEL swizzledSelector =NSSelectorFromString([NSString stringWithFormat:@"_coderyi_swizzle_%x_%@", arc4random(), NSStringFromSelector(selector)]);
</pre>
其实在ObjC中class有两种，一个是对象，一个是类，[NSURLConnection class]或者objc_getClass获取到的是objc_object，而objc_getMetaClass获取到的是objc_class，这里因为sendAsynchronousRequest:queue:completionHandler:是类方法，所有需要使用objc_getMetaClass。objc_class可以通过objc_object的isa.cls获得。



####消息和方法的动态绑定
<pre>
        typedef void (^NSURLConnectionAsyncCompletion)(NSURLResponse* response, NSData* data, NSError* connectionError);
        
        void (^asyncSwizzleBlock)(Class, NSURLRequest *, NSOperationQueue *, NSURLConnectionAsyncCompletion) = ^(Class slf, NSURLRequest *request, NSOperationQueue *queue, NSURLConnectionAsyncCompletion completion) {
                NSLog(@"i get the request url:  %@",request.URL);
 
                ((void(*)(id, SEL, id, id, id))objc_msgSend)(slf, swizzledSelector, request, queue, completion);

        };
        
        
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    if (!originalMethod) {
        return;
    }
    
    IMP implementation = imp_implementationWithBlock(asyncSwizzleBlock);
    class_addMethod(class, swizzledSelector, implementation, method_getTypeEncoding(originalMethod));
    Method newMethod = class_getInstanceMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, newMethod);
</pre>


这里主要是把自己的消息增加到NSURLConnection类中，并且这条消息会经过asyncSwizzleBlock,block会实现这个方法，这样就能够拦截sendAsynchronousRequest:queue:completionHandler:消息的内容，包括请求的URL等。

imp_implementationWithBlock的作用是方法被调用的时候，创建一个函数指针，这样就会调用这个block了，在block里面你可以知道这个消息的细节，并且你必须需要自己发送这个消息，你可以通过objc_msgSend函数完成。

objc_msgSend的函数具体是这样的，你需要把方法的返回值，以及每一个参数加上。
<pre>
id objc_msgSend(id self, SEL op, arg1, arg2, ...)
</pre>


关于swizzledSelector你首先需要通过class_addMethod加入到class的方法里面，然后再把刚刚加入的混淆方法，替换掉旧的方法，你可以通过method_exchangeImplementations函数实现。

注意class_addMethod将会覆盖父类的方法，但不会取代本类的方法，如果需要取代本类，可以用method_setImplementation等函数实现，这里就用method_exchangeImplementations。



######获取哪些类实现了delegate

<pre>
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
</pre>

这里的作用是扫描项目中有哪些类实现了NSURLConnectionDataDelegate的connection:willSendRequest:redirectResponse:和connection:didReceiveResponse:方法，objc_getClassList函数就是获取项目中所有的类，扫描每一个类，当得到一个类之后你可以通过class_copyMethodList函数获取到所有的方法，然后你就可以对相应的类注入自己的方法了。


#####动态绑定delegate的消息

<pre>
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

IMP implementation = imp_implementationWithBlock((id)([cls instancesRespondToSelector:selector] ? implementationBlock : undefinedBlock));
    
    Method oldMethod = class_getInstanceMethod(cls, selector);
    if (oldMethod) {
        class_addMethod(cls, swizzledSelector, implementation, methodDescription.types);
        
        Method newMethod = class_getInstanceMethod(cls, swizzledSelector);
        
        method_exchangeImplementations(oldMethod, newMethod);
    } else {
        class_addMethod(cls, selector, implementation, methodDescription.types);
    }

</pre>

因为class_addMethod时候需要关于方法的描述，所以需要NSURLConnectionDataDelegate中connection:willSendRequest:redirectResponse:的方法描述，可以通过函数protocol_getMethodDescription获得，关方法的实现block需要判断类(这里是ViewController实现了delegate)是否实现该方法，如果没有实现则到此为止，如果有实现connection:willSendRequest:redirectResponse:方法则需要在拦截到消息之后再把消息发送出去。

以上代码，来自我写的一个Demo,[ObjCInjectCodeDemo](https://github.com/coderyi/iOSDemos/tree/master/ObjCInjectCodeDemo)

我演示的是拦截网络请求，当然你如果需要这方面的功能，可以看看我写的网路调试库,[NetworkEye](https://github.com/coderyi/NetworkEye)
####参考链接
[Apple Objective-C Runtime Reference](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ObjCRuntimeRef/)

[apple runtime source code](https://opensource.apple.com/tarballs/objc4/)

[Objective-C Runtime Programming Guide](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Introduction/Introduction.html)

[Objective-C Runtime Programming Guide 中文](http://wenku.baidu.com/view/1e06c9a20029bd64783e2cd1.htm)

转载请附本文链接[https://github.com/coderyi/blog/blob/master/articles/2015/1111_objective-c_inject_code.md](https://github.com/coderyi/blog/blob/master/articles/2015/1111_objective-c_inject_code.md)


