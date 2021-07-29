//
//  NXARC.m
//  NXKit_Example
//
//  Created by niegaotao on 2021/6/23.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "NXARC.h"
#import <libkern/OSAtomic.h>
#include <execinfo.h>
#import "NXWorker.h"
#import "NXApi.h"


@interface NXARC()
@property (nonatomic, assign) OSSpinLock lock;
@end

@implementation NXARC
+ (NXARC *)center {
    static NXARC *__center;
    static dispatch_once_t __once;
    dispatch_once(&__once, ^{
        __center = [[NXARC alloc] init];
    });
    return __center;
}

- (instancetype)init{
    if(self = [super init]){
        self.lock = OS_SPINLOCK_INIT;
    }
    return self;
}


+ (void)test {
//    NSLog(@"\n\n_________________%s", __func__);
//
//    NSObject *entry = [[NSObject alloc] init];
//    NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; hash=%@", entry, entry, &entry, @(entry.hash));
//    
//    NSObject *strongEntry = entry;
//    NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; hash=%@", strongEntry, strongEntry, &strongEntry, @(strongEntry.hash));
//    
//    __weak NSObject *weakEntry1 = entry;
//    NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; hash=%@", weakEntry1, weakEntry1, &weakEntry1, @(weakEntry1.hash));
//
//    __weak NSObject *weakEntry2 = entry;
//    NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; hash=%@", weakEntry2, weakEntry2, &weakEntry2, @(weakEntry2.hash));
}

- (void)testLock{
    NSLog(@"\n\n_________________%s", __func__);

//    dispatch_queue_t queue = dispatch_get_global_queue(NULL, 0);
//    dispatch_queue_t main = dispatch_get_main_queue();
//    dispatch_async(queue, ^{
//        NSLog(@"1-开始");
//        OSSpinLockLock(&_lock);
//        NSLog(@"1-进行");
//        OSSpinLockUnlock(&_lock);
//        NSLog(@"1-解锁");
//    });
//
//    dispatch_async(queue, ^{
//        NSLog(@"2-开始");
//        OSSpinLockLock(&_lock);
//        NSLog(@"2-进行");
//        OSSpinLockUnlock(&_lock);
//        NSLog(@"2-解锁");
//    });
    
}

- (void)testStringCopy{
    NSLog(@"_________________%s", __func__);
    if(YES) {
        NSLog(@"NSString:");
        NSString *source = @"ABC";
        NSString *assign_source = source;
        NSString *copy_source = [source copy];
        NSString *mutableCopy_source = [source mutableCopy];
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", source, source, &source, [source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", assign_source, assign_source, &assign_source, [assign_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", copy_source, copy_source, &copy_source, [copy_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", mutableCopy_source, mutableCopy_source, &mutableCopy_source, [mutableCopy_source class]);
        source = @"DEF";
        NSLog(@">>>");
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", source, source, &source, [source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", assign_source, assign_source, &assign_source, [assign_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", copy_source, copy_source, &copy_source, [copy_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", mutableCopy_source, mutableCopy_source, &mutableCopy_source, [mutableCopy_source class]);
    }
    
    if(YES) {
        NSLog(@"NSMutableString:");
        NSMutableString *source = [NSMutableString stringWithString:@"ABC"];
        NSMutableString *assign_source = source;
        NSMutableString *copy_source = [source copy];
        NSMutableString *mutableCopy_source = [source mutableCopy];
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", source, source, &source, [source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", assign_source, assign_source, &assign_source, [assign_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", copy_source, copy_source, &copy_source, [copy_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", mutableCopy_source, mutableCopy_source, &mutableCopy_source, [mutableCopy_source class]);
        source = [NSMutableString stringWithString:@"DEF"];
        NSLog(@">>>");
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", source, source, &source, [source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", assign_source, assign_source, &assign_source, [assign_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", copy_source, copy_source, &copy_source, [copy_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", mutableCopy_source, mutableCopy_source, &mutableCopy_source, [mutableCopy_source class]);
    }
    
}

