//
//  NXResize.swift
//  NXKit
//
//  Created by niegaotao on 2020/9/18.
//

import UIKit

open class NXResize {
    public static let side = "side" //图片变长/目标边长：所谓缩放系数
    public static let area = "area" //开平方（图片宽高相乘/目标宽高相乘）：作为缩放系数
    public static let none = "none" //不缩放
    
    open class func resize(by:String, _ targetSize:CGSize, _ fixedSize:CGSize, _ floorAllowed:Bool) -> CGSize {
        var retValue = targetSize
        if targetSize.width == 0 || targetSize.height == 0 || fixedSize.width == 0 || fixedSize.height == 0 {
            return retValue
        }
        if by == NXResize.area {
            let ratioValue = CGFloat(sqrtf(Float((retValue.width * retValue.height)/(fixedSize.width * fixedSize.height))))
            if ratioValue > 1 {
                retValue.width = retValue.width / ratioValue
                retValue.height = retValue.height / ratioValue
                
                if floorAllowed {
                    retValue.width = floor(retValue.width)
                    retValue.height = floor(retValue.height)
                }
            }
        }
        else if by == NXResize.side {
            let ratioMaxValue = max(targetSize.width, targetSize.height)/max(fixedSize.width, fixedSize.height)
            let ratioMinValue = min(targetSize.width, targetSize.height)/min(fixedSize.width, fixedSize.height)
            let ratioValue = max(ratioMaxValue, ratioMinValue)
            if ratioValue > 1 {
                retValue.width = retValue.width / ratioValue
                retValue.height = retValue.height / ratioValue
                
                if floorAllowed {
                    retValue.width = floor(retValue.width)
                    retValue.height = floor(retValue.height)
                }
            }
        }
        else if by == NXResize.none {
            
        }
        
        return retValue
    }
    
    open class func resize(_ image:UIImage, _ size:CGSize) -> UIImage? {
        if size.width <= 0 || size.height == 0 {
            return nil
        }
        if image.size.width * image.scale > size.width || image.size.height * image.scale > size.height {
            UIGraphicsBeginImageContext(size)
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let outputImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return outputImage
        }
        return nil
    }
}
