//
//  NXNaviView.swift
//  NXKit
//
//  Created by niegaotao on 2020/6/23.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXNaviView: NXBackgroundView<UIImageView, UIView> {
    open weak var controller : NXViewController?
    
    open var backBar = NXNaviView.Bar.back(image:NX.image(named:"navi-back.png", mode: .alwaysTemplate), title: nil) //默认
    open var backView : UIView? {
        willSet{
            backView?.removeFromSuperview()
        }
        didSet {
            self.updateSubviews("", nil)
        }
    }
    
    open var title : String = "" {
        didSet {
            self.updateSubviews("", nil)
        }
    }
    
    open var titleView = UILabel(frame: CGRect(x: 75.0, y: NX.safeAreaInsets.top, width: NX.width-75.0*2, height: NX.topOffset-NX.safeAreaInsets.top))
    open var centerView : UIView? {
        willSet{
            centerView?.removeFromSuperview()
        }
        didSet {
            self.updateSubviews("", nil)
        }
    }
    
    open var forwardBar: NXNaviView.Bar? {
        willSet {
            forwardBar?.removeFromSuperview()
        }
        didSet {
            self.updateSubviews("", nil)
        }
    }
    
    open var forwardView : UIView? {
        willSet{
            forwardView?.removeFromSuperview()
        }
        didSet {
            self.updateSubviews("", nil)
        }
    }
    
    open var backBarHidden = false
    
    open var separator = CALayer()
    
    override open func setupSubviews(){
        super.setupSubviews()
                
        //这是整个导航栏的背景颜色
        self.backgroundView.frame = self.bounds
        self.backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backgroundView.tintColor = NX.barBackgroundColor;
        self.backgroundView.image = UIImage.image(color: NX.barBackgroundColor)?.withRenderingMode(.alwaysTemplate)

        //整个导航栏的子控件
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.backgroundColor = UIColor.clear
        
        self.titleView.frame = CGRect(x: 75.0, y: NX.safeAreaInsets.top, width: self.contentView.width-75.0*2, height: self.contentView.height-NX.safeAreaInsets.top)
        self.titleView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.titleView.textColor = NX.barForegroundColor
        self.titleView.tintColor = NX.barForegroundColor
        self.titleView.font = NX.font(17, .bold)
        self.titleView.textAlignment = .center
        self.contentView.addSubview(self.titleView)
        
        
        self.backBar.addTarget(nil, action: nil, completion:{[weak self] _ in
            self?.controller?.backBarAction()
        })
        self.backBar.autoresizingMask = [.flexibleHeight]
        self.backBar.frame = CGRect(x: 15, y: NX.safeAreaInsets.top, width: self.backBar.width, height: self.contentView.height-NX.safeAreaInsets.top)
        self.backBar.isHidden = true
        self.contentView.addSubview(self.backBar)
        
        self.separator.frame = CGRect(x: 0, y: self.contentView.height-NX.pixel, width: self.contentView.width, height: NX.pixel)
        self.separator.backgroundColor = NX.separatorColor.cgColor
        self.separator.isHidden = true
        self.contentView.layer.addSublayer(self.separator)
    }
    
    open override func updateSubviews(_ action:String, _ value:Any?){
        self.separator.frame = CGRect(x: 0, y: self.contentView.height-NX.pixel, width: self.contentView.width, height: NX.pixel)
        
        if true {
            let size = backBar.frame.size
            backBar.frame = CGRect(x: 15, y: NX.safeAreaInsets.top+(self.contentView.height-NX.safeAreaInsets.top-size.height)/2, width: size.width, height: size.height)
            
            if let controller = self.controller,
                let viewControllers = self.controller?.navigationController?.viewControllers,
                let index = viewControllers.firstIndex(of: controller), index >= 1 {
                self.backBar.isHidden = self.backBarHidden
            }
        }
        
        
        if let backView = self.backView {
            let size = backView.frame.size
            backView.frame = CGRect(x: 15, y: NX.safeAreaInsets.top+(self.contentView.height-NX.safeAreaInsets.top-size.height)/2, width: size.width, height: size.height)
            if backView.superview == nil {
                self.contentView.addSubview(backView)
            }
            self.backBar.isHidden = true
        }
        
        if true {
            if self.title.count > 0 {
                self.titleView.text = self.title
            }
            else if let title = self.controller?.title, title.count > 0 {
                self.titleView.text = title
            }
            let size = self.titleView.frame.size
            self.titleView.frame = CGRect(x: self.titleView.x, y: NX.safeAreaInsets.top+(self.contentView.height-NX.safeAreaInsets.top-size.height)/2, width: size.width, height: size.height)
        }
        
        
        if let centerView = self.centerView {
            let size = centerView.frame.size
            centerView.frame = CGRect(x: centerView.x, y: NX.safeAreaInsets.top+(self.contentView.height-NX.safeAreaInsets.top-size.height)/2, width: size.width, height: size.height)
            if centerView.superview == nil {
                self.contentView.addSubview(centerView)
            }
            self.titleView.isHidden = true
        }
        
        
        if let forwardView = self.forwardView {
            let size = forwardView.frame.size
            forwardView.frame = CGRect(x: self.contentView.width-15-size.width, y: NX.safeAreaInsets.top+(self.contentView.height-NX.safeAreaInsets.top-size.height)/2, width: size.width, height: size.height)
            if forwardView.superview == nil {
                self.contentView.addSubview(forwardView)
            }
        }
        else if let forwardBar = self.forwardBar {
            let size = forwardBar.frame.size
            forwardBar.frame = CGRect(x: self.contentView.width-15-size.width, y: NX.safeAreaInsets.top+(self.contentView.height-NX.safeAreaInsets.top-size.height)/2, width: size.width, height: size.height)
            if forwardBar.superview == nil {
                self.contentView.addSubview(forwardBar)
            }
        }
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.separator.backgroundColor = NX.separatorColor.cgColor
    }
}

