//
//  NXPerson.h
//  NXKit_Example
//
//  Created by niegaotao on 2021/6/30.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSObject(NXKit)
+ (void)test;
- (void)test;
@end


/*====================================================*/
@interface NXPerson : NSObject {
    NSString *_id;
}
@property (nonatomic, copy) NSString *name;
- (void)sleep;
+ (void)classSleep;
@end

/*====================================================*/
@interface NXTeacher : NXPerson {
    NSString *_uuid;
}
@property (nonatomic, copy) NSString *nickname;
- (void)work;
+ (void)classWork;
@end


/*====================================================*/
@interface NXStudent : NXPerson {
    NSString *_union;
}
@property (nonatomic, copy) NSString *college;
- (void)work;
+ (void)classWork;
@end




/*====================================================*/
@interface NXCollegeStudent : NXStudent
@end
/*====================================================*/
NS_ASSUME_NONNULL_END


