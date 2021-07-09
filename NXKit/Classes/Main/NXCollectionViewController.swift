//
//  NXCollectionViewController.swift
//  NXKit
//
//  Created by firelonely on 2018/5/23.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

open class NXCollectionViewController: NXViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public var collectionView : NXCollectionView? = nil
    public let collectionWrapper = NXCollectionWrapper()
    
    override open func setup() {
        super.setup()
        self.ctxs.index = 1 //用以记录分页加载的索引（从1开始）
        self.ctxs.next = 1 //记录下一页的索引
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView = NXCollectionView(frame: self.contentView.bounds)
        self.collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView?.backgroundColor = NXApp.collectionViewBackgroundColor
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.wrapped?.scrollDirection = .vertical
        self.collectionView?.wrapped?.minimumLineSpacing =  0.0
        self.collectionView?.wrapped?.minimumInteritemSpacing = 0.0
        self.collectionView?.wrapped?.sectionInset = UIEdgeInsets.zero
        self.contentView.addSubview(self.collectionView!)
        self.collectionView?.collectionWrapper = self.collectionWrapper
        self.collectionWrapper.collectionView = self.collectionView
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never
        }
        
        if let __animationsView = self.animationView {
            self.contentView.bringSubviewToFront(__animationsView)
        }
    }
    
    ///代理方法数据源方法
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.collectionWrapper.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionWrapper[section]?.count ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let rs = self.collectionWrapper.dequeue(collectionView, indexPath) {
            rs.cell.updateSubviews("update", rs.element)
            return rs.cell
        }
        return NXCollectionViewCell()
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return self.collectionWrapper[section]?.insets ?? UIEdgeInsets.zero
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return self.collectionWrapper[section]?.lineSpacing ?? 0.0
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return self.collectionWrapper[section]?.interitemSpacing ?? 0.0
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionWrapper[indexPath]?.ctxs.size ?? CGSize(width: 1, height: 1)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

