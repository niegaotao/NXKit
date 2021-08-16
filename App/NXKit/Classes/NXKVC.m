//
//  NXKVC.m
//  NXKit_Example
//
//  Created by niegaotao on 2021/6/23.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import "NXKVC.h"
#import "NXApi.h"

#ifdef __NXKVC
typedef struct {
    NSString *name;
    NSInteger priceValue;
}NXBookstruct;



@interface NXBookclass : NSObject
//{
//    NSString *isKey;
//}
//@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger priceValue;

@property (nonatomic) NXBookstruct bookstruct;
@end

@implementation NXBookclass
//- (void)setKey:(id)value {
//    NSLog(@"%s", __func__);
//}
//- (void)_setKey:(id)value {
//    NSLog(@"%s", __func__);
//}
//- (void)setIsKey:(id)value {
//    NSLog(@"%s", __func__);
//}
//_key;
//_isKey;
//key;
//isKey;

//- (NSString *)getKey {
//    return [NSString stringWithFormat:@"%s", __func__];
//}
//- (NSString *)key {
//    return [NSString stringWithFormat:@"%s", __func__];
//}
//- (NSString *)isKey {
//    return [NSString stringWithFormat:@"%s", __func__];
//}
//- (NSString *)_key {
//    return [NSString stringWithFormat:@"%s", __func__];
//}
//_key;
//_isKey;
//key;
//isKey;
@end
#endif



@implementation NXKVC
- (void)KVC{
#ifdef __NXKVC
    
    NXBookclass *bookclass = [[NXBookclass alloc] init];

    {
        NXBookstruct bookstruct = {@"Chinese", 28};
        NSValue *value = [NSValue valueWithBytes:&bookstruct objCType:@encode(NXBookstruct)];
        [bookclass setValue:value forKey:@"bookstruct"];
        NSLog(@"通过类属性直接访问bookstruct:name=%@, priceValue=%@", bookclass.bookstruct.name, @(bookclass.bookstruct.priceValue));
        //通过类属性直接访问bookstruct:name=Chinese, priceValue=28
    }

    {
        NXBookstruct bookstruct;
        NSValue *value = [bookclass valueForKey:@"bookstruct"];
        if (@available(iOS 11.0, *)) {
            [value getValue:&bookstruct size:sizeof(NXBookstruct)];
        } else {
            [value getValue:&bookstruct];
        }
        NSLog(@"通过KVC间接访问bookstruct:name=%@, priceValue=%@", bookstruct.name, @(bookstruct.priceValue));
        //通过KVC间接访问bookstruct:name=Chinese, priceValue=28
    }


    NSMutableArray <NXBookclass *>*bookclasses = [NSMutableArray arrayWithCapacity:5];
    for (NSInteger i = 1; i <= 9; i++){
        NXBookclass *bookclass = [[NXBookclass alloc] init];
        bookclass.name = @(i).stringValue;
        bookclass.priceValue = 10 * i;
        if(bookclass.priceValue > 80){
            bookclass.priceValue = 80;
        }
        if(bookclass.priceValue < 20){
            bookclass.priceValue = 20;
        }
        
        [bookclasses addObject:bookclass];
    }
    /*bookclasses:20,20,30,40,50,60,70,80,80*/

    NSLog(@"@count=%@", [bookclasses valueForKeyPath:@"@count"]);
    //@count=9

    NSLog(@"@avg.priceValue=%@", [bookclasses valueForKeyPath:@"@avg.priceValue"]);
    //@avg.priceValue=50

    NSLog(@"@max.priceValue=%@", [bookclasses valueForKeyPath:@"@max.priceValue"]);
    //@max.priceValue=80

    NSLog(@"@min.priceValue=%@", [bookclasses valueForKeyPath:@"@min.priceValue"]);
    //@min.priceValue=20

    NSLog(@"@sum.priceValue=%@", [bookclasses valueForKeyPath:@"@sum.priceValue"]);
    //@sum.priceValue=450

    NSLog(@"@distinctUnionOfObjects.priceValue=%@", [bookclasses valueForKeyPath:@"@distinctUnionOfObjects.priceValue"]);
    //@distinctUnionOfObjects.priceValue=(70,40,80,50,20,60,30)

    NSLog(@"@unionOfObjects.priceValue=%@", [bookclasses valueForKeyPath:@"@unionOfObjects.priceValue"]);
    //@unionOfObjects.priceValue=(20,20,30,40,50,60,70,80,80)

    NSMutableArray *unionOfBookclasses = [NSMutableArray arrayWithCapacity:2];
    [unionOfBookclasses addObject:bookclasses];
    [unionOfBookclasses addObject:bookclasses];
    NSLog(@"@distinctUnionOfArrays.priceValue=%@", [unionOfBookclasses valueForKeyPath:@"@distinctUnionOfArrays.priceValue"]);
    //@distinctUnionOfArrays.priceValue=(40,80,30,70,20,60,50)

    NSLog(@"@unionOfArrays.priceValue=%@", [unionOfBookclasses valueForKeyPath:@"@unionOfArrays.priceValue"]);
    //@unionOfArrays.priceValue=(20,20,30,40,50,60,70,80,80,20,20,30,40,50,60,70,80,80)
        
    //    NXTeacher *teacher = [[NXTeacher alloc] init];
    //    [teacher setValue:@"uuidValue" forKey:@"ssKey"];
    //    NSString *value = [teacher valueForKey:@"ssKey"];
    //    NSLog(@"___value=%@", value);
#endif
}
@end
