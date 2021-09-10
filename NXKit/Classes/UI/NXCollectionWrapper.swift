//
//  NXCollectionWrapper.swift
//  NXKit
//
//  Created by niegaotao on 2020/10/7.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

open class NXCollectionWrapper : NXCollection<NXCollectionView> {
    public let placeholderView = NXPlaceholderView()
    public func addPlaceholderView(_ frame: CGRect){
        let e = NXPlaceholderView.Element()
        e.placeholderView = self.placeholderView
        e.ctxs.update(NXPlaceholderView.CollectionViewCell.self, "NXPlaceholderViewCell")
        e.ctxs.frame = frame
        self.addElementToLastSection(e)
        
        self.wrappedView?.register(NXPlaceholderView.CollectionViewCell.self, forCellWithReuseIdentifier: "NXPlaceholderViewCell")
    }
}

extension NXCollectionWrapper {
    open class Wrapped: UICollectionViewFlowLayout {
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
