//
//  NXNavigationView.swift
//  NXKit
//
//  Created by niegaotao on 2020/6/23.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXNavigationView: NXBackgroundView<UIImageView, UIView> {
    open weak var controller : UIViewController?
    
    open var backBarButton = NXNavigationView.Bar.back(image: NXKit.image(named:"navi-back.png", mode: .alwaysTemplate), title: nil) //默认
    open var leftView : UIView? {
        willSet{
            leftView?.removeFromSuperview()
        }
        didSet {
            self.updateSubviews(nil)
        }
    }
    
    open var title : String = "" {
        didSet {
            self.updateSubviews(nil)
        }
    }
    
    open var titleView = UILabel(frame: CGRect(x: 75.0, y: NXKit.safeAreaInsets.top, width: NXKit.width-75.0*2, height: 44.0))
    open var centerView : UIView? {
        willSet{
            centerView?.removeFromSuperview()
        }
        didSet {
            self.updateSubviews(nil)
        }
    }
    
    open var rightView : UIView? {
        willSet{
            rightView?.removeFromSuperview()
        }
        didSet {
            self.updateSubviews(nil)
        }
    }
    
    open var isBackBarButtonHidden = false
    
    open var separator = CALayer()
    
    override open func setupSubviews(){
        super.setupSubviews()
                
        //这是整个导航栏的背景颜色
        self.backgroundView.frame = self.bounds
        self.backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backgroundView.tintColor = NXKit.barBackgroundColor;
        self.backgroundView.image = UIImage.image(color: NXKit.barBackgroundColor)?.withRenderingMode(.alwaysTemplate)

        //整个导航栏的子控件
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.backgroundColor = UIColor.clear
        
        self.titleView.frame = CGRect(x: 75.0, y: NXKit.safeAreaInsets.top, width: self.contentView.width-75.0*2, height: self.contentView.height-NXKit.safeAreaInsets.top)
        self.titleView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.titleView.textColor = NXKit.barForegroundColor
        self.titleView.tintColor = NXKit.barForegroundColor
        self.titleView.font = NXKit.font(17, .bold)
        self.titleView.textAlignment = .center
        self.contentView.addSubview(self.titleView)
        
        self.backBarButton.addTarget(nil, action: nil, completion:{[weak self] _ in
            if let viewController = self?.controller as? NXViewController {
                viewController.onBackPressed()
            }
            else if let navigationController = self?.controller?.navigationController {
                navigationController.popViewController(animated: true)
            }
        })
        self.backBarButton.autoresizingMask = [.flexibleHeight]
        self.backBarButton.frame = CGRect(x: 15, y: NXKit.safeAreaInsets.top, width: self.backBarButton.width, height: self.contentView.height-NXKit.safeAreaInsets.top)
        self.backBarButton.isHidden = true
        self.contentView.addSubview(self.backBarButton)
        
        self.separator.frame = CGRect(x: 0, y: self.contentView.height-NXKit.pixel, width: self.contentView.width, height: NXKit.pixel)
        self.separator.backgroundColor = NXKit.separatorColor.cgColor
        self.separator.isHidden = true
        self.contentView.layer.addSublayer(self.separator)
    }
    
    open override func updateSubviews(_ value: Any?){
        self.separator.frame = CGRect(x: 0, y: self.contentView.height-NXKit.pixel, width: self.contentView.width, height: NXKit.pixel)
        
        if true {
            let size = backBarButton.frame.size
            backBarButton.frame = CGRect(x: 15, y: NXKit.safeAreaInsets.top+(self.contentView.height-NXKit.safeAreaInsets.top-size.height)/2, width: size.width, height: size.height)
            
            if let controller = self.controller,
                let viewControllers = self.controller?.navigationController?.viewControllers,
                let index = viewControllers.firstIndex(of: controller), index >= 1 {
                self.backBarButton.isHidden = self.isBackBarButtonHidden
            }
        }
        
        
        if let leftView = self.leftView {
            let size = leftView.frame.size
            leftView.frame = CGRect(x: 15, y: NXKit.safeAreaInsets.top+(self.contentView.height-NXKit.safeAreaInsets.top-size.height)/2, width: size.width, height: size.height)
            if leftView.superview == nil {
                self.contentView.addSubview(leftView)
            }
            self.backBarButton.isHidden = true
        }
        
        if true {
            if self.title.count > 0 {
                self.titleView.text = self.title
            }
            else if let title = self.controller?.title, title.count > 0 {
                self.titleView.text = title
            }
            let size = self.titleView.frame.size
            self.titleView.frame = CGRect(x: self.titleView.x, y: NXKit.safeAreaInsets.top+(self.contentView.height-NXKit.safeAreaInsets.top-size.height)/2, width: size.width, height: size.height)
        }
        
        
        if let centerView = self.centerView {
            let size = centerView.frame.size
            centerView.frame = CGRect(x: centerView.x, y: NXKit.safeAreaInsets.top+(self.contentView.height-NXKit.safeAreaInsets.top-size.height)/2, width: size.width, height: size.height)
            if centerView.superview == nil {
                self.contentView.addSubview(centerView)
            }
            self.titleView.isHidden = true
        }
        
        
        if let rightView = self.rightView {
            let size = rightView.frame.size
            rightView.frame = CGRect(x: self.contentView.width-15-size.width, y: NXKit.safeAreaInsets.top+(self.contentView.height-NXKit.safeAreaInsets.top-size.height)/2, width: size.width, height: size.height)
            if rightView.superview == nil {
                self.contentView.addSubview(rightView)
            }
        }
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.separator.backgroundColor = NXKit.separatorColor.cgColor
    }
}

