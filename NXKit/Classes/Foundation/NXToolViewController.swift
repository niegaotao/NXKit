//
//  NXToolViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/7/2.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXToolViewController: NXChildrenViewController {

    public let toolView = NXToolView(frame: CGRect(x: 0, y: 0, width: NXKit.width, height: NXKit.toolViewOffset + NXKit.bottomOffset))
    
    open class Attributes: NXToolView.Attributes {
        open var viewControllers = [UIViewController]()
        
        public override init(){}
        
        @discardableResult
        public func copy(fromValue: NXToolViewController.Attributes) -> NXToolViewController.Attributes {
            super.copy(fromValue: fromValue)
            self.viewControllers = fromValue.viewControllers
            return self
        }
    }
    
    public let attributes = NXToolViewController.Attributes()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationView.isHidden = true
        self.contentView.isHidden = true
        
        self.setupSubviews()
    }
    
    override open func setupSubviews(){
        self.toolView.frame = CGRect(x: 0, y: self.view.height-NXKit.toolViewOffset-NXKit.bottomOffset, width: self.view.width, height: NXKit.toolViewOffset+NXKit.bottomOffset)
        self.toolView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        self.toolView.onSelect = {[weak self] (fromValue, toValue) in
            self?.didSelectViewController(fromValue: fromValue, toValue: toValue)
        }
        self.view.addSubview(toolView)
    }
    
    open override func updateSubviews(_ value: Any?) {
        if let attributes = value as? NXToolViewController.Attributes {
            self.attributes.copy(fromValue: attributes)
            self.attributes.index = min(max(0, attributes.index), viewControllers.count)
        }
        
        self.viewControllers.forEach { (vc) in
            vc.removeFromParent()
            if vc.isViewLoaded {
                vc.view.removeFromSuperview()
            }
        }
        self.viewControllers.removeAll()
        self.viewControllers.append(contentsOf: self.attributes.viewControllers)
        for subviewController in self.viewControllers {
            if let subviewController = subviewController as? NXViewController {
                subviewController.ctxs.superviewController = self
            }
            self.addChild(subviewController)
        }
        
        self.toolView.updateSubviews(self.attributes)

        if self.attributes.index >= 0 && self.attributes.index < self.viewControllers.count {
            let toViewController = viewControllers[self.attributes.index]
            self.fromViewController(nil, toViewController:toViewController, animated: false)
        }
    }
    
    //选中
    open func didSelectViewController(fromValue: Int, toValue: Int){
        guard toValue >= 0,
              toValue < self.attributes.viewControllers.count,
            self.attributes.index != toValue else {return}
        
        self.toolView.didSelectView(at: toValue)
        let fromViewController = viewControllers[self.attributes.index]
        let toViewController = viewControllers[toValue]
        self.fromViewController(fromViewController, toViewController:toViewController, animated: true)
        self.attributes.index = toValue
    }
    
    //切换操作
    open func fromViewController(_ fromViewController: UIViewController?, toViewController: UIViewController?, animated: Bool) {
        if let toViewController = toViewController {
            toViewController.view.frame = self.view.bounds
            toViewController.beginAppearanceTransition(true, animated: true)
        }
        
        if let fromViewController = fromViewController {
            fromViewController.beginAppearanceTransition(false, animated: true)
            fromViewController.view.removeFromSuperview()
            fromViewController.endAppearanceTransition()
        }
        
        if let toViewController = toViewController {
            toViewController.view.frame = self.view.bounds
            self.currentViewController = toViewController
            self.view.insertSubview(toViewController.view, belowSubview: self.toolView)
            toViewController.endAppearanceTransition()
        }
        
        updateNavigationAppearance()
    }
}
