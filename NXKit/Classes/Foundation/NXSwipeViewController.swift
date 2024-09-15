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
    open var swipeView = NXSwipeView(frame: CGRect(x: 0, y: NX.topOffset, width: NX.width, height: 44))
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    
        //滚动的容器
        self.swipeView.completion = {[weak self] (swipeView, index, animated) in
            self?.swipeView(swipeView: swipeView, index: index, animated: animated)
        }
        self.view.addSubview(swipeView)
        
        self.contentView.frame = CGRect(x: 0, y: NX.topOffset+44, width: NX.width, height: self.view.height-(NX.topOffset+44))
        
        scrollView.frame = self.contentView.bounds
        scrollView.contentSize = self.contentView.bounds.size
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.backgroundColor = NX.viewBackgroundColor
        scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
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
    
    open func setupSubviews(_ subviewControllers: [NXViewController], titles:[String], index: Int = 0){
        self.setupSubviews(subviewControllers, elements: titles, index: index)
    }
    
    open func setupSubviews(_ subviewControllers: [NXViewController], elements:[Any], index: Int = 0){
        //移除历史数据
        self.subviewControllers.forEach { (vc) in
            vc.removeFromParent()
            if vc.isViewLoaded {
                vc.view.removeFromSuperview()
            }
        }
        self.subviewControllers.removeAll()
        
        //拼接新数据
        self.subviewControllers.append(contentsOf: subviewControllers)
        self.scrollView.contentSize = CGSize(width: self.contentView.width * Double(self.subviewControllers.count),
                                             height: self.contentView.height)
        for (idx, vc) in self.subviewControllers.enumerated() {
            vc.ctxs.isWrapped = true
            vc.ctxs.superviewController = self
            self.addChild(vc)
            
            if index == idx {
                self.selectedViewController = vc
                vc.view.frame = CGRect(origin: CGPoint(x: self.contentView.width * Double(index), y: 0), size: self.contentView.frame.size)
                self.scrollView.addSubview(vc.view)
            }
        }
        
        self.swipeView.updateSubviews("update", ["index":index,"items":elements] as [String : Any])
        
        if index >= 1 {
            self.scrollView.setContentOffset(CGPoint(x: self.view.width * CGFloat(index), y: 0), animated: false)
        }
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let p = scrollView.contentOffset
        let index = Int((p.x + CGFloat(NX.width) * 0.5) / CGFloat(NX.width))
        if index != self.swipeView.ctxs.index && index >= 0 && index < subviewControllers.count {
            self.swipeView.didSelectItem(at: index)
            self.selectedViewController = self.subviewControllers[index]
            if let vc = self.selectedViewController {
                vc.view.frame = CGRect(origin: CGPoint(x: self.contentView.width * Double(index), y: 0), size: self.contentView.frame.size)
                self.scrollView.addSubview(vc.view)
            }
        }
    }
}


