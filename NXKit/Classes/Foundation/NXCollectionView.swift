//
//  NXCollectionView.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/23.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    open weak var data : NXCollection<NXCollectionView>?
    
    //方案1.UICollectionViewFlowLayout中设置对应的sectionInset.top的值
    //方案2.NXCollectionViewLayouter中可以实现对改view的布局
    open var headerView : UIView? {
        willSet {
            headerView?.removeFromSuperview()
        }
        didSet {
            if let __headerView = self.headerView {
                self.addSubview(__headerView)
            }
            self.reloadData()
        }
    }
    
    open var footerView : UIView? {
        willSet {
            footerView?.removeFromSuperview()
        }
        didSet {
            if let __footerView = self.footerView {
                self.addSubview(__footerView)
            }
            self.reloadData()
        }
    }
    
    open var isMultirecognizersSupported = true; //是否支持多手势识别
    
    public convenience init(frame: CGRect) {
        let __collectionLayout = UICollectionViewFlowLayout.init()
        self.init(frame: frame, collectionViewLayout: __collectionLayout)
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = NXKit.viewBackgroundColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = NXKit.viewBackgroundColor
    }
    
    override open var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if isMultirecognizersSupported {
            if let panRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
                return self.enableBackRecognizer(panRecognizer)
            }
            return false
        }
        return false
    }
    
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if isMultirecognizersSupported {
            if let panRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
                return !self.enableBackRecognizer(panRecognizer)
            }
            return true
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
    
    private func enableBackRecognizer(_ panRecognizer:UIPanGestureRecognizer) -> Bool {
        if panRecognizer == self.panGestureRecognizer {
            let state = panRecognizer.state
            let p = panRecognizer.translation(in: self)
            if (state == .began || state == .possible) && self.contentOffset.x <= 0.0 && p.x > 0 {
                return true
            }
        }
        return false
    }
}
