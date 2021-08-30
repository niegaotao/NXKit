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

+ (void)test {
    NSLog(@"+NSObject(NXKit)/test");
}
@end


@implementation NXPerson
- (void)sleep{
    NSLog(@"NXPerson/sleep");
}

+ (void)classSleep {
    NSLog(@"NXPerson/classSleep");
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
- (void)sleep {
    [super sleep];
    NSLog(@"NXTeacher/sleep");
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
