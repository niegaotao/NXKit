//
//  NSObject+.h
//  NXKit_Example
//
//  Created by niegaotao on 2021/6/23.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSObject(NX)
- (void)nx_setValue:(id)value forKey:(NSString *)key;
- (id)nx_valueForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
