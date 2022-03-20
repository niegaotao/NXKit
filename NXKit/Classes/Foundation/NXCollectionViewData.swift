//
//  NXCollectionViewData.swift
//  NXKit
//
//  Created by niegaotao on 2020/10/7.
//  Copyright © 2020年 TIMESCAPE. All rights reserved.
//

import UIKit

open class NXCollectionViewData : NXCollection<UICollectionView> {
    public let placeholderView = NXPlaceholderView()
    public func addPlaceholderView(_ frame: CGRect){
        let e = NXPlaceholderElement()
        e.placeholderView = self.placeholderView
        e.ctxs.update(NXCollectionPlaceholderViewCell.self, "NXPlaceholderViewCell")
        e.ctxs.frame = frame
        self.addElementToLastSection(e)
        
        self.wrappedView?.register(NXCollectionPlaceholderViewCell.self, forCellWithReuseIdentifier: "NXPlaceholderViewCell")
    }
}


