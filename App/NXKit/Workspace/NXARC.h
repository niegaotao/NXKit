//
//  NXARC.h
//  NXKit_Example
//
//  Created by niegaotao on 2021/6/23.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NXARC : NSObject
+ (NXARC *)center;
+ (void)test;
- (void)testLock;
- (void)testStringCopy;
- (void)testDictionaryCopy;
- (void)testArrayCopy;
- (void)signal;

- (void)testClass;
- (void)dispatchQueue;
- (void)testBuffer;
@end

NS_ASSUME_NONNULL_END
