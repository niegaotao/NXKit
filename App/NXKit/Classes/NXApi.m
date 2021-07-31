//
//  NXApi.m
//  NXKit_Example
//
//  Created by niegaotao on 2021/6/30.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "NXApi.h"


@implementation NXApi
+ (void)swizzleClass:(Class)class original:(SEL)originalSelector swizzle:(SEL)swizzleSelector{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzleSelector);
    BOOL addMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (addMethod) {
        class_replaceMethod(class, swizzleSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


+ (NSArray *)propertyList:(Class)cls forward:(BOOL)forward{
    if(!cls || [cls isEqual:[NSObject class]]){
        return @[];
    }
    NSMutableArray *retValue = [NSMutableArray arrayWithCapacity:2];
    unsigned int count;
    objc_property_t * rss = class_copyPropertyList(cls, &count);
    for (unsigned int i = 0; i < count; i++) {
        objc_property_t rs =  rss[i];
        NSString *name = [NSString stringWithFormat:@"%s", property_getName(rs)];
        [retValue addObject:name];
    }
    free(rss);
    
    Class superclass = [cls superclass];
    if(superclass && forward){
        [retValue addObjectsFromArray:[NXApi propertyList:superclass forward:forward]];
    }
    
    return retValue;
}

+ (NSArray *)varList:(Class)cls forward:(BOOL)forward{
    if(!cls || [cls isEqual:[NSObject class]]){
        return @[];
    }
    NSMutableArray *retValue = [NSMutableArray arrayWithCapacity:2];
    unsigned int count;
    Ivar * rss = class_copyIvarList(cls, &count);
    for (unsigned int i = 0; i < count; i++) {
        Ivar rs = rss[i];
        NSString *name = [NSString stringWithFormat:@"%s", ivar_getName(rs)];
        [retValue addObject:name];
    }
    free(rss);
    
    Class superclass = [cls superclass];
    if(superclass && forward){
        [retValue addObjectsFromArray:[NXApi varList:superclass forward:forward]];
    }
    
    return retValue;
}


+ (NSArray *)methodList:(Class)cls forward:(BOOL)forward{
    if(!cls || [cls isEqual:[NSObject class]]){
        return @[];
    }
    NSMutableArray *retValue = [NSMutableArray arrayWithCapacity:2];
    unsigned int count;
    Method *rss = class_copyMethodList(cls, &count);
    for (unsigned int i = 0; i < count; i++) {
        Method rs = rss[i];
        NSString *name = [NSString stringWithFormat:@"%s", sel_getName(method_getName(rs))];
        [retValue addObject:name];
    }
    free(rss);
    
    Class superclass = [cls superclass];
    if(superclass && forward){
        [retValue addObjectsFromArray:[NXApi methodList:superclass forward:forward]];
    }
    
    return retValue;
}

+ (NSArray *)protocolList:(Class)cls forward:(BOOL)forward{
    if(!cls || [cls isEqual:[NSObject class]]){
        return @[];
    }
    NSMutableArray *retValue = [NSMutableArray arrayWithCapacity:2];
//    unsigned int count;
//    Protocol *rss = class_copyProtocolList(cls, &count);
//    for (unsigned int i = 0; i < count; i++) {
//        Protocol rs = rss[i];
//        NSString *name = NSStringFromSelector(protocol_getName(rs));
//        [retValue addObject:name];
//    }
//    free(rss);
//
//    Class superclass = [cls superclass];
//    if(superclass && forward){
//        [retValue addObjectsFromArray:[NXApi methodList:superclass forward:forward]];
//    }
    
    return retValue;
}

+ (NSInteger)sizeOf:(Class)cls{
    size_t __instanceSize = class_getInstanceSize(cls);//字节对齐后的占用空间大小【至少需要这么多的内存空间】
    size_t __mallocSize = malloc_size((__bridge const void *)([[cls alloc] init]));//字节对齐后按照16的倍数处理，【实际分配的内存大小】
    size_t __sizeofSize = sizeof(cls);//类型的大小
    //NSLog(@"instanceSize=%@; sizeofSize=%@; mallocSize=%@", @(__instanceSize), @(__mallocSize), @(__sizeofSize));
    return __mallocSize;
}

@end
