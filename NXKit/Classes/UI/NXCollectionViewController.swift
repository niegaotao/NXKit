//
//  NXCollectionViewController.swift
//  NXKit
//
<<<<<<< HEAD
//  Created by niegaotao on 2021/5/23.
//  Copyright © 2018年 无码科技. All rights reserved.
=======
//  Created by niegaotao on 2020/5/23.
//  Copyright © 2020年 TIMESCAPE. All rights reserved.
>>>>>>> 54b3e71c2be9f4a23c8c9b48586689a860947b51
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
        self.collectionView?.backgroundColor = NX.collectionViewBackgroundColor
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.wrapped?.scrollDirection = .vertical
        self.collectionView?.wrapped?.minimumLineSpacing =  0.0
        self.collectionView?.wrapped?.minimumInteritemSpacing = 0.0
        self.collectionView?.wrapped?.sectionInset = UIEdgeInsets.zero
        self.contentView.addSubview(self.collectionView!)
        self.collectionView?.value = self.collectionWrapper
        self.collectionWrapper.wrappedView = self.collectionView
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never
        }
        
        self.contentView.bringSubviewToFront(self.animationView)
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

