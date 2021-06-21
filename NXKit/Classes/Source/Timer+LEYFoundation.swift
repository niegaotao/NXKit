//
//  Timer+LEYFoundation.swift
//  NXFoundation
//
//  Created by firelonely on 2018/5/28.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import Foundation


/*
 Timer 扩展
 
 after   无重复计时器
 every   重复计时器
 
 after、every 添加到默认的NSDefaultRunLoopMode上
 new     对应生成after或者every类型的timer，但是没加到RunLoop，我们可以手动触发start开启。例如滑动的时候RunLoop会自动切换到 UITrackingRunLoopMode，需要对应控制
 

 
 @nonobjc              用来标记oc中不支持的方法
 @discardableResult    取消如果不使用返回值的警告
 */

extension Timer {
    
    /*
     生成Timer，并自动调用start方法
     */
    @discardableResult
    public class func after(_ interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        let timer = Timer.new(after: interval, block)
        timer.start()
        return timer
    }
    
    @nonobjc @discardableResult
    public class func every(_ interval: TimeInterval, _ block: @escaping (Timer) -> Void) -> Timer {
        let timer = Timer.new(every: interval, block)
        timer.start()
        return timer
    }
    
    

    
    /*
     只生成Timer，需要手动将定时器添加到指定的RunLoop中
     
     public func CFRunLoopTimerCreateWithHandler(_ allocator: CFAllocator!, _ fireDate: CFAbsoluteTime, _ interval: CFTimeInterval, _ flags: CFOptionFlags, _ order: CFIndex, _ block: ((CFRunLoopTimer?) -> Swift.Void)!) -> CFRunLoopTimer!
     allocator： 分配器使用为新对象分配内存。通过NULL或kCFAllocatorDefault使用当前默认的分配器。
     fireDate：  定时器开始的时间
     interval：  定时器执行间隔，如果是0或负数，则执行一次后自动失效
     flags：     目前忽略。通过0为未来的兼容性
     order：     运行定时器循环的优先级
     */
    public class func new(after interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        return CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, 0, 0, 0) { _ in
            block()
        }
    }
    
    @nonobjc public class func new(every interval: TimeInterval, _ block: @escaping (Timer) -> Void) -> Timer {
        var timer: Timer!
        timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0) { _ in
            block(timer)
        }
        return timer
    }
    
    
    
    
    // start 将定时器加入RunLoop，开启定时器循环
    public func start(runLoop: RunLoop = .current, modes: RunLoop.Mode...) {
        let modes = modes.isEmpty ? [RunLoop.Mode.default] : modes
        
        for mode in modes {
            runLoop.add(self, forMode: mode)
        }
    }
}



/*
 扩展Double
 
 给double添加几个变量，返回对应的毫秒、秒、分、小时、天为单位的TimeInterval类型值
 
 例如：
 1000.ms 表示1000毫秒，折算成TimeInterval为1s
 10.minutes 表示10分钟，折算成TimeInterval为10 * 60s
 */

extension Double {
    /*毫秒*/
    public var ms: TimeInterval           { return self / 1000 }
    
    /*秒*/
    public var seconds: TimeInterval      { return self }
    
    /*分*/
    public var minutes: TimeInterval      { return self * 60 }
    
    /*小时*/
    public var hours: TimeInterval        { return self * 3600 }
    
    /*天*/
    public var days: TimeInterval         { return self * 3600 * 24 }
}



