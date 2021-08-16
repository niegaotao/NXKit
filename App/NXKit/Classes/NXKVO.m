//
//  NXKVO.m
//  NXKit_Example
//
//  Created by niegaotao on 2021/6/23.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "NXKVO.h"
#import "NXApi.h"

#define __NXKVO

#ifdef __NXKVO
@interface NXBookclass : NSObject {
    @public NSInteger _priceValue;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *descriptions;
@end

@implementation NXBookclass

//+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
//    return NO;
//}
//- (void)setName:(NSString *)name {
//    [self willChangeValueForKey:@"name"];
//    _name = name;
//    [self didChangeValueForKey:@"name"];
//    NSLog(@"%s", __func__);
//}
- (void)dealloc {
    NSLog(@"%s", __func__);
}
@end
#endif



@implementation NXKVO
- (void)KVO{
#ifdef __NXKVO
    NXBookclass *bookclass = [[NXBookclass alloc] init];
    NSLog(@"观察之前:%@",[NXApi descriptionClass:object_getClass(bookclass)]);
    NSInteger flag = 4;
    if(flag == 1){
        [bookclass addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];

        NSLog(@"观察之中:%@", [NXApi descriptionClass:object_getClass(bookclass)]);
        bookclass.name = @"Swift";
        //NSLog(@">>>:%@", [bookclass valueForKey:@"_isKVOA"]);
        [bookclass removeObserver:self forKeyPath:@"name"];
        //NSLog(@"<<:%@", [bookclass valueForKey:@"_isKVOA"]);
    }
    
    if(flag == 2){
        [bookclass addObserver:self forKeyPath:@"_name" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];

        NSLog(@"观察之中:%@", [NXApi descriptionClass:object_getClass(bookclass)]);

        [bookclass setValue:@"Swift" forKey:@"_name"];
        [bookclass removeObserver:self forKeyPath:@"_name"];
    }
    
    if(flag == 3){
        [bookclass addObserver:self forKeyPath:@"_priceValue" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];

        NSLog(@"观察之中:%@", [NXApi descriptionClass:object_getClass(bookclass)]);

        [bookclass setValue:@(25) forKey:@"_priceValue"];//OK
        //bookclass->_priceValue = 26;//NO
        
        [bookclass removeObserver:self forKeyPath:@"_priceValue"];
    }

    
    if(flag == 4){
        [bookclass addObserver:self forKeyPath:@"descriptions" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];

        NSLog(@"观察之中:%@", [NXApi descriptionClass:object_getClass(bookclass)]);

        bookclass.descriptions = [NSMutableArray arrayWithCapacity:2];
        [[bookclass mutableArrayValueForKey:@"descriptions"] addObject:@"A"];
        [[bookclass mutableArrayValueForKey:@"descriptions"] setObject:@"B" atIndexedSubscript:0];
        [[bookclass mutableArrayValueForKey:@"descriptions"] removeObjectAtIndex:0];

        [bookclass removeObserver:self forKeyPath:@"descriptions"];
    }
    
    NSLog(@"取消观察之后:%@", [NXApi descriptionClass:object_getClass(bookclass)]);
    //NSLog(@"取消观察之后:%@", [NXApi descriptionClass:NSClassFromString(@"NSKVONotifying_NXBookclass")]);

    NSCache *a = nil;
#endif
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"%s, key=%@, change=%@", __func__, keyPath, change);
}
@end
