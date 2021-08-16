//
//  NXMRC.m
//  NXKit_Example
//
//  Created by niegaotao on 2021/6/28.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "NXMRC.h"
#import "NXPerson.h"
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
    NXCollegeStudent *worker = [[NXCollegeStudent alloc] init];
    worker.name = @"Worker";
    [worker run];
    
    NSLog(@"");
    
    NXCollegeStudent *__worker = ((NXCollegeStudent *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("NXCollegeStudent"), sel_registerName("alloc"));
    __worker = ((NXCollegeStudent *(*)(id, SEL))(void *)objc_msgSend)((id)__worker, sel_registerName("init"));
    ((void (*)(id, SEL))(void *)objc_msgSend)((id)__worker, sel_registerName("run"));
    
    NSLog(@"");

    
    //((void (*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("NXCollegeStudent"), sel_registerName("run"));
    //((void (*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("NXCollegeStudent"), sel_registerName("classDebug"));

    //((void (*)(id, SEL))(void *)objc_msgSend)((id)__worker, sel_registerName("_runApp"));

    
//    NSLog(@"%@", @(worker.retainCount));
//    [worker release];
//    NSLog(@"%@", @(worker.retainCount));
    
    [NXCollegeStudent sleep];
    [[NXCollegeStudent new] sleep];
#endif
}




@end

