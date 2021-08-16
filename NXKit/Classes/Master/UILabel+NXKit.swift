//
//  UILabel+NXFoundation.swift
//  NXKit
//
//  Created by firelonely on 2018/5/7.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import Foundation
import UIKit


extension UILabel {
    
    /*
     初始化
     
     frame:显示范围
     text:文案
     font:字号
     color:颜色
     alignment:对齐方式
     */
    public convenience init(frame: CGRect,
                            text: String,
                            font: UIFont,
                            textColor: UIColor,
                            textAlignment: NSTextAlignment,
                            lineSpacing:CGFloat,
                            completion:NX.Completion<String, NSMutableParagraphStyle>? = nil) {
        self.init(frame:frame)
        
        self.updateSubviews(text: text,
                            font: font,
                            textColor: textColor,
                            textAlignment: textAlignment,
                            lineSpacing: lineSpacing,
                            numberOfLines: 0,
                            completion: completion)
    }
    
    open func updateSubviews(text: String,
                     font: UIFont,
                     textColor: UIColor,
                     textAlignment: NSTextAlignment,
                     lineSpacing:CGFloat,
                     numberOfLines:Int,
                     completion:NX.Completion<String, NSMutableParagraphStyle>? = nil){
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.paragraphSpacingBefore = 0
        paragraphStyle.headIndent = 0
        paragraphStyle.tailIndent = 0
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineSpacing = lineSpacing
        completion?("", paragraphStyle)
        
        self.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font,NSAttributedString.Key.paragraphStyle: paragraphStyle])

    }
}



/*
 给label添加下方线条
 */
extension UILabel {
    
    public convenience init(frame: CGRect?, text: String?, font: UIFont, color: UIColor, alignment: NSTextAlignment) {
        self.init()
    
        if frame != nil {
            self.frame = frame!
        }
        self.text = text
        self.font = font
        self.textColor = color
        self.textAlignment = alignment
        self.numberOfLines = 0
    }
    
    public convenience init(frame: CGRect?, lineSpace: CGFloat, text: String, font: UIFont, color: UIColor, alignment: NSTextAlignment) {
        self.init()
        
        if frame != nil {
            self.frame = frame!
        }
        self.text = text
        self.font = font
        self.textColor = color
        self.textAlignment = alignment
        self.numberOfLines = 0

        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.paragraphSpacingBefore = 0
        paragraphStyle.headIndent = 0
        paragraphStyle.tailIndent = 0
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = lineSpace
        
        let attributes = [NSAttributedString.Key.font: font,
                         NSAttributedString.Key.paragraphStyle: paragraphStyle
                         ]
        let attributeStr = NSAttributedString.init(string: text, attributes: attributes)
        self.attributedText = attributeStr
    }

    
    public func addBottomColorView(color: UIColor = NX.mainColor.withAlphaComponent(0.85), height: CGFloat = 7) {
        guard let str = self.text else {
            return
        }
 
        
        let width = str.stringWidth(font: self.font, size: CGSize(width: NXDevice.width, height: 50))
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: width, height: height))

        if let superView = self.superview {
            superView.addSubview(view)
            view.center = CGPoint(x: self.center.x, y: self.center.y + 10)
            superView.bringSubviewToFront(view)
        }
        
    }
}