- (void)testDictionaryCopy{
    NSLog(@"_________________%s", __func__);
    if(YES) {
        NSLog(@"NSDictionary:");
        NSDictionary *source = @{@"name":@"lee"};
        NSDictionary *assign_source = source;
        NSDictionary *copy_source = [source copy];
        NSDictionary *mutableCopy_source = [source mutableCopy];
        
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", source, source, &source, [source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", assign_source, assign_source, &assign_source, [assign_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", copy_source, copy_source, &copy_source, [copy_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", mutableCopy_source, mutableCopy_source, &mutableCopy_source, [mutableCopy_source class]);
        source = @{@"name":@"key"};
        NSLog(@">>>");
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", source, source, &source, [source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", assign_source, assign_source, &assign_source, [assign_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", copy_source, copy_source, &copy_source, [copy_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", mutableCopy_source, mutableCopy_source, &mutableCopy_source, [mutableCopy_source class]);
    }
    
    if(YES) {
        NSLog(@"NSMutableDictionary:");
        NSMutableDictionary *source = [NSMutableDictionary dictionaryWithDictionary:@{@"name":@"lee"}];
        NSMutableDictionary *assign_source = source;
        NSMutableDictionary *copy_source = [source copy];
        NSMutableDictionary *mutableCopy_source = [source mutableCopy];
        
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", source, source, &source, [source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", assign_source, assign_source, &assign_source, [assign_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", copy_source, copy_source, &copy_source, [copy_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", mutableCopy_source, mutableCopy_source, &mutableCopy_source, [mutableCopy_source class]);
        source = [NSMutableDictionary dictionaryWithDictionary:@{@"name":@"key"}];
        NSLog(@">>>");
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", source, source, &source, [source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", assign_source, assign_source, &assign_source, [assign_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", copy_source, copy_source, &copy_source, [copy_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", mutableCopy_source, mutableCopy_source, &mutableCopy_source, [mutableCopy_source class]);
    }
}


