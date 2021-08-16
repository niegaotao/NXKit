//
//  NXPerson.m
//  NXKit_Example
//
//  Created by niegaotao on 2021/6/30.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "NXPerson.h"
#import "NXApi.h"



@implementation NXPerson
- (void)run{
    NSLog(@"NXPerson/run/bofore");
    NSLog(@"NXPerson/run/after");
}

- (void)debug{
    NSLog(@"NXPerson/debug/name=%@",self.name);
}

+ (void)classDebug {
    NSLog(@"NXPerson/classDebug/");
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"%s", __func__);
}

- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"%s", __func__);
    return nil;
}
@end

/*====================================================*/
@implementation NXTeacher

- (void)__em{
    NSLog(@"NXTeacher/run/before");
    [self __em];
    NSLog(@"NXTeacher/run/after");
}

- (void)work{
    NSLog(@"NXTeacher/debug");
}

+ (void)classWork{
    NSLog(@"NXTeacher/debug");
}

//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    NSLog(@"%s", __func__);
//}
//
//- (id)valueForUndefinedKey:(NSString *)key {
//    NSLog(@"%s", __func__);
//    return nil;
//}
@end

/*====================================================*/
@implementation NXStudent

- (void)__em{
    NSLog(@"NXStudent/run/before");
    [self __em];
    NSLog(@"NXStudent/run/after");
}

- (void)work{
    NSLog(@"NXStudent/debug");
}

+ (void)classWork{
    NSLog(@"NXStudent/debug");
}
@end


@implementation NXStudent (Category)
+ (void)load {
    [NXApi swizzleClass:[NXStudent class] original:@selector(run) swizzle:@selector(__em__)];
}

- (void)__em__{
    NSLog(@"NXStudent/-/run/before");
    [self __em__];
    NSLog(@"NXStudent/-/run/after");
}
@end

/*====================================================*/
@implementation NXCollegeStudent
@end
/*====================================================*/
