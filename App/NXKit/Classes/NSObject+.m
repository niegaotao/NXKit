//
//  NXKVC.m
//  NXKit_Example
//
//  Created by niegaotao on 2021/6/23.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "NSObject+.h"
#import "NXApi.h"


@implementation NSObject(NX)
- (void)nx_setValue:(id)value forKey:(NSString *)key{

    if (key == nil || key.length == 0) {
        return ;
    }

    NSString *Key = key.capitalizedString;

    
    //1、 set<Key>: / _set<Key>: /setIs<Key>:
    NSMutableArray *__selStringArray = [NSMutableArray arrayWithCapacity:3];
    [__selStringArray addObject:[NSString stringWithFormat:@"set%@:", Key]];
    [__selStringArray addObject:[NSString stringWithFormat:@"_set%@:", Key]];
    [__selStringArray addObject:[NSString stringWithFormat:@"setIs%@:", Key]];
    for(NSString *selString in __selStringArray){
        SEL sel = NSSelectorFromString(selString);
        if(sel && [self respondsToSelector:sel]){
            [self performSelector:sel withObject:value];
            NSLog(@"set/sel:%@", selString);
            return;
        }
    }
    

    //2、 self.class.accessInstanceVariablesDirectly == YES => _<key>，_is<Key>，<key>, is<Key>
    if (self.class.accessInstanceVariablesDirectly) {
        //获取实例变量列表
        NSArray *varStringArray = [NXApi varList:self.class forward:YES];
        
        NSMutableArray *__varStringArray = [NSMutableArray arrayWithCapacity:4];
        [__varStringArray addObject:[NSString stringWithFormat:@"_%@", key]];
        [__varStringArray addObject:[NSString stringWithFormat:@"_is%@", Key]];
        [__varStringArray addObject:key];
        [__varStringArray addObject:[NSString stringWithFormat:@"is%@", Key]];
        
        for (NSString *varString in __varStringArray){
            if([varStringArray containsObject:varString]){
                Ivar ivar = class_getInstanceVariable(self.class, varString.UTF8String);
                object_setIvar(self, ivar, value);
                NSLog(@"set/var:%@", varString);
                return;
            }
        }
    }

    //3、 setValue:forUndefinedKey:
    if([[NXApi methodList:self.class forward:YES] containsObject:@"setValue:forUndefinedKey:"]){
        [self setValue:value forUndefinedKey:key];
    }
    
    //4、Exception
}

- (id)nx_valueForKey:(NSString *)key{
    if (key == nil || key.length == 0) {
        return [NSNull null];
    }
    
    NSString *Key = key.capitalizedString;
    
    //1、 搜索实例的方法 get<Key>, key, isKey, _key
    NSMutableArray *__selStringArray = [NSMutableArray arrayWithCapacity:4];
    [__selStringArray addObject:[NSString stringWithFormat:@"get%@", Key]];
    [__selStringArray addObject:key];
    [__selStringArray addObject:[NSString stringWithFormat:@"is%@", Key]];
    [__selStringArray addObject:[NSString stringWithFormat:@"_%@", key]];
    for(NSString *selString in __selStringArray){
        SEL sel = NSSelectorFromString(selString);
        if(sel && [self respondsToSelector:sel]){
            NSLog(@"get/sel:%@", selString);
            return [self performSelector:sel];
        }
    }


    // 2、 self.class.accessInstanceVariablesDirectly == YES => _<key>，_is<Key>，<key>, is<Key>
    if (self.class.accessInstanceVariablesDirectly) {
        //获取实例变量列表
        NSArray *varStringArray = [NXApi varList:self.class forward:YES];
        
        NSMutableArray *__varStringArray = [NSMutableArray arrayWithCapacity:4];
        [__varStringArray addObject:[NSString stringWithFormat:@"_%@", key]];
        [__varStringArray addObject:[NSString stringWithFormat:@"_is%@", Key]];
        [__varStringArray addObject:key];
        [__varStringArray addObject:[NSString stringWithFormat:@"is%@", Key]];
        
        for (NSString *varString in __varStringArray){
            if([varStringArray containsObject:varString]){
                Ivar ivar = class_getInstanceVariable(self.class, varString.UTF8String);
                NSLog(@"get/var:%@", varString);
                return object_getIvar(self, ivar);
            }
        }
    }
    
    // 3、 valueForUndefinedKey:
    // 经过测试只要在子类中实现了valueForUndefinedKey:方法就可以正常调用不会报错
    if([[NXApi methodList:self.class forward:YES] containsObject:@"valueForUndefinedKey:"]){
        return [self valueForUndefinedKey:key];
    }
    
    // 4. Exception
    
    return nil;
}
@end
