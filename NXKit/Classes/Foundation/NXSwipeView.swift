//
//  NXSwipeView.swift
//  NXKit
//
//  Created by niegaotao on 2020/6/13.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXSwipeView: NXBackgroundView<UIImageView, NXCollectionView>, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    open class Attributes {
        open var elements = [NXSwipeView.Element]()
        open var index = 0
        open var insets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        open var selected = AppearanceAttributes() // 选中的效果
        open var unselected = AppearanceAttributes(font: NX.font(15), color: NX.lightGrayColor) //不选中的效果
        open var isEqually : Bool = true //是否等分
        open var maximumOfComponents : CGFloat = 5.0 //进行宽度的等分（isEqually == true 生效）
        open var spaceOfComponents : CGFloat = 16.0 //两个元素之间的间距（isEqually == false 生效）
        open var slider = NXSwipeView.Slider() //底部滑块
        
        public init() {}
        
        @discardableResult
        func copy(fromValue: NXSwipeView.Attributes) -> NXSwipeView.Attributes {
            self.elements = fromValue.elements
            self.index = fromValue.index
            self.insets = fromValue.insets
            self.selected = fromValue.selected
            self.unselected = fromValue.unselected
            self.isEqually = fromValue.isEqually
            self.maximumOfComponents = fromValue.maximumOfComponents
            self.spaceOfComponents = fromValue.spaceOfComponents
            self.slider = fromValue.slider
            return self
        }
    }
    
    open class AppearanceAttributes {
        open var font = NX.font(15, .bold)
        open var color = NX.blackColor
        open var textAlignment = NSTextAlignment.center
        
        init(font: UIFont = NX.font(15, .bold), color: UIColor = NX.blackColor, textAlignment: NSTextAlignment = .center) {
            self.font = font
            self.color = color
            self.textAlignment = textAlignment
        }
    }
    
    open var attributes = NXSwipeView.Attributes()
    open var sliderView = UIView(frame: CGRect.zero)
    open var onSelect : NX.Event<Int, Int>? = nil //每次点击都会调用
    
    override open func setupSubviews() {
        super.setupSubviews()
                
        (contentView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        contentView.frame = self.bounds
        contentView.backgroundColor = NX.barBackgroundColor
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
        self.setupSeparator(color: NX.separatorColor, ats: .maxY, insets: UIEdgeInsets.zero)
        self.sliderView.layer.masksToBounds = true
        self.contentView.addSubview(self.sliderView)
    }
    
    open override func updateSubviews(_ value: Any?) {
        if let attributes = value as? NXSwipeView.Attributes {
            self.attributes.copy(fromValue: attributes)
            self.attributes.index = min(max(0, self.attributes.index), self.attributes.elements.count)
        }
        
        for (_, item) in self.attributes.elements.enumerated() {
            if item.ctxs.cls == nil || item.ctxs.reuse.count <= 0 {
                item.ctxs.update(NXSwipeView.Cell.self, "NXSwipeViewCell")
            }
            self.contentView.register(item.ctxs.cls, forCellWithReuseIdentifier: item.ctxs.reuse)
            
            item.selected.attributes = self.attributes.selected
            item.unselected.attributes = self.attributes.unselected
            
            item.selected.width = item.title.stringSize(font: self.attributes.selected.font,
                                                        size: CGSize(width: NX.width, height: 44)).width + 2.0
            item.unselected.width = item.title.stringSize(font: self.attributes.unselected.font,
                                                          size: CGSize(width: NX.width, height: 44)).width + 2.0
        }
        
        if self.attributes.isEqually {
            let maximumOfComponents = max(min(self.attributes.maximumOfComponents, CGFloat(self.attributes.elements.count)),1.0)
            let widthOfComponents = (self.width - attributes.insets.left - attributes.insets.right)/CGFloat(maximumOfComponents)
            for (_, item) in self.attributes.elements.enumerated() {
                item.selected.size = CGSize(width: widthOfComponents, height: self.height)
                item.unselected.size = CGSize(width: widthOfComponents, height: self.height)
            }
        }
        else {
            for (_, item) in self.attributes.elements.enumerated() {
                item.selected.size = CGSize(width: item.selected.width + self.attributes.spaceOfComponents, height: self.height)
                item.unselected.size = CGSize(width: item.unselected.width + self.attributes.spaceOfComponents, height: self.height)
            }
        }
        
        self.contentView.reloadData()
        self.resizeSlider(at: self.attributes.index, animated: false)
        
        //矫正位置
        DispatchQueue.main.asyncAfter(delay:0.01) {
            if self.contentView.contentSize.width > self.contentView.width {
                let indexPath = IndexPath(row: self.attributes.index, section: 0)
                self.contentView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    //更新title，index为第几个：从0开始
    open func update(title:String, at index: Int) {
        let item = self.attributes.elements[index]
        item.title = title
        item.selected.width = title.stringSize(font: attributes.selected.font,
                                               size: CGSize(width: NX.width, height: 44)).width + 2.0
        item.unselected.width = title.stringSize(font: attributes.unselected.font,
                                                 size: CGSize(width: NX.width, height: 44)).width + 2.0
        
        if self.attributes.isEqually {
            let maximumOfComponents = max(min(self.attributes.maximumOfComponents, CGFloat(self.attributes.elements.count)),1.0)
            let widthOfComponents = (self.width - attributes.insets.left - attributes.insets.right)/CGFloat(maximumOfComponents)
            
            item.selected.size = CGSize(width: widthOfComponents, height: self.height)
            item.unselected.size = CGSize(width: widthOfComponents, height: self.height)
        }
        else{
            item.selected.size = CGSize(width: item.selected.width + 16.0, height: self.height)
            item.unselected.size = CGSize(width: item.unselected.width + 16.0, height: self.height)
        }
        
        self.contentView.reloadData()
        self.resizeSlider(at: self.attributes.index, animated: false)
    }
    
    //在Controller中：手动滚动后 scrollViewDidEndScroll(_) 中调用NXSwipeView.onSelectView(_)切换滑块
    //在Swipeview中：手动点击后 collectionView(_ onSelectViewAt:)中调用NXSwipeView.onSelectView(_)切换滑块,并通知Controller
    
    open func onSelectView(at index: Int){
        if let completion = self.onSelect {
            completion(self.attributes.index, index)
        }
        else {
            self.didSelectView(at: index)
        }
    }
    
    open func didSelectView(at index: Int) {
        self.attributes.index = index
        
        self.contentView.reloadData()
        self.resizeSlider(at: index, animated: true)

        //矫正位置
        if contentView.contentSize.width > contentView.width {
            let indexPath = IndexPath(row: self.attributes.index, section: 0)
            self.contentView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    
    open func resizeSlider(at index:Int, animated:Bool){
        self.sliderView.isHidden = self.attributes.slider.isHidden
        self.sliderView.layer.cornerRadius = self.attributes.slider.radius
        self.sliderView.backgroundColor = self.attributes.slider.backgroundColor
        
        var __frame = CGRect.zero
        /*
         由于两个item的之间文字的间距是16pt,所以在计算item宽度的时候实在文字宽度的基础上加上了16
         所以这里需要将选中item.size.width减去16就是文字的宽度，也是滑块的宽度，origin.x也要减去一半
         */
        let item = self.attributes.elements[index]
        if self.attributes.slider.size.width > 0 {
            __frame.size.width = self.attributes.slider.size.width
        }
        else {
            __frame.size.width = item.selected.width - self.attributes.slider.insets.left - self.attributes.slider.insets.right
        }
        
        if self.attributes.slider.size.height > 0 {
            __frame.size.height = self.attributes.slider.size.height
        }
        else {
            __frame.size.height = 3
        }
        __frame.origin.y = self.height - self.attributes.slider.insets.bottom - __frame.size.height
        
        __frame.origin.x = self.attributes.insets.left + (item.selected.size.width - __frame.size.width)/2.0
        
        for (__idx, loop) in self.attributes.elements.enumerated() {
            if __idx < index {
                __frame.origin.x = __frame.origin.x + loop.unselected.size.width
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
                self.sliderView.frame = __frame
            }, completion:{ (finish) in
            })
        }
        else{
            self.sliderView.frame = __frame
        }
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setupSeparator(color: NX.separatorColor, ats: .maxY, insets: UIEdgeInsets.zero)
    }
    
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.attributes.elements.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item >= 0 && indexPath.item < self.attributes.elements.count {
            let item = self.attributes.elements[indexPath.item]
            item.isSelected = indexPath.item == self.attributes.index
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NXSwipeViewCell", for: indexPath) as? NXSwipeView.Cell {
                cell.updateSubviews(item)
                return cell
            }
        }
        return NXSwipeView.Cell()
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.attributes.index !=  indexPath.item {
            self.onSelectView(at: indexPath.item)
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return self.attributes.insets
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item >= 0 && indexPath.item < self.attributes.elements.count {
            let item = self.attributes.elements[indexPath.item]
            if self.attributes.index == indexPath.item {
                return item.selected.size
            }
            return item.unselected.size
        }
        return CGSize(width: 1.0, height: 1.0)
    }
}


extension NXSwipeView {
    
    open class Slider {
        open var isHidden = false
        open var size = CGSize(width: 0, height: 3.0)
        open var insets = UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
        open var backgroundColor = NX.mainColor
        open var radius : CGFloat = 0.0
    }
    
    open class ElementAttributes {
        open var width = Double.zero
        open var size = CGSize.zero
        open var attributes: AppearanceAttributes? = nil
        
        init(width: Double = Double.zero, size: CGSize = CGSize.zero, attributes: AppearanceAttributes? = nil) {
            self.width = width
            self.size = size
            self.attributes = attributes
        }
    }
    
    open class Element: NXItem {
        open var isSelected = false
        open var isSelectable = true
        open var title = ""
        public let selected = ElementAttributes()
        public let unselected = ElementAttributes()
    }
    
    open class Cell : NXCollectionViewCell {
        public let titleView: UILabel = UILabel(frame: CGRect.zero)
        override open func setupSubviews(){
            
            self.backgroundView?.backgroundColor = UIColor.clear
            
            self.titleView.frame = self.bounds
            self.titleView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.contentView.addSubview(self.titleView)
        }
        
        override open func updateSubviews(_ value:Any?){
            if let element = value as? NXSwipeView.Element {
                self.titleView.text = element.title
                if let attributes = element.isSelected ? element.selected.attributes : element.unselected.attributes {
                    self.titleView.textColor = attributes.color
                    self.titleView.font = attributes.font
                    self.titleView.textAlignment = attributes.textAlignment
                }
            }
        }
    }
}

