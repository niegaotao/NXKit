//
//  NXCollectionViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/23.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXCollectionViewController: NXViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public var collectionView : NXCollectionView? = nil
    public let data = NXCollection<NXCollectionView>()
    
    override open func setup() {
        super.setup()
        self.ctxs.index = 1 //用以记录分页加载的索引（从1开始）
        self.ctxs.next = 1 //记录下一页的索引
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView = NXCollectionView(frame: self.contentView.bounds)
        self.collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView?.backgroundColor = NXUI.contentViewBackgroundColor
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.alwaysBounceVertical = true
        self.contentView.addSubview(self.collectionView!)
        self.collectionView?.data = self.data
        self.data.wrappedView = self.collectionView
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never
        }
        
        self.contentView.bringSubviewToFront(self.animationView)
    }
    
    ///代理方法数据源方法
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.data.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data[section]?.count ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let rs = self.data.dequeue(collectionView, indexPath, NXItem.View.header.rawValue) {
                rs.reusableView.updateSubviews("update", rs.elelment)
                return rs.reusableView
            }
            //
        }
        else if kind == UICollectionView.elementKindSectionFooter {
            if let rs = self.data.dequeue(collectionView, indexPath, NXItem.View.footer.rawValue) {
                rs.reusableView.updateSubviews("update", rs.elelment)
                return rs.reusableView
            }
        }
        return UICollectionReusableView()
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let rs = self.data.dequeue(collectionView, indexPath) {
            rs.cell.updateSubviews("update", rs.element)
            return rs.cell
        }
        return NXCollectionViewCell()
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return self.data[section]?.insets ?? UIEdgeInsets.zero
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return self.data[section]?.lineSpacing ?? 0.0
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return self.data[section]?.interitemSpacing ?? 0.0
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.data[indexPath]?.ctxs.size ?? CGSize(width: 1, height: 1)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return self.data[section]?.header?.ctxs.size ?? CGSize.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return self.data[section]?.footer?.ctxs.size ?? CGSize.zero
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