- (void)testArrayCopy{
    NSLog(@"_________________%s", __func__);
    if(YES) {
        NSLog(@"NSArray:");
        NSArray *source = @[@"name"];
        NSArray *assign_source = source;
        NSArray *copy_source = [source copy];
        NSArray *mutableCopy_source = [source mutableCopy];
        
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", source, source, &source, [source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", assign_source, assign_source, &assign_source, [assign_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", copy_source, copy_source, &copy_source, [copy_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", mutableCopy_source, mutableCopy_source, &mutableCopy_source, [mutableCopy_source class]);
        source = @[@"age"];
        NSLog(@">>>");
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", source, source, &source, [source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", assign_source, assign_source, &assign_source, [assign_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", copy_source, copy_source, &copy_source, [copy_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", mutableCopy_source, mutableCopy_source, &mutableCopy_source, [mutableCopy_source class]);
    }
    
    if(YES) {
        NSLog(@"NSMutableArray:");
        NSMutableArray *source = [NSMutableArray arrayWithArray:@[@"name"]];
        NSMutableArray *assign_source = source;
        NSMutableArray *copy_source = [source copy];
        NSMutableArray *mutableCopy_source = [source mutableCopy];
        
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", source, source, &source, [source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", assign_source, assign_source, &assign_source, [assign_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", copy_source, copy_source, &copy_source, [copy_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", mutableCopy_source, mutableCopy_source, &mutableCopy_source, [mutableCopy_source class]);
        source = [NSMutableArray arrayWithArray:@[@"age"]];
        NSLog(@">>>");
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", source, source, &source, [source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", assign_source, assign_source, &assign_source, [assign_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", copy_source, copy_source, &copy_source, [copy_source class]);
        NSLog(@"%@; 所指对象的地址=%p; 指针的地址=%p; 数据类型=%@", mutableCopy_source, mutableCopy_source, &mutableCopy_source, [mutableCopy_source class]);
    }
}

- (void)signal{
    registerSignalHandler();
}

void registerSignalHandler(void) {
    signal(SIGSEGV, handleSignalException);
    signal(SIGFPE, handleSignalException);
    signal(SIGBUS, handleSignalException);
    signal(SIGPIPE, handleSignalException);
    signal(SIGINT, handleSignalException);
    signal(SIGABRT, handleSignalException);
    signal(SIGILL, handleSignalException);
}

void handleSignalException(int signal){
    NSMutableString *string = [[NSMutableString alloc] init];
    void *callstack[128];
    int i, frames = backtrace(callstack, 128);
    char **traceChar = backtrace_symbols(callstack, frames);
    
    NSLog(@"__%s", traceChar);
//    for (int i=0; i < traceChar.length; i++) {
//
//    }
}


- (void)testClass{
    NXEMWorker *worker = [[NXEMWorker alloc] init];
    worker.name = @"__Null";
    worker.title = @"开发工程师";
    Class class = worker.class;
    NSMutableDictionary *dicValue = [NSMutableDictionary dictionaryWithCapacity:5];
    while (class && class != [NSObject class]) {
        NSMutableDictionary *dicSubvalue = [NSMutableDictionary dictionaryWithCapacity:5];
        dicSubvalue[@"propertyList"] = [NXApi propertyList:class forward:false];
        dicSubvalue[@"varList"] = [NXApi varList:class forward:false];
        dicSubvalue[@"methodList"] = [NXApi methodList:class forward:false];
        dicSubvalue[@"protocolList"] = [NXApi protocolList:class forward:false];
        dicSubvalue[@"size"] = @([NXApi sizeOf:class]);
        [dicValue setObject:dicSubvalue forKey:[NSString stringWithCString:class_getName(class) encoding:NSUTF8StringEncoding]];
        class = class_getSuperclass(class);
    }
    NSLog(@"%@", dicValue);
}

- (void)testBuffer{
    NSInteger header = 0;
    NSInteger headerLength = sizeof(header);

    NSMutableData *buffer = [[NSMutableData alloc] init];
    [self append:buffer message:@"?" headerLength:headerLength];
    [self append:buffer message:@"你几点到家" headerLength:headerLength];
    [self append:buffer message:@"你几点到家?" headerLength:headerLength];
    [self append:buffer message:@"幼儿园几点放学?" headerLength:headerLength];
    [self append:buffer message:@"我们社会主义大中国啊啊啊，我们都是好样的啊啊啊啊楠楠" headerLength:headerLength];
    [self append:buffer message:@"1" headerLength:headerLength];
    [self append:buffer message:@"88888888888888" headerLength:headerLength];

    while (buffer.length > headerLength) {
        NSInteger contentLength = 0;
        [buffer getBytes:&contentLength range:NSMakeRange(0, headerLength)];
        
        NSData *data = [buffer subdataWithRange:NSMakeRange(headerLength, contentLength)];
        NSLog(@"%@;%@", @(contentLength),[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        [buffer setData:[buffer subdataWithRange:NSMakeRange(headerLength+contentLength, buffer.length-headerLength-contentLength)]];
    }
}

- (void)append:(NSMutableData *)buffer message:(NSString *)message headerLength:(NSInteger)headerLength{
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSInteger dataLength = data.length;
    [buffer appendData:[NSData dataWithBytes:&dataLength length:headerLength]];
    [buffer appendData:data];
}

- (void)dispatchQueue {
    //主队列
    dispatch_queue_t main = dispatch_get_main_queue();
    //串行
    dispatch_queue_t serial = dispatch_queue_create("com.xxx.app", DISPATCH_QUEUE_SERIAL);
    //并发
    dispatch_queue_t concurrent = dispatch_queue_create("com.xxx.app", DISPATCH_QUEUE_CONCURRENT);
    
    
//    [self test_11_sync_main:main];
//    [self test_12_async_main:main];
//    [self test_21_sync_serial:serial];
//    [self test_22_async_serial:serial];
    [self test_31_sync_concurrent:concurrent];
//    [self test_32_async_concurrent:concurrent];
}


- (void)test_11_sync_main:(dispatch_queue_t)main{
    /*
     同步执行不具备开启新线程的能力，在主队列条件下会阻塞
     */
    NSLog(@"开始, %@", [NSThread currentThread]);
    
    dispatch_sync(main, ^{
        NSLog(@"1, %@", [NSThread currentThread]);
    });
    
    dispatch_sync(main, ^{
        NSLog(@"2, %@", [NSThread currentThread]);
    });
    
    dispatch_sync(main, ^{
        NSLog(@"3, %@", [NSThread currentThread]);
    });
    
    dispatch_sync(main, ^{
        NSLog(@"4, %@", [NSThread currentThread]);
    });
    
    NSLog(@"结束, %@", [NSThread currentThread]);
}

- (void)test_12_async_main:(dispatch_queue_t)main{
    /*
     异步执行具备开启新线程的能力，在主队列条件下不会开启新线程，主队列中的任务在主线程按顺序执行
     */
    
    NSLog(@"开始, %@", [NSThread currentThread]);
    
    dispatch_async(main, ^{
        NSLog(@"1, %@", [NSThread currentThread]);
    });
    
    dispatch_async(main, ^{
        NSLog(@"2, %@", [NSThread currentThread]);
    });
    
    dispatch_async(main, ^{
        NSLog(@"3, %@", [NSThread currentThread]);
    });
    
    dispatch_async(main, ^{
        NSLog(@"4, %@", [NSThread currentThread]);
    });
    
    NSLog(@"结束, %@", [NSThread currentThread]);
}

- (void)test_21_sync_serial:(dispatch_queue_t)serial{
    /*
     同步执行不具备开启新线程的能力，串行队列中的任务在原有的线程按顺序执行
     */
    
    NSLog(@"开始, %@", [NSThread currentThread]);
    
    dispatch_sync(serial, ^{
        NSLog(@"1, %@", [NSThread currentThread]);
    });
    
    dispatch_sync(serial, ^{
        NSLog(@"2, %@", [NSThread currentThread]);
    });
    
    dispatch_sync(serial, ^{
        NSLog(@"3, %@", [NSThread currentThread]);
    });
    
    dispatch_sync(serial, ^{
        NSLog(@"4, %@", [NSThread currentThread]);
    });
    
    NSLog(@"结束, %@", [NSThread currentThread]);
}

- (void)test_22_async_serial:(dispatch_queue_t)serial{
    /*
     异步执行具备开启新线程的能力，在串行队列条件下只会开启一条新线程，串行队列中的任务在新的线程按顺序执行
     */
    
    NSLog(@"开始, %@", [NSThread currentThread]);
    
    dispatch_async(serial, ^{
        NSLog(@"1, %@", [NSThread currentThread]);
    });
    
    dispatch_async(serial, ^{
        NSLog(@"2, %@", [NSThread currentThread]);
    });
    
    dispatch_async(serial, ^{
        NSLog(@"3, %@", [NSThread currentThread]);
    });
    
    dispatch_async(serial, ^{
        NSLog(@"4, %@", [NSThread currentThread]);
    });
    
    NSLog(@"结束, %@", [NSThread currentThread]);
}



- (void)test_31_sync_concurrent:(dispatch_queue_t)concurrent{
    /*
     同步执行不具备开启新线程的能力，在并发条件不会开启新线程，并发队列中的任务在主线程按顺序执行
     */
    
    NSLog(@"开始, %@", [NSThread currentThread]);
    
    dispatch_sync(concurrent, ^{
        NSLog(@"1, %@", [NSThread currentThread]);
    });
    
    dispatch_sync(concurrent, ^{
        NSLog(@"2, %@", [NSThread currentThread]);
    });
    
    dispatch_sync(concurrent, ^{
        NSLog(@"3, %@", [NSThread currentThread]);
    });
    
    dispatch_sync(concurrent, ^{
        NSLog(@"4, %@", [NSThread currentThread]);
    });
    
    NSLog(@"结束, %@", [NSThread currentThread]);
}

- (void)test_32_async_concurrent:(dispatch_queue_t)concurrent{
    /*
     异步执行具备开启新线程的能力，在并发队列条件下会开启多条新线程，队列中的任务在新的线程按顺序执行
     */
    
    NSLog(@"开始, %@", [NSThread currentThread]);
    
    dispatch_async(concurrent, ^{
        NSLog(@"1, %@", [NSThread currentThread]);
    });
    
    dispatch_async(concurrent, ^{
        NSLog(@"2, %@", [NSThread currentThread]);
    });
    
    dispatch_async(concurrent, ^{
        NSLog(@"3, %@", [NSThread currentThread]);
    });
    
    dispatch_async(concurrent, ^{
        NSLog(@"4, %@", [NSThread currentThread]);
    });
    
    NSLog(@"结束, %@", [NSThread currentThread]);
}


@end
