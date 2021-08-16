//
//  NXPrintf.swift
//  NXKit
//
//  Created by firelonely on 2018/6/20.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

/*
 log输出
 
 在TARGETS --> Build Settings --> Swift Complier - Custom Flags --> Other Swift Flags --> DEBUG格式 -D DEBUGSWIFT 。      实现在debug下打印日志，在release不打印
 */

/*
 *  格式化后的时间 ：时间格式 “yyyy-MM-dd HH:mm” 单位s
 */
public func getTimeDate(_ time:TimeInterval ,_ timeformat:String) -> String {
    let date = Date(timeIntervalSince1970: time)
    let formatter = DateFormatter()
    formatter.dateFormat = timeformat
    let strTime = formatter.string(from: date)
    return strTime
}

/*
 *  获取当前时间：时间格式 “yyyy-MM-dd HH:mm” 单位s
 */
public func getCurrentTime(_ timeformat:String) -> String {
    let currentTime = Date().timeIntervalSince1970
    return getTimeDate(currentTime, timeformat)
}

/*
 打印普通日志
 */
public func NXPrint<T>(_ items:T ,file:String = #file,method: String = #function,line: Int = #line) {
    #if DEBUG
    let format = "YYYY-MM-dd HH:mm:ss SSS"
    let time = getCurrentTime(format)
    print("\((file as NSString).lastPathComponent)[\(line)],\(method):-----💚💚💚💚💚💚💚💚\(time)-----\n\(items)\n")
    #endif
}




/*
 打印错误日志
 */
public func NXPrintError<T>(_ items:T ,file:String = #file,method: String = #function,line: Int = #line) {
    #if DEBUG
    let format = "YYYY-MM-dd HH:mm:ss SSS"
    let time = getCurrentTime(format)
    print("\((file as NSString).lastPathComponent)[\(line)],\(method):-----💔💔💔💔💔💔💔💔\(time)-----\n\(items)\n")
    #endif
}




/*
 打印Warn日志
 */
public func NXPrintWarm<T>(_ items:T ,file:String = #file,method: String = #function,line: Int = #line) {
    #if DEBUG
    let format = "YYYY-MM-dd HH:mm:ss SSS"
    let time = getCurrentTime(format)
    print("\((file as NSString).lastPathComponent)[\(line)],\(method):-----💛💛💛💛💛💛💛💛\(time)-----\n\(items)\n")
    #endif
}



/*
 打印网络日志---成功
 */
public func NXPrintHttpSuccess<T>(_ items:T ,file:String = #file,method: String = #function,line: Int = #line) {
    #if DEBUG
    let format = "YYYY-MM-dd HH:mm:ss SSS"
    let time = getCurrentTime(format)
    print("\((file as NSString).lastPathComponent)[\(line)],\(method):-----🌍💚🌍💚🌍💚🌍💚\(time)-----\n\(items)\n")
    #endif
}

/*
 打印网络日志---失败
 */
public func NXPrintHttpFailed<T>(_ items:T ,file:String = #file,method: String = #function,line: Int = #line) {
    #if DEBUG
    let format = "YYYY-MM-dd HH:mm:ss SSS"
    let time = getCurrentTime(format)
    print("\((file as NSString).lastPathComponent)[\(line)],\(method):-----🌍💔🌍💔🌍💔🌍💔\(time)-----\n\(items)\n")
    #endif
}





/*
 des
 
 打印当前时间的描述，例如方法名，例如“-------”
 
 打印格式为YYYY-MM-dd HH:mm:ss SSS
 */
public func NXPrintTmpTime(_ des:String) {
    let format = "YYYY-MM-dd HH:mm:ss SSS"
    let time = getCurrentTime(format)
    print(des + " time is :" + time)
}


