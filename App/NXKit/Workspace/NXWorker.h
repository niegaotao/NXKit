//
//  NXWorker.h
//  NXKit_Example
//
//  Created by niegaotao on 2021/6/30.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NXWorker : NSObject {
    NSString *name;
}
@property (nonatomic, copy) NSString *code;
- (void)run;
- (void)debug;
+ (void)classDebug;
@end

NS_ASSUME_NONNULL_END