extension NXNaviView {
    open class Bar: UIButton {
        open var dicValue : [String: Any]?
        public override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = UIColor.clear
            self.setupSubviews()
        }
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.backgroundColor = UIColor.clear
            self.setupSubviews()
        }
        
        open func setupSubviews(){
            self.frame.size = CGSize(width:70.0, height:44.0)
            self.setTitleColor(NX.barForegroundColor, for: .normal)
            self.setTitleColor(NX.lightGrayColor, for: .highlighted)
            self.tintColor = NX.barForegroundColor;
            self.titleLabel?.font = NX.font(17)
        }
        
        open class  func back(image: UIImage?, title: String?) -> NXNaviView.Bar {
            let element = NXNaviView.Bar(frame: CGRect.zero)
            element.contentHorizontalAlignment = .left
            element.updateSubviews(image, title)
            return element
        }
        
        open class  func back(image: UIImage?, title: String?, target:Any?, action:Selector?) -> NXNaviView.Bar {
            let element = NXNaviView.Bar.back(image:image, title:title)
            element.addTarget(target, action:action, completion:nil)
            return element
        }
        
        open class func back(image: UIImage?, title: String?, completion:((_ owner:NXNaviView.Bar) -> ())?) -> NXNaviView.Bar {
            let element = NXNaviView.Bar.back(image:image, title:title)
            element.addTarget(nil, action:nil, completion:completion)
            return element
        }
        
        open class func forward(image: UIImage?, title: String?) -> NXNaviView.Bar {
            let element = NXNaviView.Bar(frame: CGRect.zero)
            element.contentHorizontalAlignment = .right
            element.updateSubviews(image, title)
            return element
        }
        
        open class func forward(image: UIImage?, title: String?, target:Any?, action:Selector?) -> NXNaviView.Bar {
            let element = NXNaviView.Bar.forward(image:image, title:title)
            element.addTarget(target, action:action, completion:nil)
            return element
        }
        
        open class func forward(image: UIImage?, title: String?, completion:((_ owner:NXNaviView.Bar) -> ())?) -> NXNaviView.Bar {
            let element = NXNaviView.Bar.forward(image:image, title:title)
            element.addTarget(nil, action:nil, completion:completion)
            return element
        }
        
        open func addTarget(_ target: Any?, action: Selector?, completion:((_ owner:NXNaviView.Bar) -> ())?) {
            if let __completion = completion {
                self.setupEvent(UIControl.Event.touchUpInside) { event, value in
                    __completion(self)
                }
            }
            else if let __target = target as? NSObject, let __action = action {
                self.setupEvent(UIControl.Event.touchUpInside) { event, value in
                    if __target.responds(to: __action) {
                        __target.perform(__action)
                    }
                }
            }
            else {
                self.association?.removeTarget(self, UIControl.Event.touchUpInside)
            }
        }
        
        open func updateSubviews(_ image: UIImage?, _ title:String?){
            self.setImage(image, for: .normal)
            self.setTitle(title, for: .normal)
        }
    }
}

