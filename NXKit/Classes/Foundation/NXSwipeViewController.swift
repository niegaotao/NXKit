//
//  NXSwipeViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/6/13.
//  Copyright © 2020年 TIMESCAPE. All rights reserved.
//

import UIKit

open class NXSwipeViewController: NXContainerController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    open var wrapped = NXSection<NXItem>()
    open var collectionView : NXCollectionView? = nil
    open var swipeView = NXSwipeView(frame: CGRect(x: 0, y: NXUI.topOffset, width: NXUI.width, height: 44))
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    
        //滚动的容器
        self.swipeView.completion = {[weak self] (swipeView, index, animated) in
            self?.swipeView(swipeView: swipeView, index: index, animated: animated)
        }
        self.view.addSubview(swipeView)
        
        self.contentView.frame = CGRect(x: 0, y: NXUI.topOffset+44, width: NXUI.width, height: self.view.h-(NXUI.topOffset+44))
        
        collectionView = NXCollectionView(frame: self.contentView.bounds)
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets.zero
            layout.minimumLineSpacing = 0.0
            layout.minimumInteritemSpacing = 0.0
        }
        collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView?.backgroundColor = NX.collectionViewBackgroundColor
        collectionView?.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.bounces = false
        collectionView?.alwaysBounceVertical = false
        collectionView?.alwaysBounceHorizontal = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never
        }
        self.contentView.addSubview(collectionView!)
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.subviewControllers.count > 0 {
            self.collectionView?.reloadData()
        }
    }
    
    open func swipeView(swipeView:NXSwipeView, index: Int, animated: Bool){
        if index >= 0 && index < subviewControllers.count {
            self.selectedViewController = self.subviewControllers[index]
        }
        self.collectionView?.setContentOffset(CGPoint(x: self.view.w * CGFloat(index), y: 0), animated: animated)
    }
    
    open func setupSubviews(_ subviewControllers: [NXViewController], titles:[String], index: Int = 0){
        self.setupSubviews(subviewControllers, elements: titles, index: index)
    }
    
    open func setupSubviews(_ subviewControllers: [NXViewController], elements:[Any], index: Int = 0){
        //移除历史数据
        self.subviewControllers.forEach { (vc) in
            vc.removeFromParent()
            vc.view.removeFromSuperview()
        }
        self.subviewControllers.removeAll()
        self.wrapped.removeAll()
        
        //拼接新数据
        self.subviewControllers.append(contentsOf: subviewControllers)
        for (idx, vc) in self.subviewControllers.enumerated() {
            NX.log { return "vc:\(vc)"}
            vc.ctxs.isWrapped = true
            vc.ctxs.superviewController = self
            
            let element = NXSwipeViewController.Element()
            element.ctxs.size = CGSize(width: NXUI.width, height: NXUI.height-NXUI.topOffset)
            element.ctxs.update(NXSwipeViewController.Cell.self, "NXSwipeViewControllerCell" + String(idx+1))
            element.owner = vc
            self.wrapped.items.append(element)
            
            if index == idx {
                self.selectedViewController = vc
            }
        
            self.collectionView?.register(element.ctxs.cls, forCellWithReuseIdentifier: element.ctxs.reuse)
            self.addChild(vc)
        }
        
        self.swipeView.updateSubviews("update", ["index":index,"items":elements])
        
        if index >= 1 {
            self.collectionView?.setContentOffset(CGPoint(x: self.view.w * CGFloat(index), y: 0), animated: false)
        }
        
        self.collectionView?.reloadData()
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let rs = self.wrapped.dequeue(collectionView, indexPath) {
            if let cell = rs.cell as? NXSwipeViewController.Cell, let element = rs.element as? NXSwipeViewController.Element {
                if let __owner = element.owner {
                    __owner.view.frame = cell.contentView.bounds
                    cell.contentView.addSubview(__owner.view)
                }
                NX.log { return "index=\(indexPath),self.view=\(self.view.frame), \ncontent=\(self.contentView.frame),\ncollection=\(self.collectionView?.frame ?? CGRect.zero), \ncell=\(cell.frame), \ncell.content=\(cell.contentView.frame)"}
            }
            else {
                rs.cell.updateSubviews("update", rs.element)
            }
            return rs.cell
        }
        return NXSwipeViewController.Cell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let rs = self.wrapped.dequeue(collectionView, indexPath) {
            if let element = rs.element as? NXSwipeViewController.Element, let __owner = element.owner {
                cell.contentView.addSubview(__owner.view)
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let rs = self.wrapped.dequeue(collectionView, indexPath) {
            if let element = rs.element as? NXSwipeViewController.Element, let __owner = element.owner {
                __owner.view.removeFromSuperview()
            }
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionView?.bounds.size ?? CGSize(width: 1, height: 1)
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let p = scrollView.contentOffset
        let index = Int((p.x + CGFloat(NXUI.width) * 0.5) / CGFloat(NXUI.width))
        if index != self.swipeView.ctxs.index && index >= 0 && index < subviewControllers.count {
            self.swipeView.didSelectItem(at: index)
            self.selectedViewController = self.subviewControllers[index]
        }
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.wrapped.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return self.wrapped.insets
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return self.wrapped.lineSpacing
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return self.wrapped.interitemSpacing
    }
}

extension NXSwipeViewController {
    
    open class Element : NXItem {
        open var owner : NXViewController?
    }
    
    open class Cell: NXCollectionViewCell {
        override open func setupSubviews() {
            self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
}


