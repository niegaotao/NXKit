//
//  NXSwipeViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/6/13.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXSwipeViewController: NXContainerController, UIScrollViewDelegate {
    open var scrollView = UIScrollView(frame: CGRect.zero)
    open var swipeView = NXSwipeView(frame: CGRect(x: 0, y: 0, width: NX.width, height: 44))
    
    open class Attributes {
        open var viewControllers = [NXViewController]()
        open var elements = [Any]() //
        open var index = 0
    }
    
    public let attributes = Attributes()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    
        //滚动的容器
        self.swipeView.completion = {[weak self] (swipeView, index, animated) in
            self?.swipeView(swipeView: swipeView, index: index, animated: animated)
        }
        
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.backgroundColor = NX.viewBackgroundColor
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        self.contentView.addSubview(scrollView)
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    open func swipeView(swipeView:NXSwipeView, index: Int, animated: Bool){
        if index >= 0 && index < subviewControllers.count {
            self.selectedViewController = self.subviewControllers[index]
        }
        self.scrollView.setContentOffset(CGPoint(x: self.view.width * CGFloat(index), y: 0), animated: animated)
    }
    
    open override func updateSubviews(_ value: Any?) {
        if let attributes = value as? NXSwipeViewController.Attributes {
            self.attributes.index = attributes.index
            self.attributes.viewControllers = attributes.viewControllers
            self.attributes.elements = attributes.elements
        }
  
        if self.swipeView.ctxs.displayMode == .navigationView {
            swipeView.frame = CGRect(x: 80, y: 0, width: NX.width - 80 * 2, height: 44)
            navigationView.centerView = self.swipeView
            navigationView.updateSubviews(nil)
            
            scrollView.frame = CGRect(x: 0, y: 0, width: NX.width, height: self.contentView.height)
            scrollView.contentSize = self.contentView.bounds.size
        }
        else if self.swipeView.ctxs.displayMode == .contentView {
            swipeView.frame = CGRect(x: 0, y: 0, width: NX.width, height: 44)
            contentView.addSubview(swipeView)
            
            scrollView.frame = CGRect(x: 0, y: 44, width: NX.width, height: self.contentView.height-44)
            scrollView.contentSize = self.contentView.bounds.size
        }
        
        //移除历史数据
        self.subviewControllers.forEach { (vc) in
            vc.removeFromParent()
            if vc.isViewLoaded {
                vc.view.removeFromSuperview()
            }
        }
        self.subviewControllers.removeAll()
        
        //拼接新数据
        self.subviewControllers.append(contentsOf: attributes.viewControllers)
        self.scrollView.contentSize = CGSize(width: self.contentView.width * Double(self.subviewControllers.count),
                                             height: self.contentView.height)
        for (idx, vc) in self.subviewControllers.enumerated() {
            vc.ctxs.isWrapped = true
            vc.ctxs.superviewController = self
            self.addChild(vc)
            
            if attributes.index == idx {
                self.selectedViewController = vc
                vc.view.frame = CGRect(origin: CGPoint(x: self.contentView.width * Double(attributes.index), y: 0), size: self.contentView.frame.size)
                self.scrollView.addSubview(vc.view)
            }
        }
        
        self.swipeView.updateSubviews(["index":attributes.index,"items":attributes.elements] as [String : Any])
        
        if attributes.index >= 1 {
            self.scrollView.setContentOffset(CGPoint(x: self.view.width * CGFloat(attributes.index), y: 0), animated: false)
        }
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let p = scrollView.contentOffset
        let index = Int((p.x + CGFloat(NX.width) * 0.5) / CGFloat(NX.width))
        if index < subviewControllers.count {
            self.swipeView.onSelectItem(at: index)
            self.selectedViewController = self.subviewControllers[index]
            if let vc = self.selectedViewController {
                vc.view.frame = CGRect(origin: CGPoint(x: self.contentView.width * Double(index), y: 0), size: self.contentView.frame.size)
                self.scrollView.addSubview(vc.view)
            }
        }
    }
}


