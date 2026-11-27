//
//  NXToolViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/7/2.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXToolViewController: NXContainerController {

    public let toolView = NXToolView(frame: CGRect(x: 0, y: 0, width: NX.width, height: NX.toolViewOffset + NX.bottomOffset))
    open var index : Int = 0

    public convenience init(subviewControllers: [NXViewController], elements:[NXToolView.Element], index:Int){
        self.init(nibName: nil, bundle: nil)
        self.subviewControllers.append(contentsOf: subviewControllers)
        self.toolView.elements.append(contentsOf: elements)
        self.index = index;
    }
    
    override open func initialize() {
        super.initialize()
        self.ctxs.statusBarStyle = .none
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationView.isHidden = true
        self.contentView.isHidden = true
        
        self.setupSubviews()
    }
    
    override open func setupSubviews(){
        for subviewController in subviewControllers {
            subviewController.ctxs.superviewController = self
            self.addChild(subviewController)
        }
        
        self.toolView.frame = CGRect(x: 0, y: self.view.height-NX.toolViewOffset-NX.bottomOffset, width: self.view.width, height: NX.toolViewOffset+NX.bottomOffset)
        self.toolView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        self.toolView.controller = self
        self.toolView.backgroundColor = NX.barBackgroundColor
        self.toolView.didSelect = {[weak self] (fromValue, toValue) in
            self?.didSelect(fromValue: fromValue, toValue: toValue)
        }
        
        self.index = min(max(0, self.index), subviewControllers.count)
        if self.index >= 0 && self.index < self.subviewControllers.count {
            let toViewController = subviewControllers[self.index]
            self.fromViewController(nil, toViewController:toViewController, animated: false)
        }
        self.toolView.updateSubviews(["index":self.index])
        self.view.addSubview(toolView)
    }
    
    open func updateSubviews(_ __subviewControllers: [NXViewController], elements: [NXToolView.Element], index: Int){
        self.subviewControllers.forEach { (vc) in
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
        self.subviewControllers.removeAll()
        
        self.subviewControllers.append(contentsOf: __subviewControllers)
        for subviewController in __subviewControllers {
            subviewController.ctxs.superviewController = self
            self.addChild(subviewController)
        }
        
        self.index = min(max(0, index), subviewControllers.count)
        self.toolView.updateSubviews(["index":self.index, "elements":elements] as [String : Any])

        if self.index >= 0 && self.index < self.subviewControllers.count {
            let toViewController = subviewControllers[self.index]
            self.fromViewController(nil, toViewController:toViewController, animated: false)
        }
    }
    
    //选中
    public func didSelectViewController(fromValue:Int, toValue: Int, animated : Bool){
        let newValue = max(min(toValue, self.toolView.elements.count), 0)
        guard self.index != newValue else {return}
        
        self.toolView.fromView(fromValue: newValue, toValue: toValue, animated: animated)
        let fromViewController = subviewControllers[self.index]
        let toViewController = subviewControllers[newValue]
        self.fromViewController(fromViewController, toViewController:toViewController, animated: animated)
        self.index = newValue
    }
    
    //切换操作
    open func fromViewController(_ fromViewController:NXViewController?, toViewController:NXViewController?, animated:Bool) {
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
            self.selectedViewController = toViewController
            self.view.insertSubview(toViewController.view, belowSubview: self.toolView)
            toViewController.endAppearanceTransition()
        }
    }
    
    //每次点击
    open func didSelect(fromValue:Int, toValue:Int){
        
    }
}
