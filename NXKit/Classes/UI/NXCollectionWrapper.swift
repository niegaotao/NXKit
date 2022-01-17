//
//  NXCollectionWrapper.swift
//  NXKit
//
<<<<<<< HEAD
//  Created by niegaotao on 2021/10/7.
//  Copyright © 2018年 无码科技. All rights reserved.
=======
//  Created by niegaotao on 2020/10/7.
//  Copyright © 2020年 TIMESCAPE. All rights reserved.
>>>>>>> 54b3e71c2be9f4a23c8c9b48586689a860947b51
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
