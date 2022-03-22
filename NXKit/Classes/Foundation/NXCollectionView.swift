//
//  NXCollectionView.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/23.
//  Copyright © 2020年 TIMESCAPE. All rights reserved.
//

import UIKit

open class NXCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    open weak var data : NXCollection<NXCollectionView>?
    
    open var isMultirecognizersSupported = true; //是否支持多手势识别
    
    public convenience init(frame: CGRect) {
        let __collectionLayout = UICollectionViewFlowLayout.init()
        self.init(frame: frame, collectionViewLayout: __collectionLayout)
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = NXUI.collectionViewBackgroundColor
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = NXUI.collectionViewBackgroundColor
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
