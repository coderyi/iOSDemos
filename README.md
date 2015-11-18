# iOSDemos
HostToAddressDemo:1113,利用CFHost域名转IP地址

ObjCInjectCodeDemo:1111,Objective-C代码注入－拦截NSURLConnection的消息

ForwardInvocationDemo:1030,消息转发

因为要解决下面这个bug
-[XXXClass rangeOfCharacterFromSet:]: unrecognized selector sent to instance 0x7ff1d2515cb0
所以在该类中把消息转发到NSString对象（这里转发到XXXClass类中的一个NSString属性的对象）的rangeOfCharacterFromSet中就可以了。

ReflectUtil:1023,利用runtime反射出一个对象的所有属性和对应的值

CoreDataDemo：1021，CoreData的简单使用

