//
//  LEYCollectionView.swift
//  NXFoundation
//
//  Created by 聂高涛 on 2018/5/23.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

open class LEYCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    
    open weak var collectionWrapper : LEYCollectionWrapper?
    
    open var wrapped : LEYCollectionWrapper.Wrapped? {
        if let __wrapper = self.collectionViewLayout as? LEYCollectionWrapper.Wrapped {
            return __wrapper
        }
        return nil
    }
    
    open var isMultirecognizersSupported = true; //是否支持多手势识别
    
    public convenience init(frame: CGRect) {
        let __collectionLayout = LEYCollectionWrapper.Wrapped()
        __collectionLayout.minimumLineSpacing = 0.0
        __collectionLayout.minimumInteritemSpacing = 0.0
        __collectionLayout.sectionInset = UIEdgeInsets.zero
        
        self.init(frame: frame, collectionViewLayout: __collectionLayout)
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = LEYApp.collectionViewBackgroundColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = LEYApp.collectionViewBackgroundColor
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
