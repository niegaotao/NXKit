//
//  NXPerson.m
//  NXKit_Example
//
//  Created by niegaotao on 2021/6/30.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "NXPerson.h"
#import "NXApi.h"

@implementation NSObject(NXKit)
- (void)test {
    NSLog(@"-NSObject(NXKit)/test");
}

//+ (void)test {
//    NSLog(@"+NSObject(NXKit)/test");
//}
@end


@implementation NXPerson
- (void)run{
    NSLog(@"NXPerson/run/bofore");
    NSLog(@"NXPerson/run/after");
}
+ (void)classRun {
    NSLog(@"NXPerson/classRun/");
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

+ (void)setDesc:(NSString *)desc {
    
}

+ (NSString *)desc {
    return @"";
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
- (void)work{
    NSLog(@"NXStudent/debug");
}

+ (void)classWork{
    NSLog(@"NXStudent/debug");
}
@end

/*====================================================*/
@implementation NXCollegeStudent
@end
/*====================================================*/
