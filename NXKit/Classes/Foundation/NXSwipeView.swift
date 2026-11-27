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
        open var location = NXSwipeView.Location.contentView
        open var selectedAppearance = NXSwipeView.AppearanceAttributes() // 选中的效果
        open var unselectedAppearance = NXSwipeView.AppearanceAttributes(font: NXKit.font(15), color: NXKit.lightGrayColor) // 不选中的效果
        open var isEqually: Bool = true // 是否等分
        open var maximumOfComponents: CGFloat = 5.0 // 进行宽度的等分（isEqually == true 生效）
        open var spaceOfComponents: CGFloat = 16.0 // 两个元素之间的间距（isEqually == false 生效）
        open var slider = NXSwipeView.Slider() // 底部滑块
        open var separator = NXKit.Separator()

        public init() {}

        @discardableResult
        public func copy(fromValue: NXSwipeView.Attributes) -> NXSwipeView.Attributes {
            elements = fromValue.elements
            index = fromValue.index
            insets = fromValue.insets
            location = fromValue.location
            selectedAppearance = fromValue.selectedAppearance
            unselectedAppearance = fromValue.unselectedAppearance
            isEqually = fromValue.isEqually
            maximumOfComponents = fromValue.maximumOfComponents
            spaceOfComponents = fromValue.spaceOfComponents
            slider = fromValue.slider
            separator = fromValue.separator
            return self
        }
    }

    public enum Location: String, CaseIterable {
        case navigationView
        case contentView
    }

    open class AppearanceAttributes {
        open var font = NXKit.font(15, .bold)
        open var color = NXKit.blackColor
        open var textAlignment = NSTextAlignment.center

        init(font: UIFont = NXKit.font(15, .bold), color: UIColor = NXKit.blackColor, textAlignment: NSTextAlignment = .center) {
            self.font = font
            self.color = color
            self.textAlignment = textAlignment
        }
    }

    open var attributes = NXSwipeView.Attributes()
    open var sliderView = UIView(frame: CGRect.zero)
    open var onSelect: NXKit.Event<Int, Int>? = nil // 每次点击都会调用

    override open func setupSubviews() {
        super.setupSubviews()

        (contentView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        contentView.frame = bounds
        contentView.backgroundColor = NXKit.barBackgroundColor
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
        sliderView.layer.masksToBounds = true
        contentView.addSubview(sliderView)
    }

    override open func updateSubviews(_ value: Any?) {
        if let attributes = value as? NXSwipeView.Attributes {
            self.attributes.copy(fromValue: attributes)
            self.attributes.index = min(max(0, self.attributes.index), self.attributes.elements.count)
        }

        setupSeparator(color: attributes.separator.backgroundColor, ats: .maxY, insets: attributes.separator.insets)
        association?.separator?.isHidden = attributes.separator.isHidden

        for item in attributes.elements {
            if item.reuse.cls == nil || item.reuse.id.count <= 0 {
                item.reuse.cls = NXSwipeView.Cell.self
                item.reuse.id = "NXSwipeViewCell"
            }
            contentView.register(item.reuse.cls, forCellWithReuseIdentifier: item.reuse.id)

            item.selected.appearance = attributes.selectedAppearance
            item.unselected.appearance = attributes.unselectedAppearance

            item.selected.width = item.title.stringSize(font: attributes.selectedAppearance.font,
                                                        size: CGSize(width: NXKit.width, height: 44)).width + 2.0
            item.unselected.width = item.title.stringSize(font: attributes.unselectedAppearance.font,
                                                          size: CGSize(width: NXKit.width, height: 44)).width + 2.0
        }

        if attributes.isEqually {
            let maximumOfComponents = max(min(attributes.maximumOfComponents, CGFloat(attributes.elements.count)), 1.0)
            let widthOfComponents = (width - attributes.insets.left - attributes.insets.right) / CGFloat(maximumOfComponents)
            for (_, item) in attributes.elements.enumerated() {
                item.selected.size = CGSize(width: widthOfComponents, height: height)
                item.unselected.size = CGSize(width: widthOfComponents, height: height)
            }
        } else {
            for (_, item) in attributes.elements.enumerated() {
                item.selected.size = CGSize(width: item.selected.width + attributes.spaceOfComponents, height: height)
                item.unselected.size = CGSize(width: item.unselected.width + attributes.spaceOfComponents, height: height)
            }
        }

        contentView.reloadData()
        resizeSlider(at: attributes.index, animated: false)

        // 矫正位置
        DispatchQueue.main.asyncAfter(delay: 0.01) {
            if self.contentView.contentSize.width > self.contentView.width {
                let indexPath = IndexPath(row: self.attributes.index, section: 0)
                self.contentView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }

    // 更新title，index为第几个：从0开始
    open func update(title: String, at index: Int) {
        let item = attributes.elements[index]
        item.title = title
        item.selected.width = title.stringSize(font: attributes.selectedAppearance.font,
                                               size: CGSize(width: NXKit.width, height: 44)).width + 2.0
        item.unselected.width = title.stringSize(font: attributes.unselectedAppearance.font,
                                                 size: CGSize(width: NXKit.width, height: 44)).width + 2.0

        if attributes.isEqually {
            let maximumOfComponents = max(min(attributes.maximumOfComponents, CGFloat(attributes.elements.count)), 1.0)
            let widthOfComponents = (width - attributes.insets.left - attributes.insets.right) / CGFloat(maximumOfComponents)

            item.selected.size = CGSize(width: widthOfComponents, height: height)
            item.unselected.size = CGSize(width: widthOfComponents, height: height)
        } else {
            item.selected.size = CGSize(width: item.selected.width + 16.0, height: height)
            item.unselected.size = CGSize(width: item.unselected.width + 16.0, height: height)
        }

        contentView.reloadData()
        resizeSlider(at: attributes.index, animated: false)
    }

    // 在Controller中：手动滚动后 scrollViewDidEndScroll(_) 中调用NXSwipeView.onSelectView(_)切换滑块
    // 在Swipeview中：手动点击后 collectionView(_ onSelectViewAt:)中调用NXSwipeView.onSelectView(_)切换滑块,并通知Controller

    open func onSelectView(at index: Int) {
        if let completion = onSelect {
            completion(attributes.index, index)
        } else {
            didSelectView(at: index)
        }
    }

    open func didSelectView(at index: Int) {
        attributes.index = index

        contentView.reloadData()
        resizeSlider(at: index, animated: true)

        // 矫正位置
        if contentView.contentSize.width > contentView.width {
            let indexPath = IndexPath(row: attributes.index, section: 0)
            contentView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    open func resizeSlider(at index: Int, animated: Bool) {
        sliderView.isHidden = attributes.slider.isHidden
        sliderView.layer.cornerRadius = attributes.slider.radius
        sliderView.backgroundColor = attributes.slider.backgroundColor

        var __frame = CGRect.zero
        /*
         由于两个item的之间文字的间距是16pt,所以在计算item宽度的时候实在文字宽度的基础上加上了16
         所以这里需要将选中item.size.width减去16就是文字的宽度，也是滑块的宽度，origin.x也要减去一半
         */
        let item = attributes.elements[index]
        if attributes.slider.size.width > 0 {
            __frame.size.width = attributes.slider.size.width
        } else {
            __frame.size.width = item.selected.width - attributes.slider.insets.left - attributes.slider.insets.right
        }

        if attributes.slider.size.height > 0 {
            __frame.size.height = attributes.slider.size.height
        } else {
            __frame.size.height = 3
        }
        __frame.origin.y = height - attributes.slider.insets.bottom - __frame.size.height

        __frame.origin.x = attributes.insets.left + (item.selected.size.width - __frame.size.width) / 2.0

        for (__idx, loop) in attributes.elements.enumerated() {
            if __idx < index {
                __frame.origin.x = __frame.origin.x + loop.unselected.size.width
            }
        }

        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
                self.sliderView.frame = __frame
            }, completion: { _ in
            })
        } else {
            sliderView.frame = __frame
        }
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupSeparator(color: attributes.separator.backgroundColor, ats: .maxY, insets: attributes.separator.insets)
        association?.separator?.isHidden = attributes.separator.isHidden
    }

    open func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    open func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return attributes.elements.count
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item >= 0 && indexPath.item < attributes.elements.count {
            let item = attributes.elements[indexPath.item]
            item.isSelected = indexPath.item == attributes.index
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NXSwipeViewCell", for: indexPath) as? NXSwipeView.Cell {
                cell.updateSubviews(item)
                return cell
            }
        }
        return NXSwipeView.Cell()
    }

    open func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if attributes.index != indexPath.item {
            onSelectView(at: indexPath.item)
        }
    }

    open func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return attributes.insets
    }

    open func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }

    open func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }

    open func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item >= 0 && indexPath.item < attributes.elements.count {
            let item = attributes.elements[indexPath.item]
            if attributes.index == indexPath.item {
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
        open var backgroundColor = NXKit.primaryColor
        open var radius: CGFloat = 0.0
    }

    open class ElementAttributes {
        open var width = Double.zero
        open var size = CGSize.zero
        fileprivate var appearance: NXSwipeView.AppearanceAttributes?

        init(width: Double = Double.zero, size: CGSize = CGSize.zero, appearance: AppearanceAttributes? = nil) {
            self.width = width
            self.size = size
            self.appearance = appearance
        }
    }

    open class Element: NXItem {
        open var isSelected = false
        open var isSelectable = true
        open var title = ""
        public let selected = NXSwipeView.ElementAttributes()
        public let unselected = NXSwipeView.ElementAttributes()
    }

    open class Cell: NXCollectionViewCell {
        public let titleView: UILabel = .init(frame: CGRect.zero)
        override open func setupSubviews() {
            backgroundView?.backgroundColor = UIColor.clear

            titleView.frame = bounds
            titleView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            contentView.addSubview(titleView)
        }

        override open func updateSubviews(_ value: Any?) {
            if let element = value as? NXSwipeView.Element {
                titleView.text = element.title
                if let appearance = element.isSelected ? element.selected.appearance : element.unselected.appearance {
                    titleView.textColor = appearance.color
                    titleView.font = appearance.font
                    titleView.textAlignment = appearance.textAlignment
                }
            }
        }
    }
}
