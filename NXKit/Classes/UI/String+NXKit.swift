//
//  String+NXFoundation.swift
//  NXKit
//
//  Created by niegaotao on 2018/5/29.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import Foundation
import CommonCrypto


/*
 字符串的扩展，返回其他数据
 */
extension String {
    /*
     md5
     */
    public var md5: String {
        let cStr = self.cString(using: .utf8)
        let buff = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buff)
        let md5String = NSMutableString()
        for i in 0 ..< 16 {
            md5String.appendFormat("%02x", buff[i])
        }
        free(buff)
        
        return md5String as String
    }
    
    
    
    //base64加密
    public var base64Encode: String? {
        if let data = self.data(using: String.Encoding.utf8) {
            return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        }
        return nil
    }
    
    
    //base64解密
    public var base64Decode: String? {
        if let data = Data(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0)) {
            return String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        }
        return nil
    }
}



/*
 stringSize 返回字符串的size
 
 stringWidth 返回字符串宽度
 
 stringHeight 返回字符串高度
 */
extension String {
    
    public func stringSize(font: UIFont, size: CGSize) -> CGSize {
        return self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
    }
    
    public func stringWidth(font: UIFont, size: CGSize) -> CGFloat {
        return stringSize(font: font, size: size).width
    }
    
    public func stringHeight(font: UIFont, size: CGSize) -> CGFloat {
        return stringSize(font: font, size: size).height
    }
    
    //对于富文本的计算，block中返回paragraphStyle实例，用于文本排版的样式的设定
    //NSParagraphStyleAttributeName 段落的风格（设置首行，行间距，对齐方式什么的）看自己需要什么属性，写什么
    /*
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    paragraphStyle.firstLineHeadIndent = 20.0f;//首行缩进
    paragraphStyle.alignment = NSTextAlignmentJustified;//（两端对齐的）文本对齐方式：（左，中，右，两端对齐，自然）
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;//结尾部分的内容以……方式省略 ( "...wxyz" ,"abcd..." ,"ab...yz")
    paragraphStyle.headIndent = 20;//整体缩进(首行除外)
    paragraphStyle.tailIndent = 20;//
    paragraphStyle.minimumLineHeight = 10;//最低行高
    paragraphStyle.maximumLineHeight = 20;//最大行高
    paragraphStyle.paragraphSpacing = 15;//段与段之间的间距
    paragraphStyle.paragraphSpacingBefore = 22.0f;//段首行空白空间/* Distance between the bottom of the previous paragraph (or the end of its paragraphSpacing, if any) and the top of this paragraph. */
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;//从左到右的书写方向（一共➡️三种）
    paragraphStyle.lineHeightMultiple = 15;/* Natural line height is multiplied by this factor (if positive) before being constrained by minimum and maximum line height. */
    paragraphStyle.hyphenationFactor = 1;//连字属性 在iOS，唯一支持的值分别为0和1
    */
    
    static public func size(of text: String?, size: CGSize, font: UIFont, style:((_ paragraphStyle:NSMutableParagraphStyle) ->())? = nil) -> CGSize {
        guard let __text = text else {
            return CGSize.zero
        }
        if __text.isEmpty {
            return CGSize.zero
        }
        var options = [NSAttributedString.Key:Any]()
        options[NSAttributedString.Key.font] = font
        if style != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            style?(paragraphStyle)
            options[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        }
        return __text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: options, context: nil).size
    }
}




/*
 String的功能方法
 */
extension String {
    /*
     从字符串中找出所有的以from为前缀，to为后缀的内容
     
     from: 前缀
     to: 后缀
     */
    public func componentsSeparated(from: String, to: String) -> [String]? {
        var array = [String]()
        
        var tmpStr = self
        var range = tmpStr.range(of: from)
        while range != nil {
            tmpStr = String(tmpStr[(range?.upperBound)!...]) //tmpStr.substring(from: (range?.upperBound)!)
            
            range = tmpStr.range(of: to)
            if range != nil {
                array.append(String(tmpStr[..<(range?.lowerBound)!]))
                
                range = tmpStr.range(of: from)
            } else {
                break
            }
        }
        
        if array.count == 0 {
            return nil
        }
        return array
    }
    
    /// range转换为NSRange
    public func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    
    /*
     *  判断手机号合法性
     */
    public func isMobileNumber() -> Bool {
        let mobile = "^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$"
        let  CM = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)"
        let  CU = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)"
        let  CT = "(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        if ((regextestmobile.evaluate(with: self) == true)
            || (regextestcm.evaluate(with: self)  == true)
            || (regextestct.evaluate(with: self) == true)
            || (regextestcu.evaluate(with: self) == true))
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    
    /*
     *  把String转化为对应的class的ViewController
     */
    public func classFromString() -> UIViewController? {
        //Swift中命名空间的概念
        let namespace = NX.namespace
        if namespace.isEmpty {
            return nil
        }
        guard let childVcClass = NSClassFromString(namespace + "." + self) else {
            return nil
        }
        guard let childVcType = childVcClass as? UIViewController.Type else {
            return nil
        }
        let vc = childVcType.init()
        return vc
    }
    
    //去除首尾的空格
    public func trimWhitespaces() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    //去除首尾的换行符
    public func trimNewlines() -> String {
        return self.trimmingCharacters(in: .newlines)
    }
    
    //去除首尾的空格+换行符
    public func trimWhitespacesNewlines() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    //去除控制字符
    public func trimControlCharacters() -> String {
        return self.trimmingCharacters(in: .controlCharacters)
    }
    
    //去除所有的换行—+空格
    public func trimAllWhitespacesNewlines() -> String {
        var retValue = self
        retValue = retValue.replacingOccurrences(of: " ", with: "")
        retValue = retValue.replacingOccurrences(of: "\r", with: "")
        retValue = retValue.replacingOccurrences(of: "\n", with: "")
        return retValue
    }

}

