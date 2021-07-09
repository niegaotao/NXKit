//
//  NXNaviView.swift
//  NXKit
//
//  Created by firelonely on 2018/6/23.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

open class NXNaviView: NXBackgroundView<UIImageView, UIView> {
    open weak var controller : NXViewController?
    
    open var backBar = NXNaviView.Bar.back(image:NXApp.image(named:"navi_back_black.png"), title: nil) //默认
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
    
    open var titleView = UILabel(frame: CGRect(x: 75.0, y: NXDevice.insets.top, width: NXDevice.width-75.0*2, height: NXDevice.topOffset-NXDevice.insets.top))
    open var centerView : UIView? {
        willSet{
            centerView?.removeFromSuperview()
        }
        didSet {
            self.updateSubviews("", nil)
        }
    }
    
    open var forwardBar: NXNaviView.Bar? {
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
        
        self.backgroundColor = UIColor.clear
        
        //这是整个导航栏的背景颜色
        self.backgroundView.frame = self.bounds
        self.backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backgroundView.backgroundColor = UIColor.clear
        self.backgroundView.image = UIImage.image(color: NXApp.backgroundColor)
        
        //整个导航栏的子控件
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.backgroundColor = UIColor.clear
        
        self.titleView.frame = CGRect(x: 75.0, y: NXDevice.insets.top, width: self.contentView.w-75.0*2, height: self.contentView.h-NXDevice.insets.top)
        self.titleView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.titleView.textColor = NXApp.darkBlackColor
        self.titleView.font = NXApp.font(17, true)
        self.titleView.textAlignment = .center
        self.contentView.addSubview(self.titleView)
        
        
        self.backBar.addTarget(nil, action: nil, completion:{[weak self] _ in
            self?.controller?.backBarAction()
        })
        self.backBar.autoresizingMask = [.flexibleHeight]
        self.backBar.frame = CGRect(x: 15, y: NXDevice.insets.top, width: self.backBar.w, height: self.contentView.h-NXDevice.insets.top)
        self.backBar.isHidden = true
        self.contentView.addSubview(self.backBar)
        
        self.separator.frame = CGRect(x: 0, y: self.contentView.h-NXDevice.pixel, width: self.contentView.w, height: NXDevice.pixel)
        self.separator.backgroundColor = NXApp.separatorColor.cgColor
        self.separator.isHidden = true
        self.contentView.layer.addSublayer(self.separator)
    }
    
    open override func updateSubviews(_ action:String, _ value:Any?){
        self.separator.frame = CGRect(x: 0, y: self.contentView.h-NXDevice.pixel, width: self.contentView.w, height: NXDevice.pixel)
        
        if true {
            let size = backBar.frame.size
            backBar.frame = CGRect(x: 15, y: NXDevice.insets.top+(self.contentView.h-NXDevice.insets.top-size.height)/2, width: size.width, height: size.height)
            
            if let controller = self.controller,
                let viewControllers = self.controller?.navigationController?.viewControllers,
                let index = viewControllers.firstIndex(of: controller), index >= 1 {
                self.backBar.isHidden = self.backBarHidden
            }
        }
        
        
        if let backView = self.backView {
            let size = backView.frame.size
            backView.frame = CGRect(x: 15, y: NXDevice.insets.top+(self.contentView.h-NXDevice.insets.top-size.height)/2, width: size.width, height: size.height)
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
            self.titleView.frame = CGRect(x: self.titleView.x, y: NXDevice.insets.top+(self.contentView.h-NXDevice.insets.top-size.height)/2, width: size.width, height: size.height)
        }
        
        
        if let centerView = self.centerView {
            let size = centerView.frame.size
            centerView.frame = CGRect(x: centerView.x, y: NXDevice.insets.top+(self.contentView.h-NXDevice.insets.top-size.height)/2, width: size.width, height: size.height)
            if centerView.superview == nil {
                self.contentView.addSubview(centerView)
            }
            self.titleView.isHidden = true
        }
        
        
        if let forwardView = self.forwardView {
            let size = forwardView.frame.size
            forwardView.frame = CGRect(x: self.contentView.w-15-size.width, y: NXDevice.insets.top+(self.contentView.h-NXDevice.insets.top-size.height)/2, width: size.width, height: size.height)
            if forwardView.superview == nil {
                self.contentView.addSubview(forwardView)
            }
        }
        else if let forwardBar = self.forwardBar {
            let size = forwardBar.frame.size
            forwardBar.frame = CGRect(x: self.contentView.w-15-size.width, y: NXDevice.insets.top+(self.contentView.h-NXDevice.insets.top-size.height)/2, width: size.width, height: size.height)
            if forwardBar.superview == nil {
                self.contentView.addSubview(forwardBar)
            }
        }
    }
}

extension NXNaviView {
    
    open class Wrapped {
        
        public init(){}
        
        ///记录点击事件的变量
        weak var target : NSObject?
        public var selector : Selector?
        ///ui
        public var image: UIImage?
        public var title : String?
        ///返回按钮或者更多按钮
        public fileprivate(set) var action : String = ""
        
        
        ///记录owner
        weak var owner: NXNaviView.Bar?
        ///block
        public var completion : ((_ owner: NXNaviView.Bar) -> ())?
        ///采用block方式添加点击事件
        open func update(_ owner:NXNaviView.Bar, completion:((_ owner: NXNaviView.Bar) -> ())?){
            self.owner = owner
            self.completion = completion
            owner.addTarget(self, action: #selector(callback), for: .touchUpInside)
        }
        
        @objc open func callback(){
            if let __owner = self.owner {
                self.completion?(__owner)
            }
        }
    }
    
    open class Bar: UIButton {
        open var dicValue : [String: Any]?
        public let wrapped = NXNaviView.Wrapped()
        
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
            self.setTitleColor(NXApp.darkBlackColor, for: .normal)
            self.setTitleColor(NXApp.darkGrayColor, for: .highlighted)
            self.titleLabel?.font = NXApp.font(17)
        }
        
        open class  func back(image: UIImage?, title: String?) -> NXNaviView.Bar {
            let element = NXNaviView.Bar(frame: CGRect.zero)
            element.wrapped.action = "lhs"
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
            element.wrapped.action = "rhs"
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
                self.wrapped.update(self, completion: __completion)
            }
            else {
                if self.wrapped.target != nil && self.wrapped.selector != nil {
                    self.removeTarget(self.wrapped.target, action: self.wrapped.selector, for: UIControl.Event.touchUpInside)
                }
                if let __action = action {
                    super.addTarget(target, action: __action, for: UIControl.Event.touchUpInside)
                }
                self.wrapped.target = target as? NSObject
                self.wrapped.selector = action
            }
        }
        
        open func updateSubviews(_ image: UIImage?, _ title:String?){
            if wrapped.action == "lhs" {
                self.wrapped.image = image
                self.wrapped.title = title
                
                self.setImage(image, for: .normal)
                self.setTitle(title, for: .normal)
            }
            else if wrapped.action == "rhs" {
                self.wrapped.image = image
                self.wrapped.title = title
                
                self.setImage(image, for: .normal)
                self.setTitle(title, for: .normal)
            }
        }
    }
}

