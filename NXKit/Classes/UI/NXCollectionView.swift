//
//  NXCollectionView.swift
//  NXKit
//
//  Created by 聂高涛 on 2020/5/23.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

open class NXCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    open weak var value : NXCollectionWrapper?
    
    open var wrapped : NXCollectionView.Wrapped? {
        if let __wrapper = self.collectionViewLayout as? NXCollectionView.Wrapped {
            return __wrapper
        }
        return nil
    }
    
    open var isMultirecognizersSupported = true; //是否支持多手势识别
    
    public convenience init(frame: CGRect) {
        let __collectionLayout = NXCollectionView.Wrapped()
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


extension NXCollectionView {
    open class Wrapped: UICollectionViewFlowLayout {
        
        public override init() {
            super.init()
            
            // 解决collectionview2行的时候,只有一个item的时候,默认居中,而不是居左显示的问题
//                    SEL sel = NSSelectorFromString(@"_setRowAlignmentsOptions:");
//                    if ([self respondsToSelector:sel]) {
//                        ((void (*)(id, SEL, NSDictionary *))objc_msgSend)(self, sel,
//                                                                          @{ @"UIFlowLayoutCommonRowHorizontalAlignmentKey" : @(NSTextAlignmentLeft),
//                                                                             @"UIFlowLayoutLastRowHorizontalAlignmentKey" : @(NSTextAlignmentLeft),
//                                                                             @"UIFlowLayoutRowVerticalAlignmentKey" : @(NSTextAlignmentCenter) });
//                    }
        }
        
        required public init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        
        open var completion : ((_ attributes:[UICollectionViewLayoutAttributes]) -> ([UICollectionViewLayoutAttributes]))?
        open var elements = [UICollectionViewLayoutAttributes]()
        open var size = CGSize.zero
        
        open func update(_ elements:[UICollectionViewLayoutAttributes], size:CGSize){
            self.elements = elements
            self.size = size
        }
        
        override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            if elements.count > 0 {
                return elements
            }
            else if let es = super.layoutAttributesForElements(in: rect) {
                if self.completion != nil {
                    return self.completion?(es)
                }
                return es
            }
            return nil
        }
        
        override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            if elements.count > 0 {
                if elements.count < indexPath.section {
                    return elements[indexPath.item]
                }
                return nil
            }
            return super.layoutAttributesForItem(at: indexPath)
        }
        
        override open var collectionViewContentSize: CGSize {
            if !size.equalTo(CGSize.zero) {
                return size
            }
            return super.collectionViewContentSize
        }
    }

}

