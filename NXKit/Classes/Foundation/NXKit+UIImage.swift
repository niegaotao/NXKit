//
//  UIImage+NXFoundation.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/4.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//


import Foundation
import UIKit

/*
 颜色生成图片
 */
extension UIImage {
    
    public enum Direction {
        case landscape, vertical
    }
    
    public class func image(color:UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        color.set()
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    //生成渐变色图片
    public class func image(colors:[UIColor], size:CGSize, start: CGPoint, end: CGPoint) -> UIImage? {
        guard colors.count >= 1 else {
            return nil
        }
        if colors.count == 1 {
            return UIImage.image(color: colors[0], size: size)
        }
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        var outoutImage : UIImage? = nil
        let colorSpace = colors.last?.cgColor.colorSpace
        if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors.map {$0.cgColor} as CFArray, locations: nil) {
            context.drawLinearGradient(gradient, start: start, end: end, options: CGGradientDrawingOptions(rawValue: 0))
            outoutImage  = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return outoutImage
    }
    
    public class func image(backgroundColor:UIColor, foregroundColor:UIColor, size:CGSize) -> UIImage? {
        let background = UIImage.image(color: backgroundColor, size: size)
        let foreground = UIImage.image(color: foregroundColor.withAlphaComponent(0.5), size: size)
        UIGraphicsBeginImageContext(size)
        background?.draw(in: CGRect(origin: CGPoint.zero, size: size))
        foreground?.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}



/*
 缩放图片到指定尺寸   resizeIO
 参考:https://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MjM5OTM0MzIwMQ==&uin=MTMxNzk5MDUyMA%3D%3D&key=0ebe2254ddc5bcb61e07dc03462c3590013e868156c5d300842f6c1134d03e2f7214e3f7d908da9dc82a8a49bb387c0b0ae49d98e3e867d4426d31fb9791a63cd21ca2f803ecefa742de6848dd64f1f4&devicetype=iMac+MacBookPro14%2C1+OSX+OSX+10.13.5+build(17F77)&version=12030f10&lang=zh_CN&nettype=WIFI&ascene=0&fontScale=100&pass_ticket=pTmkgnt9JePN4xsrXMG0ALGnUNwkmtpxJ%2FrvWqIZU8JpWfsp57MI9gjr0rFkYyFX#wechat_webview_type=1
 
 缩放图片到指定大小   compressImageToByte
 
 */
extension UIImage {
    public class func resize(image: UIImage?, size:CGSize, by:String) -> UIImage? {
        guard let _image = image else {
            return nil
        }
        var __size = CGSize(width: _image.size.width*_image.scale, height: _image.size.height*_image.scale)
        __size = NXClip.resize(by: by, __size, size, true)
        UIGraphicsBeginImageContext(__size)
        _image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: __size))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    
    
    /*
     图片压缩大小分两种，
     一种是压缩内容，设置下阀值，最多压缩6次，避免压缩次数过多，影响效率
     另一种是等比例缩放
     
     具体做法是先按照内容压缩，最多10次，防止失真；然后等比例缩放
     */
    public func compressImageToByte(length: Int) -> Data {
        var compression:CGFloat = 1
        var data = self.jpegData(compressionQuality: compression)!
        
        guard data.count > length else {
            return data
        }
        
        //二分法查找,每次查找范围为[length * 0.9, length) 找到一个合适的compression
        var max:CGFloat = 1
        var min:CGFloat = 0
        
        for _ in 0...10 {
            compression = (max + min) / 2
            data = self.jpegData(compressionQuality: compression)!
            
            if Double(data.count) < Double(length) * 0.9 {
                min = compression
            } else if data.count > length {
                max = compression
            } else {
                break
            }
        }
        
        //比较大小，在范围内则直接返回Data
        guard data.count > length else {
            return data
        }
        
        var resultImage = UIImage(data: data as Data)!
        
        var lastDataLength:Int = 0
        while data.count > length && data.count != lastDataLength {
            lastDataLength = data.count
            
            let ratio:Float = Float(length) / Float(data.count)
            let size:CGSize = CGSize(width: CGFloat(Int(Float(resultImage.size.width) * sqrtf(ratio))), height:CGFloat(Int(Float(resultImage.size.height) * sqrtf(ratio))))
            
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = resultImage.jpegData(compressionQuality: compression)!
        }
        
        return data
    }
    
}



/*
 获取图片的平均色值
 */
extension UIImage {
    public class func avarageColor(image:UIImage?) -> UIColor? {
        guard let image = image else {
            return nil
        }
        let rgba = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        guard let context = CGContext(
            data: rgba,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ) else {
                return nil
        }
        if let cgImage = image.cgImage {
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: 1, height: 1))
            
            return UIColor(
                red: CGFloat(rgba[0]) / 255.0,
                green: CGFloat(rgba[1]) / 255.0,
                blue: CGFloat(rgba[2]) / 255.0,
                alpha: CGFloat(rgba[3]) / 255.0
            )
        }
        return nil
    }
}

extension UIImage {
    //把图像调整为头部朝上的方向
    public class func fixedOrientation(image:UIImage?) -> UIImage? {
        guard let image = image else {
            return nil
        }
        let __imageOriention = image.imageOrientation
        if __imageOriention == .up {
            return image
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let fixedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return fixedImage
    }
    
    //返回特定颜色的图片
    public class func image(image:UIImage?, color: UIColor, blendMode: CGBlendMode = .destinationIn) -> UIImage? {
        guard let image = image else {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        color.setFill()
        
        let bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIRectFill(bounds)
        
        image.draw(in: bounds, blendMode: blendMode, alpha: 1.0)
        if blendMode != .destinationIn {
            image.draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
        }
        let __image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return __image
    }
}



