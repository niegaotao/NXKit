//
//  NXSwipeViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/6/13.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXSwipeViewController: NXChildrenViewController, UIScrollViewDelegate {
    open var scrollView = UIScrollView(frame: CGRect.zero)
    open var swipeView = NXSwipeView(frame: CGRect(x: 0, y: 0, width: NXKit.width, height: 44))
    
    open class Attributes: NXSwipeView.Attributes {
        open var viewControllers = [NXViewController]()
        
        override public init(){}
        
        @discardableResult
        public func copy(fromValue: NXSwipeViewController.Attributes) -> NXSwipeViewController.Attributes {
            super.copy(fromValue: fromValue)
            self.viewControllers = fromValue.viewControllers
            return self
        }
    }
    
    public let attributes = NXSwipeViewController.Attributes()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupSubviews()
    }
    
    open override func setupSubviews() {
        //滚动的容器
        self.swipeView.onSelect = {[weak self] (fromIndex, toIndex) in
            self?.didSelectViewController(fromValue: fromIndex, toValue: toIndex)
        }
        
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.backgroundColor = NXKit.viewBackgroundColor
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
    
    //选中
    public func didSelectViewController(fromValue: Int, toValue: Int){
        guard toValue >= 0,
              toValue < self.attributes.viewControllers.count,
            self.attributes.index != toValue else {return}
        
        self.currentViewController = self.viewControllers[toValue]
        self.scrollView.setContentOffset(CGPoint(x: self.view.width * CGFloat(toValue), y: 0), animated: true)
    }
    
    open override func updateSubviews(_ value: Any?) {
        if let attributes = value as? NXSwipeViewController.Attributes {
            self.attributes.copy(fromValue: attributes)
        }
  
        if self.attributes.location == .navigationView {
            swipeView.frame = CGRect(x: 80, y: 0, width: NXKit.width - 80 * 2, height: 44)
            navigationView.centerView = self.swipeView
            navigationView.updateSubviews(nil)
            
            scrollView.frame = CGRect(x: 0, y: 0, width: NXKit.width, height: self.contentView.height)
            scrollView.contentSize = self.contentView.bounds.size
        }
        else if self.attributes.location == .contentView {
            swipeView.frame = CGRect(x: 0, y: 0, width: NXKit.width, height: 44)
            contentView.addSubview(swipeView)
            
            scrollView.frame = CGRect(x: 0, y: 44, width: NXKit.width, height: self.contentView.height-44)
            scrollView.contentSize = self.contentView.bounds.size
        }
        
        //移除历史数据
        self.viewControllers.forEach { (vc) in
            vc.removeFromParent()
            if vc.isViewLoaded {
                vc.view.removeFromSuperview()
            }
        }
        self.viewControllers.removeAll()
        
        //拼接新数据
        self.viewControllers.append(contentsOf: attributes.viewControllers)
        self.scrollView.contentSize = CGSize(width: self.contentView.width * Double(self.viewControllers.count),
                                             height: self.contentView.height)
        for (idx, vc) in self.viewControllers.enumerated() {
            vc.ctxs.superviewController = self
            self.addChild(vc)
            
            if attributes.index == idx {
                self.currentViewController = vc
                vc.view.frame = CGRect(origin: CGPoint(x: self.contentView.width * Double(attributes.index), y: 0), size: self.contentView.frame.size)
                self.scrollView.addSubview(vc.view)
            }
        }
        
        self.swipeView.updateSubviews(self.attributes)
        
        if attributes.index >= 1 {
            self.scrollView.setContentOffset(CGPoint(x: self.view.width * CGFloat(attributes.index), y: 0), animated: false)
        }
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let p = scrollView.contentOffset
        let index = Int((p.x + CGFloat(NXKit.width) * 0.5) / CGFloat(NXKit.width))
        if index < viewControllers.count {
            self.attributes.index = index
            self.swipeView.didSelectView(at: index)
            self.currentViewController = self.viewControllers[index]
            if let vc = self.currentViewController {
                vc.view.frame = CGRect(origin: CGPoint(x: self.contentView.width * Double(index), y: 0), size: self.contentView.frame.size)
                self.scrollView.addSubview(vc.view)
            }
        }
    }
}


