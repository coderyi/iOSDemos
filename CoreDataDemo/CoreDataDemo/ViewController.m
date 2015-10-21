//
//  ViewController.m
//  CoreDataDemo
//
//  Created by coderyi on 15/10/18.
//  Copyright © 2015年 coderyi. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}
/**
 *  
 Core Data入门  MJ写的不错
 http://blog.csdn.net/q199109106q/article/details/8563438/
 */
- (IBAction)addAction:(id)sender {
    // 从应用程序包中加载模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    // 传入模型对象，初始化NSPersistentStoreCoordinator
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model] ;
    // 构建SQLite数据库文件的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"person.data"]];
    // 添加持久化存储库，这里使用SQLite作为存储库
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) { // 直接抛异常
        [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
    }
    // 初始化上下文，设置persistentStoreCoordinator属性
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = psc;
    // 用完之后，记得要[context release];
    
    
    
    // 传入上下文，创建一个Person实体对象
    NSManagedObject *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    // 设置Person的简单属性
    [person setValue:@"MJ" forKey:@"name"];
    [person setValue:[NSNumber numberWithInt:27] forKey:@"age"];
    // 传入上下文，创建一个Card实体对象
    NSManagedObject *card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
    [card setValue:@"4414241933432" forKey:@"no"];
    // 设置Person和Card之间的关联关系
    [person setValue:card forKey:@"card"];
    // 利用上下文对象，将数据同步到持久化存储库
    NSError *error1 = nil;
    BOOL success = [context save:&error];
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error1 localizedDescription]];
    }
    // 如果是想做更新操作：只要在更改了实体对象的属性后调用[context save:&error]，就能将更改的数据同步到数据库
}


- (IBAction)selectAction:(id)sender {
    
    // 从应用程序包中加载模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    // 传入模型对象，初始化NSPersistentStoreCoordinator
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model] ;
    // 构建SQLite数据库文件的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"person.data"]];
    // 添加持久化存储库，这里使用SQLite作为存储库
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) { // 直接抛异常
        [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
    }
    // 初始化上下文，设置persistentStoreCoordinator属性
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = psc;
    // 用完之后，记得要[context release];
    

    
    
    // 初始化一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init] ;
    // 设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
    // 设置排序（按照age降序）
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    // 设置条件过滤(搜索name中包含字符串"Itcast-1"的记录，注意：设置条件过滤时，数据库SQL语句中的%要用*来代替，所以%Itcast-1%应该写成*Itcast-1*)
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"*M*"];
    request.predicate = predicate;
    // 执行请求
    NSError *error1 = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error1];
    if (error1) {
        [NSException raise:@"查询错误" format:@"%@", [error1 localizedDescription]];
    }
    // 遍历数据
    for (NSManagedObject *obj in objs) {
        NSLog(@"name=%@", [obj valueForKey:@"name"]  );
              
    }
              
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
