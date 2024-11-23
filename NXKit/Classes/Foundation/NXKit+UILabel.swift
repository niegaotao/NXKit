//
//  NXKit+UILabel.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/7.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import Foundation
import UIKit

public extension UILabel {
    /*
     初始化

     frame:显示范围
     text:文案
     font:字号
     color:颜色
     alignment:对齐方式
     */
    convenience init(frame: CGRect,
                     text: String,
                     font: UIFont,
                     textColor: UIColor,
                     textAlignment: NSTextAlignment,
                     lineSpacing: CGFloat,
                     completion: NXKit.Event<String, NSMutableParagraphStyle>? = nil)
    {
        self.init(frame: frame)

        updateSubviews(text: text,
                       font: font,
                       textColor: textColor,
                       textAlignment: textAlignment,
                       lineSpacing: lineSpacing,
                       numberOfLines: 0,
                       completion: completion)
    }

    func updateSubviews(text: String,
                        font: UIFont,
                        textColor: UIColor,
                        textAlignment: NSTextAlignment,
                        lineSpacing: CGFloat,
                        numberOfLines: Int,
                        completion: NXKit.Event<String, NSMutableParagraphStyle>? = nil)
    {
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

        attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
}

/*
 给label添加下方线条
 */
public extension UILabel {
    convenience init(frame: CGRect?, text: String?, font: UIFont, color: UIColor, alignment: NSTextAlignment) {
        self.init()

        if frame != nil {
            self.frame = frame!
        }
        self.text = text
        self.font = font
        textColor = color
        textAlignment = alignment
        numberOfLines = 0
    }

    convenience init(frame: CGRect?, lineSpace: CGFloat, text: String, font: UIFont, color: UIColor, alignment: NSTextAlignment) {
        self.init()

        if frame != nil {
            self.frame = frame!
        }
        self.text = text
        self.font = font
        textColor = color
        textAlignment = alignment
        numberOfLines = 0

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.paragraphSpacingBefore = 0
        paragraphStyle.headIndent = 0
        paragraphStyle.tailIndent = 0
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = lineSpace

        let attributes = [NSAttributedString.Key.font: font,
                          NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let attributeStr = NSAttributedString(string: text, attributes: attributes)
        attributedText = attributeStr
    }

    func addBottomColorView(color _: UIColor = NXKit.primaryColor.withAlphaComponent(0.85), height: CGFloat = 7) {
        guard let str = text else {
            return
        }

        let width = str.stringWidth(font: font, size: CGSize(width: NXKit.width, height: 50))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))

        if let superView = superview {
            superView.addSubview(view)
            view.center = CGPoint(x: center.x, y: center.y + 10)
            superView.bringSubviewToFront(view)
        }
    }
}
