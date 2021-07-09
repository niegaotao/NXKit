//
//  NXWorker.m
//  NXKit_Example
//
//  Created by niegaotao on 2021/6/30.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "NXWorker.h"

@implementation NXWorker

 
// + (id)alloc {
//    retun _objc_rootAlloc(self);
// }
//
// id _objc_rootAlloc(Class cls){
//    return callAlloc(cls, false/*checkNil*/, true/*allocWithZone*/);
// }
//
// static id callAlloc(Class cls, bool checkNil, bool allocWithZone=false) {
//     #if __OBJC2__  //objc有两个版本 ，OBJC2为编译优化版本
//      if (slowpath(checkNil && !cls)) return nil;
//          //判断这个类是否有自定义的 +allocWithZone 实现，没有则走到if里面的实现
//          if (fastpath(!cls->ISA()->hasCustomAWZ())) {
//              return _objc_rootAllocWithZone(cls, nil);
//          }
//      #endif
//
//      // No shortcuts available.
//      if (allocWithZone) {
//           return ((id(*)(id, SEL, struct _NSZone *))objc_msgSend)(cls, @selector(allocWithZone:), nil);
//      }
//      return ((id(*)(id, SEL))objc_msgSend)(cls, @selector(alloc));
// }
//
// id _objc_rootAllocWithZone(Class cls, malloc_zone_t *zone __unused)
//{
//    // allocWithZone under __OBJC2__ ignores the zone parameter
//    return _class_createInstanceFromZone(cls, 0, nil,
//                                         OBJECT_CONSTRUCT_CALL_BADALLOC);
//}

//static ALWAYS_INLINE id
//_class_createInstanceFromZone(Class cls, size_t extraBytes, void *zone,
//                              int construct_flags = OBJECT_CONSTRUCT_NONE,
//                              bool cxxConstruct = true,
//                              size_t *outAllocatedSize = nil)
//{
//    ASSERT(cls->isRealized());
//
//    // Read class's info bits all at once for performance
//    bool hasCxxCtor = cxxConstruct && cls->hasCxxCtor();
//    bool hasCxxDtor = cls->hasCxxDtor();
//    bool fast = cls->canAllocNonpointer();
//    size_t size;
//    // 1:要开辟多少内存
//    size = cls->instanceSize(extraBytes);
//    if (outAllocatedSize) *outAllocatedSize = size;
//
//    id obj;
//    if (zone) {
//        obj = (id)malloc_zone_calloc((malloc_zone_t *)zone, 1, size);
//    } else {
//        // 2;怎么去申请内存
//        obj = (id)calloc(1, size);
//    }
//    if (slowpath(!obj)) {
//        if (construct_flags & OBJECT_CONSTRUCT_CALL_BADALLOC) {
//            return _objc_callBadAllocHandler(cls);
//        }
//        return nil;
//    }
//
//    // 3: 将 cls类 与 obj指针（即isa） 关联
//    if (!zone && fast) {
//        obj->initInstanceIsa(cls, hasCxxDtor);
//    } else {
//        // Use raw pointer isa on the assumption that they might be
//        // doing something weird with the zone or RR.
//        obj->initIsa(cls);
//    }
//
//    if (fastpath(!hasCxxCtor)) {
//        return obj;
//    }
//
//    construct_flags |= OBJECT_CONSTRUCT_FREE_ONFAILURE;
//    return object_cxxConstructFromClass(obj, cls, construct_flags);
//}

 
 
 







+ (instancetype)alloc {
    return [super alloc];
}

- (instancetype)init{
    return [super init];
}

- (void)run{
    NSLog(@"NXWorker/run/bofore");
    NSLog(@"NXWorker/run/after");
}

- (void)debug{
    NSLog(@"NXWorker/debug/code=%@",self.code);
}

+ (void)classDebug {
    NSLog(@"NXWorker/classDebug/");
}
@end
