//
//  LEYToolViewController.swift
//  NXFoundation
//
//  Created by firelonely on 2018/7/2.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

open class LEYToolViewController: LEYContainerController {

    open var toolView = LEYToolView(frame: CGRect(x: 0, y: 0, width: LEYDevice.width, height: LEYDevice.toolViewOffset + LEYDevice.bottomOffset))
    open var index : Int = 0
    open var elements = [LEYToolView.Element]()

    
    public convenience init(subviewControllers: [LEYViewController], elements:[LEYToolView.Element], index:Int){
        self.init(nibName: nil, bundle: nil)
        self.subviewControllers.append(contentsOf: subviewControllers)
        for subviewController in subviewControllers {
            subviewController.ctxs.superviewController = self
        }
        self.elements.append(contentsOf: elements)
        self.index = index;
    }
    
    override open func setup() {
        super.setup()
        self.ctxs.statusBarStyle = .none
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.naviView.isHidden = true
        self.contentView.isHidden = true
        
        self.setupSubviews()
    }
    
    override  open func setupSubviews(){
        self.toolView.frame = CGRect(x: 0, y: self.view.h-LEYDevice.toolViewOffset-LEYDevice.bottomOffset, width: self.view.w, height: LEYDevice.toolViewOffset+LEYDevice.bottomOffset)
        self.toolView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        self.toolView.controller = self
        self.toolView.backgroundColor = LEYApp.backgroundColor
        self.toolView.wrapped.didSelectElement = {[weak self] (toolView, index) in
            self?.didSelectElement(at: index)
        }
        self.toolView.wrapped.didReselectElement = {[weak self] (toolView, index) in
            self?.didReselectElement(at: index)
        }
        
        self.index = min(max(0, self.index), subviewControllers.count)
        if self.index >= 0 && self.index < self.subviewControllers.count {
            let toViewController = subviewControllers[self.index]
            self.transition(nil, toViewController, animated: false)
        }
        self.toolView.updateSubviews("elements", ["index":self.index, "elements":self.elements])
        self.view.addSubview(toolView)
    }
    
    open func updateSubviews(_ __subviewControllers: [LEYViewController], elements: [LEYToolView.Element], index: Int){
        self.subviewControllers.forEach { (vc) in
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
        self.subviewControllers.removeAll()
        
        self.subviewControllers.append(contentsOf: __subviewControllers)
        for subviewController in __subviewControllers {
            subviewController.ctxs.superviewController = self
        }
        
        self.index = min(max(0, index), subviewControllers.count)
        self.toolView.updateSubviews("elements", ["index":self.index, "elements":elements])

        if self.index >= 0 && self.index < self.subviewControllers.count {
            let toViewController = subviewControllers[self.index]
            self.transition(nil, toViewController, animated: false)
        }
    }
    
    //选中
    open func didSelectViewController(at idx: Int, animated : Bool){
        let newValue = max(min(idx, self.toolView.wrapped.elements.count), 0)
        guard self.index != newValue else {return}
        
        let element = self.toolView.wrapped.elements[newValue]
        if element.isSelectable {
            let fromViewController = subviewControllers[self.index]
            let toViewController = subviewControllers[newValue]
            self.transition(fromViewController, toViewController, animated: animated)
            self.index = idx
        }
    }
    
    //切换操作
    open func transition(_ fromViewController:LEYViewController?, _ toViewController:LEYViewController, animated:Bool) {
        if animated {
            //后期如有动画的需求再扩展
            toViewController.view.frame = self.view.bounds
            self.selectedViewController = toViewController
            self.addChild(toViewController)
            self.view.insertSubview(toViewController.view, belowSubview: self.toolView)
            
            fromViewController?.removeFromParent()
            fromViewController?.view.removeFromSuperview()
        }
        else {
            toViewController.view.frame = self.view.bounds
            self.selectedViewController = toViewController
            self.addChild(toViewController)
            self.view.insertSubview(toViewController.view, belowSubview: self.toolView)
            
            fromViewController?.removeFromParent()
            fromViewController?.view.removeFromSuperview()
        }
    }
    
    //每次点击
    open func didSelectElement(at index:Int){
        
    }
    
    //连续双击
    open func didReselectElement(at index:Int){
        
    }
}
