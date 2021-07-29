//
//  NXWorker.h
//  NXKit_Example
//
//  Created by niegaotao on 2021/6/30.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*====================================================*/
@interface NXWorker : NSObject {
    NSString *_uuid;
}
@property (nonatomic, copy) NSString *name;
- (void)run;
- (void)debug;
+ (void)classDebug;
@end

/*====================================================*/
@interface NXEMWorker : NXWorker {
    NSString *_union;
}
@property (nonatomic, copy) NSString *title;
- (void)work;
+ (void)classWork;
@end

@interface NXEMWorker (Category)
@end

/*====================================================*/
@interface NXMobileWorker : NXEMWorker
@end

@interface NXMobileWorker(Category)
@end
/*====================================================*/
NS_ASSUME_NONNULL_END
