//
//  NXCollectionView.swift
//  NXKit
//
//  Created by 聂高涛 on 2020/5/23.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

open class NXCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    
    open weak var collectionWrapper : NXCollectionWrapper?
    
    open var wrapped : NXCollectionWrapper.Wrapped? {
        if let __wrapper = self.collectionViewLayout as? NXCollectionWrapper.Wrapped {
            return __wrapper
        }
        return nil
    }
    
    open var isMultirecognizersSupported = true; //是否支持多手势识别
    
    public convenience init(frame: CGRect) {
        let __collectionLayout = NXCollectionWrapper.Wrapped()
        __collectionLayout.minimumLineSpacing = 0.0
        __collectionLayout.minimumInteritemSpacing = 0.0
        __collectionLayout.sectionInset = UIEdgeInsets.zero
        
        self.init(frame: frame, collectionViewLayout: __collectionLayout)
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = NX.collectionViewBackgroundColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = NX.collectionViewBackgroundColor
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
