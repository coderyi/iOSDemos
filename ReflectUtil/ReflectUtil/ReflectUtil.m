//
//  ReflectUtil.m
//  ReflectUtil
//
//  Created by coderyi on 15/10/23.
//  Copyright © 2015年 coderyi. All rights reserved.
//

#import "ReflectUtil.h"
#include <objc/runtime.h>
@implementation ReflectUtil

-(NSString *)toStringWithObject:(id)obj{
    NSArray *properties = [self propertiesWithClass:[obj class]];
    NSMutableString *str = [NSMutableString stringWithFormat:@"【Calss:%@#",[obj class]];
    if (properties.count > 0) {
        for (NSString *pName in properties) {
            id val = [obj valueForKey:pName];
            [str appendFormat:@"%@:%@,",pName,val];
        }
        if ([str hasSuffix:@","]) {
            [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
        }
        [str appendString:@"】"];
    }
    return str;
}

-(NSArray *)propertiesWithClass:(Class)cls{
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
    if (propertyCount == 0) {
        return nil;
    }
    NSMutableArray* propertyArr = [[NSMutableArray alloc ]initWithCapacity:propertyCount];
    
    for (unsigned int i = 0; i < propertyCount; i++) {
        
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        NSString *pName = [NSString stringWithUTF8String:propertyName];
        if (pName) {
            [propertyArr addObject:pName];
        }
        
    }
    return propertyArr;
}


@end
