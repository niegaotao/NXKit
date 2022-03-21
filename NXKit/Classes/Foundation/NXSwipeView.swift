//
//  NXSwipeView.swift
//  NXKit
//
//  Created by niegaotao on 2020/6/13.
//  Copyright © 2020年 TIMESCAPE. All rights reserved.
//

import UIKit

open class NXSwipeView: NXBackgroundView<UIImageView, NXCollectionView>, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    open var ctxs = NXSwipeView.Wrapped()
    open var completion : ((_ swipeView: NXSwipeView, _ index: Int, _ animated: Bool) -> ())?
    
    override open func setupSubviews() {
        super.setupSubviews()
        
        self.ctxs.insets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        (contentView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        contentView.frame = self.bounds
        contentView.backgroundColor = NXUI.backgroundColor
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.showsHorizontalScrollIndicator = false
        contentView.showsVerticalScrollIndicator = false
        contentView.delegate = self
        contentView.dataSource = self
        contentView.alwaysBounceVertical = false
        contentView.scrollsToTop = false
        if #available(iOS 11.0, *) {
            contentView.contentInsetAdjustmentBehavior = .never
        }
        self.setupSeparator(color: NXUI.separatorColor, ats: .maxY, insets: UIEdgeInsets.zero)
        self.ctxs.slider.sliderView.layer.masksToBounds = true
        self.contentView.addSubview(self.ctxs.slider.sliderView)
    }
    open override func updateSubviews(_ action: String, _ value: Any?) {
        guard let dicValue = value as? [String:Any] else {
            return
        }
        self.ctxs.index = NX.get(int:dicValue["index"] as? Int, 0)
        
        self.ctxs.removeAll()
        if let elements = dicValue["items"] as? [String] {
            for (_, title) in elements.enumerated() {
                let item = NXSwipeView.Element()
                item.title.selected = title
                item.title.unselected = title
                self.ctxs.items.append(item)
            }
        }
        else if let elements = dicValue["items"] as? [NXSwipeView.Element] {
            self.ctxs.append(contentsOf: elements)
        }
        for (_, item) in self.ctxs.items.enumerated() {
            if item.ctxs.cls == nil || item.ctxs.reuse.count <= 0 {
                item.ctxs.update(NXSwipeView.Cell.self, "NXSwipeViewCell")
            }
            self.contentView.register(item.ctxs.cls, forCellWithReuseIdentifier: item.ctxs.reuse)
            
            item.font.selected = self.ctxs.font.selected
            item.font.unselected = self.ctxs.font.unselected
            
            item.color.selected = self.ctxs.color.selected
            item.color.unselected = self.ctxs.color.unselected
            
            item.width.selected = item.title.selected.stringSize(font: item.font.selected, size: CGSize(width: NXUI.width, height: 44)).width + 2.0
            item.width.unselected = item.title.unselected.stringSize(font: item.font.unselected, size: CGSize(width: NXUI.width, height: 44)).width + 2.0
        }
        
        if self.ctxs.isEqually {
            let maximumOfComponents = max(min(self.ctxs.maximumOfComponents, CGFloat(self.ctxs.items.count)),1.0)
            let widthOfComponents = (self.w - ctxs.insets.left - ctxs.insets.right)/CGFloat(maximumOfComponents)
            for (_, item) in self.ctxs.items.enumerated() {
                item.size.selected = CGSize(width: widthOfComponents, height: self.h)
                item.size.unselected = CGSize(width: widthOfComponents, height: self.h)
            }
        }
        else {
            for (_, item) in self.ctxs.items.enumerated() {
                item.size.selected = CGSize(width: item.width.selected + self.ctxs.spaceOfComponents, height: self.h)
                item.size.unselected = CGSize(width: item.width.unselected + self.ctxs.spaceOfComponents, height: self.h)
            }
        }
        
        self.contentView.reloadData()
        self.resizeSlider(at: self.ctxs.index, animated: false)
        
        //矫正位置
        DispatchQueue.main.asyncAfter(delay:0.01) {
            if self.contentView.contentSize.width > self.contentView.w {
                let indexPath = IndexPath(row: self.ctxs.index, section: 0)
                self.contentView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    //更新title，index为第几个：从0开始
    open func update(title:String, at index: Int) {
        guard let item = self.ctxs[index] else {
            return
        }
        item.title.selected = title
        item.title.unselected = title
        item.width.selected = item.title.selected.stringSize(font: item.font.selected, size: CGSize(width: NXUI.width, height: 44)).width + 2.0
        item.width.unselected = item.title.unselected.stringSize(font: item.font.unselected, size: CGSize(width: NXUI.width, height: 44)).width + 2.0
        
        if self.ctxs.isEqually {
            let maximumOfComponents = max(min(self.ctxs.maximumOfComponents, CGFloat(self.ctxs.count)),1.0)
            let widthOfComponents = (self.w - ctxs.insets.left - ctxs.insets.right)/CGFloat(maximumOfComponents)
            
            item.size.selected = CGSize(width: widthOfComponents, height: self.h)
            item.size.unselected = CGSize(width: widthOfComponents, height: self.h)
        }
        else{
            item.size.selected = CGSize(width: item.width.selected + 16.0, height: self.h)
            item.size.unselected = CGSize(width: item.width.unselected + 16.0, height: self.h)
        }
        
        self.contentView.reloadData()
        self.resizeSlider(at: self.ctxs.index, animated: false)
    }
    
    //在Controller中：手动滚动后 scrollViewDidEndScroll(_) 中调用NXSwipeView.didSelectItem(_)切换滑块
    //在Swipeview中：手动点击后 collectionView(_ didSelectItemAt:)中调用NXSwipeView.didSelectItem(_)切换滑块,并通知Controller
    
    open func didSelectItem(at index: Int){
        self.ctxs.index = index
        
        self.contentView.reloadData()
        self.resizeSlider(at: index, animated: true)

        //矫正位置
        if contentView.contentSize.width > contentView.w {
            let indexPath = IndexPath(row: self.ctxs.index, section: 0)
            self.contentView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    
    open func resizeSlider(at index:Int, animated:Bool){
        self.ctxs.slider.sliderView.isHidden = self.ctxs.slider.isHidden
        self.ctxs.slider.sliderView.layer.cornerRadius = self.ctxs.slider.radius
        self.ctxs.slider.sliderView.backgroundColor = self.ctxs.slider.backgroundColor
        
        var __frame = CGRect.zero
        if let item = self.ctxs[index] {
            /*
             由于两个item的之间文字的间距是16pt,所以在计算item宽度的时候实在文字宽度的基础上加上了16
             所以这里需要将选中item.size.width减去16就是文字的宽度，也是滑块的宽度，origin.x也要减去一半
             */
            if self.ctxs.slider.width > 0 {
                __frame.size.width = self.ctxs.slider.width
            }
            else {
                __frame.size.width = item.width.selected
            }
            __frame.size.width = __frame.size.width - self.ctxs.slider.insets.left - self.ctxs.slider.insets.right
            
            if self.ctxs.slider.height > 0 {
                __frame.size.height = self.ctxs.slider.height
            }
            else {
                __frame.size.height = 3
            }
            __frame.origin.y = self.h - self.ctxs.slider.insets.bottom - __frame.size.height
            
            __frame.origin.x = self.ctxs.insets.left + (item.size.selected.width - __frame.size.width)/2.0
            
            for (__idx, loop) in self.ctxs.items.enumerated() {
                if __idx < index {
                    __frame.origin.x = __frame.origin.x + loop.size.unselected.width
                }
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
                self.ctxs.slider.sliderView.frame = __frame
            }, completion:{ (finish) in
            })
        }
        else{
            self.ctxs.slider.sliderView.frame = __frame
        }
    }
    
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ctxs.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let rs = self.ctxs.dequeue(collectionView, indexPath), let element = rs.element as? NXSwipeView.Element {
            element.isSelected = (self.ctxs.index == indexPath.item)
            rs.cell.updateSubviews("", element)
            return rs.cell
        }
        return NXSwipeView.Cell()
    }
    
    open  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.ctxs.index !=  indexPath.item {
            self.didSelectItem(at: indexPath.item)
            
            if let completion = self.completion {
                completion(self, indexPath.item, false)
            }
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return self.ctxs.insets
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return self.ctxs.lineSpacing
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return self.ctxs.interitemSpacing
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let item = self.ctxs[indexPath.item] {
            if self.ctxs.index == indexPath.item {
                return item.size.selected
            }
            return item.size.unselected
        }
        return CGSize(width: 1.0, height: 1.0)
    }
}


extension NXSwipeView {
    open class Wrapped : NXSection<NXSwipeView.Element> {
        //当前选中的索引
        open var index = 0
        
        //字体
        open var font  = NX.Selectable<UIFont> { (_, __sender) in
            __sender.selected = NXUI.font(15, true)
            __sender.unselected = NXUI.font(15)
        }
        
        //颜色
        open var color = NX.Selectable<UIColor>{ (_, __sender) in
            __sender.selected = NXUI.darkBlackColor
            __sender.unselected = NXUI.darkGrayColor
        }
        
        //是否等分
        open var isEqually : Bool = true
        
        //进行宽度的等分（isEqually == true 生效）
        open var maximumOfComponents : CGFloat = 5.0
        
        //两个元素之间的间距（isEqually == false 生效）
        open var spaceOfComponents : CGFloat = 16.0
        
        //底部滑块
        open var slider = NXSwipeView.Slider()
    }
    
    open class Slider : NSObject {
        open var sliderView = UIView(frame: CGRect.zero)
        open var isHidden : Bool = false
        open var width : CGFloat = 0.0
        open var height : CGFloat = 3.0
        open var insets = UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
        open var backgroundColor = NXUI.mainColor
        open var radius : CGFloat = 0.0
    }
    
    open class Element: NXItem {
        open var isSelected = false
        open var isSelectable = true

        open var title =  NX.Selectable<String>(completion: nil)
        
        open var font  = NX.Selectable<UIFont> { (_, __sender) in
            __sender.selected = NXUI.font(15, true)
            __sender.unselected = NXUI.font(15)
        }
        
        open var color = NX.Selectable<UIColor>{ (_, __sender) in
            __sender.selected = NXUI.darkBlackColor
            __sender.unselected = NXUI.darkGrayColor
        }
        
        open var size = NX.Selectable<CGSize>{ (_, __sender) in
            __sender.selected = CGSize.zero
            __sender.unselected = CGSize.zero
        }
        
        open var width = NX.Selectable<CGFloat> {(_, __sender) in
            __sender.selected = 0.0
            __sender.unselected = 0.0
        }
        
        open var textAlignment = NX.Selectable<NSTextAlignment> {(_, __sender) in
            __sender.selected = NSTextAlignment.center
            __sender.unselected = NSTextAlignment.center
        }
    }
    
    open class Cell : NXCollectionViewCell {
        public let titleView: UILabel = UILabel(frame: CGRect.zero)
        override open func setupSubviews(){
            
            self.backgroundView?.backgroundColor = UIColor.clear
            
            self.titleView.frame = self.bounds
            self.titleView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.titleView.font = NXUI.font(16, true)
            self.titleView.textColor = NXUI.darkBlackColor
            self.titleView.textAlignment = .center
            self.contentView.addSubview(self.titleView)
        }
        
        override open func updateSubviews(_ action:String, _ value:Any?){
            if let element = value as? NXSwipeView.Element {
                if element.isSelected {
                    self.titleView.text = element.title.selected
                    self.titleView.textColor = element.color.selected
                    self.titleView.font = element.font.selected
                    self.titleView.textAlignment = element.textAlignment.selected
                }
                else{
                    self.titleView.text = element.title.unselected
                    self.titleView.textColor = element.color.unselected
                    self.titleView.font = element.font.unselected
                    self.titleView.textAlignment = element.textAlignment.unselected
                }
            }
        }
    }
}

