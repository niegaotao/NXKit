//
//  NXEMWorker.m
//  NXKit_Example
//
//  Created by niegaotao on 2021/6/28.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "NXEMWorker.h"
#import "NXApi.h"


@implementation NXEMWorker
+ (void)load {
    [NXApi swizzleClass:[NXEMWorker class] original:@selector(run) swizzle:@selector(__em)];
}

- (void)__em{
    NSLog(@"NXEMWorker/run/before");
    [self __em];
    NSLog(@"NXEMWorker/run/after");
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