extension NXNavigationView {
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
            self.setTitleColor(NXKit.barForegroundColor, for: .normal)
            self.setTitleColor(NXKit.lightGrayColor, for: .highlighted)
            self.tintColor = NXKit.barForegroundColor;
            self.titleLabel?.font = NXKit.font(17)
        }
        
        open class  func back(image: UIImage?, title: String?) -> NXNavigationView.Bar {
            let element = NXNavigationView.Bar(frame: CGRect.zero)
            element.contentHorizontalAlignment = .left
            element.updateSubviews(image, title)
            return element
        }
        
        open class  func back(image: UIImage?, title: String?, target: Any?, action: Selector?) -> NXNavigationView.Bar {
            let element = NXNavigationView.Bar.back(image:image, title:title)
            element.addTarget(target, action:action, completion:nil)
            return element
        }
        
        open class func back(image: UIImage?, title: String?, completion:((_ owner: NXNavigationView.Bar) -> ())?) -> NXNavigationView.Bar {
            let element = NXNavigationView.Bar.back(image:image, title:title)
            element.addTarget(nil, action:nil, completion:completion)
            return element
        }
        
        open class func forward(image: UIImage?, title: String?) -> NXNavigationView.Bar {
            let element = NXNavigationView.Bar(frame: CGRect.zero)
            element.contentHorizontalAlignment = .right
            element.updateSubviews(image, title)
            return element
        }
        
        open class func forward(image: UIImage?, title: String?, target: Any?, action: Selector?) -> NXNavigationView.Bar {
            let element = NXNavigationView.Bar.forward(image:image, title:title)
            element.addTarget(target, action:action, completion:nil)
            return element
        }
        
        open class func forward(image: UIImage?, title: String?, completion:((_ owner: NXNavigationView.Bar) -> ())?) -> NXNavigationView.Bar {
            let element = NXNavigationView.Bar.forward(image:image, title:title)
            element.addTarget(nil, action:nil, completion:completion)
            return element
        }
        
        open func addTarget(_ target: Any?, action: Selector?, completion:((_ owner: NXNavigationView.Bar) -> ())?) {
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
                self.association?.removeTarget(self, event: UIControl.Event.touchUpInside)
            }
        }
        
        open func updateSubviews(_ image: UIImage?, _ title: String?){
            self.setImage(image, for: .normal)
            self.setTitle(title, for: .normal)
        }
    }
}

