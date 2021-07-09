//
//  NXMRC.m
//  NXKit_Example
//
//  Created by niegaotao on 2021/6/28.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "NXMRC.h"
#import "NXWorker.h"
#import "NXEMWorker.h"
#import "NXMobileWorker.h"
#import <objc/message.h>

@interface NSObject(A)
+ (void)sleep;
@end

@implementation NSObject(A)
- (void)sleep{
    NSLog(@"-----------------------------");
}

@end

@implementation NXMRC
+ (NXMRC *)center {
    static NXMRC *__center;
    static dispatch_once_t __once;
    dispatch_once(&__once, ^{
        __center = [[NXMRC alloc] init];
    });
    return __center;
}

- (instancetype)init{
    if(self = [super init]){
    }
    return self;
}


- (void)testZombie{
#if __has_feature(objc_arc)
    
#else
    NXMobileWorker *worker = [[NXMobileWorker alloc] init];
    worker.code = @"Worker";
    [worker run];
    
    NSLog(@"");
    
    NXMobileWorker *__worker = ((NXMobileWorker *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("NXMobileWorker"), sel_registerName("alloc"));
    __worker = ((NXMobileWorker *(*)(id, SEL))(void *)objc_msgSend)((id)__worker, sel_registerName("init"));
    ((void (*)(id, SEL))(void *)objc_msgSend)((id)__worker, sel_registerName("run"));
    
    NSLog(@"");

    
    //((void (*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("NXMobileWorker"), sel_registerName("run"));
    //((void (*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("NXMobileWorker"), sel_registerName("classDebug"));

    //((void (*)(id, SEL))(void *)objc_msgSend)((id)__worker, sel_registerName("_runApp"));

    
//    NSLog(@"%@", @(worker.retainCount));
//    [worker release];
//    NSLog(@"%@", @(worker.retainCount));
    
    [NXMobileWorker sleep];
    [[NXMobileWorker new] sleep];
    
    
#endif
}




@end

