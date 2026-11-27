//
//  NXString.swift
//  NXKit
//
//  Created by niegaotao on 2020/1/12.
//

import UIKit

open class NXString {
    open var frame = CGRect.zero
    open var color  = NX.darkBlackColor
    open var lineSpacing : CGFloat = 0.0
    open var text = ""
    open var font = NX.font(15)
    open var query = [String:Any]()
    public init(){}
}

extension NXString {
    open class func string(_ text:String, _ font:UIFont, _ color:UIColor, _ lineSpacing:CGFloat) -> NXString {
        let textWrapper = NXString()
        textWrapper.text = text
        textWrapper.font = font
        textWrapper.color = color
        textWrapper.lineSpacing = lineSpacing
        return textWrapper
    }
    
    open class func string(_ text:String, _ font:UIFont, _ color:UIColor, _ lineSpacing:CGFloat, _ query:[String:Any]) -> NXString {
        let textWrapper = NXString()
        textWrapper.text = text
        textWrapper.font = font
        textWrapper.color = color
        textWrapper.lineSpacing = lineSpacing
        textWrapper.query = query
        return textWrapper
    }
    
    open class func attributedString(_ text:String, _ font:UIFont, _ color:UIColor, _ lineSpacing:CGFloat) -> NSMutableAttributedString {
        var mapValue = [NSAttributedString.Key:Any]()
        mapValue[NSAttributedString.Key.font] = font
        mapValue[NSAttributedString.Key.foregroundColor] = color
        mapValue[NSAttributedString.Key.paragraphStyle] = {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            return paragraphStyle
        }()
        let attributedText = NSMutableAttributedString(string: text, attributes: mapValue)
        return attributedText
    }
    
    open class func attributedString(_ strings:[NXString], _ lineSpacing:CGFloat) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString()
        for string in strings {
            var mapValue = [NSAttributedString.Key:Any]()
            mapValue[NSAttributedString.Key.font] = string.font
            mapValue[NSAttributedString.Key.foregroundColor] = string.color
            mapValue[NSAttributedString.Key.paragraphStyle] = {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = lineSpacing
                paragraphStyle.lineHeightMultiple = 1.25
                return paragraphStyle
            }()
            
            let subattributedText = NSMutableAttributedString(string: string.text, attributes: mapValue)
            if string.query.count > 0 {
                subattributedText.addAttribute(NSAttributedString.Key.link, value: "yyjk://query?query="+NXSerialization.JSONObject(toString: string.query, encode: true), range: NSMakeRange(0, (string.text as NSString).length))
            }
            attributedText.append(subattributedText)
        }
        return attributedText
    }
}
