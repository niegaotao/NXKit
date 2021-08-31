//
//  NXAssetClipImageViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/11/1.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit


open class NXAssetClipImageViewController: NXViewController {
    open var image : UIImage? = nil
    
    open var clips = NX.Wrappable<Int, [NXAsset.Clip]> { (_, __sender) in
        __sender.index = -1
        __sender.value = []
    }
    public let backgroundView = NXCView<UIImageView>(frame: CGRect(x: 10, y: 10, width: NXDevice.width-20, height: NXDevice.height-NXDevice.topOffset-NXDevice.bottomOffset-20))
    public let clipboardView = NXClipboardView(frame: CGRect.zero)
    public let footerView = NXCView<UIScrollView>(frame: CGRect(x: 0, y: 0, width: NXDevice.width, height: 80+NXDevice.bottomOffset))
    public var componentViews = [UILabel]()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.naviView.title = "裁剪"
        
        self.contentView.clipsToBounds = true
        self.naviView.forwardBar = NXNaviView.Bar.forward(image: nil, title: "保存", completion: {[weak self] (_) in
            self?.dispose("forward", nil)
        })
        
        self.setupSubviews()
    }
    
    override open func setupSubviews() {
        self.contentView.backgroundColor = NX.color(0x181818)
        
        self.backgroundView.backgroundColor = NX.color(0x181818)
        self.backgroundView.contentView.image = self.image
        self.backgroundView.contentView.contentMode = .scaleAspectFit
        self.contentView.addSubview(self.backgroundView)
        
        self.footerView.frame = CGRect(x: 0, y: self.contentView.h-self.footerView.h, width: self.footerView.w, height: self.footerView.h)
        self.footerView.backgroundColor = NX.color(0x181818)
        self.footerView.contentView.backgroundColor = NX.color(0x181818)
        self.footerView.setupSeparator(color: nil, ats: [])
        self.contentView.addSubview(self.footerView)
        
        if let image = self.image, image.size.width > 0 && image.size.height > 0, self.clips.value.count >= 1 {
            
            if self.clips.index < 0 || self.clips.index >= self.clips.value.count {
                self.clips.index = 0
            }
            
            var __background = CGRect(x: 10, y: 10, width: NXDevice.width-20, height: NXDevice.height-NXDevice.topOffset-NXDevice.bottomOffset-20)
            if self.clips.value.count >= 2 {
                //有多项可选
                __background = CGRect(x: 10, y: 10, width: NXDevice.width-20, height: NXDevice.height-NXDevice.topOffset-NXDevice.bottomOffset-20-80)
                
                var offset = CGRect(x: 15, y: 8, width: 52, height: 60)
                var ctx = CGRect(x: 15, y: 0, width: CGFloat(self.clips.value.count) * offset.size.width + CGFloat(self.clips.value.count - 1)*10.0, height: offset.size.height)
                if (NXDevice.width - ctx.size.width) / 2.0 > ctx.origin.x {
                    ctx.origin.x = (NXDevice.width - ctx.size.width) / 2.0
                }
                offset.origin.x = ctx.origin.x
                
                for (index, clip) in self.clips.value.enumerated() {
                    let componentView = UILabel(frame: CGRect(x: offset.origin.x, y: offset.origin.y, width: offset.size.width, height: offset.size.height))
                    componentView.tag = index
                    componentView.font = NX.font(13)
                    componentView.textAlignment = .center
                    componentView.text = "\(Int(clip.width)):\(Int(clip.height))"
                    componentView.layer.cornerRadius = 2.0
                    componentView.layer.masksToBounds = true
                    componentView.setupEvents([.tap]) {[weak self] (_, sender) in
                        self?.dispose("footer", sender, nil)
                    }
                    if index == self.clips.index {
                        componentView.backgroundColor = UIColor.white
                        componentView.textColor = NX.color(0x181818)
                    }
                    else {
                        componentView.backgroundColor = NX.color(0x3d3d3d)
                        componentView.textColor = UIColor.white
                    }
                    self.footerView.contentView.addSubview(componentView)
                    self.componentViews.append(componentView)
                    
                    if index == self.clips.value.count - 1 {
                        offset.origin.x = offset.origin.x + componentView.frame.size.width
                    }
                    else {
                        offset.origin.x = offset.origin.x + componentView.frame.size.width + 10
                    }
                }
                offset.origin.x = offset.origin.x + ctx.origin.x
                self.footerView.isHidden = false
                self.footerView.contentView.frame = CGRect(x: 0, y: 0, width: NXDevice.width, height: 80)
                self.footerView.contentView.contentSize = CGSize(width: max(self.footerView.contentView.frame.size.width, offset.origin.x), height: 80)
            }
            else {
                //仅有一项
                self.footerView.isHidden = true
            }
            
            let __pfsValue = max(image.size.width/__background.size.width, image.size.height/__background.size.height)
            let __size = CGSize(width: image.size.width/__pfsValue, height: image.size.height/__pfsValue)
            let __frame = CGRect(x: (__background.size.width - __size.width)/2.0,
                                 y: (__background.size.height - __size.height)/2.0,
                                 width: __size.width,
                                 height: __size.height)
            self.backgroundView.frame = __background
            self.backgroundView.contentView.frame = __frame
            
            self.clipboardView.frame = __frame
            self.clipboardView.backgroundColor = UIColor.clear
            self.clipboardView.wrapped.size.width = __frame.size.width
            self.clipboardView.wrapped.size.height = __frame.size.height
            
            self.clipboardView.wrapped.clip.isResizable = self.clips.value[self.clips.index].isResizable
            self.clipboardView.wrapped.clip.width = self.clips.value[self.clips.index].width
            self.clipboardView.wrapped.clip.height = self.clips.value[self.clips.index].height
            self.clipboardView.wrapped.clip.isHidden = self.clips.value[self.clips.index].isHidden
            
            self.clipboardView.updateSubviews("", nil)
            
            self.backgroundView.addSubview(self.clipboardView)
        }
        else {
            self.clipboardView.isHidden = true
            self.footerView.isHidden = true
        }
    }
    
    open override func dispose(_ action: String, _ value: Any?, _ completion: NX.Completion<String, Any?>? = nil) {
        if action == "forward" {
            
            guard let image = self.image, image.size.width > 0 && image.size.height > 0, self.clipboardView.wrapped.size.width > 0 else {
                self.ctxs.completion?("", nil)
                return
            }
            
            var pfsValue : (size:CGSize, scale:CGFloat, frame: CGRect) = (CGSize.zero, 1.0, CGRect.zero)
            pfsValue.size.width = image.size.width * image.scale
            pfsValue.size.height = image.size.height * image.scale
            pfsValue.scale = pfsValue.size.width / self.clipboardView.wrapped.size.width
            pfsValue.frame = self.clipboardView.wrappedView.frame
            pfsValue.frame.origin.x = floor(pfsValue.frame.origin.x * pfsValue.scale)
            pfsValue.frame.origin.y = floor(pfsValue.frame.origin.y * pfsValue.scale)
            pfsValue.frame.size.width = floor(pfsValue.frame.size.width * pfsValue.scale)
            pfsValue.frame.size.height = floor(pfsValue.frame.size.height * pfsValue.scale)
            
            guard let cgImage = image.cgImage?.cropping(to:pfsValue.frame) else {
                self.ctxs.completion?("", nil)
                return
            }
            let uiImage = UIImage(cgImage:cgImage)
            self.ctxs.completion?("", uiImage)
        }
        else if action == "footer" {
            guard let sender = value as? UILabel, sender.tag != self.clips.index else {
                return
            }
            self.clips.index = sender.tag
            
            for (index, componentView) in self.componentViews.enumerated() {
                
                if index == self.clips.index {
                    componentView.backgroundColor = UIColor.white
                    componentView.textColor = NX.color(0x181818)
                }
                else {
                    componentView.backgroundColor = NX.color(0x3d3d3d)
                    componentView.textColor = UIColor.white
                }
            }
            
            self.clipboardView.wrapped.clip.isResizable = self.clips.value[self.clips.index].isResizable
            self.clipboardView.wrapped.clip.width = self.clips.value[self.clips.index].width
            self.clipboardView.wrapped.clip.height = self.clips.value[self.clips.index].height
            self.clipboardView.wrapped.clip.isHidden = self.clips.value[self.clips.index].isHidden
            
            self.clipboardView.updateSubviews("", nil)
            
        }
    }
}
