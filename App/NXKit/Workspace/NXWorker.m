//
//  NXWorker.m
//  NXKit_Example
//
//  Created by niegaotao on 2021/6/30.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "NXWorker.h"
#import "NXApi.h"

@implementation NXWorker
- (void)run{
    NSLog(@"NXWorker/run/bofore");
    NSLog(@"NXWorker/run/after");
}

- (void)debug{
    NSLog(@"NXWorker/debug/name=%@",self.name);
}

+ (void)classDebug {
    NSLog(@"NXWorker/classDebug/");
}
@end

/*====================================================*/
@implementation NXEMWorker
+ (void)load {
    [NXApi swizzleClass:[NXEMWorker class] original:@selector(run) swizzle:@selector(__em)];
}

- (void)__em{
    NSLog(@"NXEMWorker/run/before");
    [self __em];
    NSLog(@"NXEMWorker/run/after");
}

- (void)work{
    NSLog(@"NXEMWorker/debug");
}

+ (void)classWork{
    NSLog(@"NXEMWorker/debug");
}
@end


@implementation NXEMWorker (Category)
+ (void)load {
    [NXApi swizzleClass:[NXEMWorker class] original:@selector(run) swizzle:@selector(__em__)];
}

- (void)__em__{
    NSLog(@"NXEMWorker/-/run/before");
    [self __em__];
    NSLog(@"NXEMWorker/-/run/after");
}
@end

/*====================================================*/
@implementation NXMobileWorker
+ (void)load {
    [NXApi swizzleClass:[NXMobileWorker class] original:@selector(run) swizzle:@selector(__mobile)];
}

- (void)__mobile{
    NSLog(@"NXMobileWorker/run/before");
    [self __mobile];
    NSLog(@"NXMobileWorker/run/after");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"resolveInstanceMethod:%@", [NSString stringWithCString:sel_getName(sel) encoding:NSUTF8StringEncoding]);
    
    Method method = class_getInstanceMethod([NXMobileWorker class], NSSelectorFromString(@"test"));
    class_addMethod([NXMobileWorker class], sel, method_getImplementation(method), method_getTypeEncoding(method));
    
    return YES;
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    NSLog(@"resolveClassMethod:%@", [NSString stringWithCString:sel_getName(sel) encoding:NSUTF8StringEncoding]);
    
//    Method original = class_getClassMethod([NXMobileWorker class], sel);
//    Method method = class_getClassMethod([NXMobileWorker class], @selector(test));
//    method_exchangeImplementations(original, method);
    return YES;
}

- (void)test {
    NSLog(@"-NXMobileWorker/test");
}

+ (void)test {
    NSLog(@"+NXMobileWorker/test");
}
@end


@implementation NXMobileWorker(Category)
+ (void)load {
    [NXApi swizzleClass:[NXMobileWorker class] original:@selector(run) swizzle:@selector(__mobile__)];
}

- (void)__mobile__{
    NSLog(@"NXMobileWorker/-/run/before");
    [self __mobile__];
    NSLog(@"NXMobileWorker/-/run/after");
}
@end
/*====================================================*/
