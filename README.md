# iOSDemos
##ObjCDemos
HostToAddressDemo:1113,利用CFHost域名转IP地址

ObjCInjectCodeDemo:1111,Objective-C代码注入－拦截NSURLConnection的消息

ForwardInvocationDemo:1030,消息转发

因为要解决下面这个bug
-[XXXClass rangeOfCharacterFromSet:]: unrecognized selector sent to instance 0x7ff1d2515cb0
所以在该类中把消息转发到NSString对象（这里转发到XXXClass类中的一个NSString属性的对象）的rangeOfCharacterFromSet中就可以了。

ReflectUtil:1023,利用runtime反射出一个对象的所有属性和对应的值

CoreDataDemo：1021，CoreData的简单使用

StarViewDemo：12.25星星评分视图

####社区
12.24新手引导的Demo:

GitHub:https://github.com/sunljz/demo/tree/master/GuideDemo

教程:http://www.jianshu.com/p/b83aefdc9519


##SwiftDemos
0217_01_NSOperationDemo:展示如何使用NSBlockOperation，更多内容查看，http://www.appcoda.com/ios-concurrency/

0217_RecordDemo:简单地使用录音以及播放录音

0216_02PickerViewDemo：如何使用UIPickerView

0216_01_animate_TableViewDemo：一个简单的动画

0216VideoDemo：如何播放一个video

0215_02ImageZoomDemo：一个Image放大缩小的Demo

0215_01RefreshControlDemo：展示UIRefreshControl的使用

0215TimerDemo：展示NSTimer的使用

SwiftDemo1：1204，展示怎么用UITabBarController

TableViewDemo:1204,展示怎么用UITableView

TableViewDemo2:1204,自定义UITableViewCell，怎么样实现delegate模式
####社区

20160216

[CoolNaviDemo 的swift版](https://github.com/ianisme/CoolNaviDemo_Swift):演示一个View如何观察UIScrollView的属性


##MacDemos

MacMenuBar:一个简单的显示在菜单栏的Mac Demo

