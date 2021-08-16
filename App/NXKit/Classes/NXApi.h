//
//  NXApi.h
//  NXKit_Example
//
//  Created by niegaotao on 2021/6/30.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <objc/runtime.h>
#import <objc/message.h>
#import <objc/objc.h>
#import <objc/NSObject.h>
#import <objc/NSObjCRuntime.h>
#import <objc/objc-auto.h>
#import <objc/objc-api.h>
#import <objc/objc-sync.h>
#import <objc/objc-exception.h>

NS_ASSUME_NONNULL_BEGIN

@interface NXApi : NSObject
+ (void)swizzleClass:(Class)cls original:(SEL)originalSelector swizzle:(SEL)swizzleSelector;
+ (NSArray *)propertyList:(Class)cls forward:(BOOL)forward;
/*获取成员变量列表:cls当前类，forward是否向上查询父类*/
+ (NSArray *)varList:(Class)cls forward:(BOOL)forward;
/*获取方法变量列表:cls当前类，forward是否向上查询父类*/
+ (NSArray *)methodList:(Class)cls forward:(BOOL)forward;
+ (NSArray *)metaClass:(Class)cls forward:(BOOL)forward;
+ (NSArray *)protocolList:(Class)cls forward:(BOOL)forward;
+ (NSInteger)sizeOf:(Class)cls;
+ (NSMutableDictionary *)descriptionClass:(Class)cls;
@end

NS_ASSUME_NONNULL_END
