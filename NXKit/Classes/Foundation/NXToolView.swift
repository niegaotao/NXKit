//
//  NXToolView.swift
//  NXKit
//
//  Created by niegaotao on 2020/7/2.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXToolView: NXBackgroundView<UIImageView, UIView> {
    open class Attributes {
        open var elements = [NXToolView.Element]() //
        open var index = 0
        open var selectedAppearance = NXToolView.AppearanceAttributes()
        open var unselectedAppearance = NXToolView.AppearanceAttributes(color: NXKit.lightGrayColor)

        public init() {}

        @discardableResult
        public func copy(fromValue: NXToolView.Attributes) -> NXToolView.Attributes {
            elements = fromValue.elements
            index = fromValue.index
            selectedAppearance = fromValue.selectedAppearance
            unselectedAppearance = fromValue.unselectedAppearance
            return self
        }
    }

    open class AppearanceAttributes {
        open var color = NXKit.primaryColor
        open var renderingMode = UIImage.RenderingMode.alwaysTemplate
        init(color: UIColor = NXKit.primaryColor, renderingMode: UIImage.RenderingMode = .alwaysTemplate) {
            self.color = color
            self.renderingMode = renderingMode
        }
    }

    public let attributes = NXToolView.Attributes()

    open var onSelect: NXKit.Event<Int, Int>? = nil // 每次点击都会调用
    public let separator = NXKit.Separator { __sender in
        __sender.isHidden = false
        __sender.backgroundColor = NXKit.separatorColor
    }

    public let shadow = NXKit.Layer { __sender in
        __sender.isHidden = true
        __sender.shadowColor = NXKit.shadowColor
        __sender.shadowOffset = CGSize(width: 0, height: -2)
        __sender.shadowRadius = 2.0
        __sender.shadowOpacity = 0.15
    }

    public let highlighted = NXToolView.Highlighted { __sender in
        __sender.isHidden = true
    }

    override open func setupSubviews() {
        super.setupSubviews()
        backgroundView.image = UIImage.image(color: NXKit.barBackgroundColor)?.withRenderingMode(.alwaysTemplate)
        backgroundView.tintColor = NXKit.barBackgroundColor
        contentView.addSubview(highlighted.targetView)
    }

    override open func updateSubviews(_ value: Any?) {
        if let attributes = value as? NXToolView.Attributes {
            self.attributes.copy(fromValue: attributes)
            self.attributes.index = max(min(attributes.index, self.attributes.elements.count), 0)
        }

        for element in attributes.elements {
            element.selected.appearance = attributes.selectedAppearance
            element.unselected.appearance = attributes.unselectedAppearance
        }

        if highlighted.isHidden == false {
            // 如果想要显示中间的加大按钮，必须满足常规按钮的个数是偶数个
            highlighted.isHidden = (attributes.elements.count % 2 != 0)
        }

        // 设置阴影
        if shadow.isHidden == false {
            layer.shadowColor = shadow.shadowColor.cgColor
            layer.shadowOffset = shadow.shadowOffset
            layer.shadowRadius = shadow.shadowRadius
            layer.shadowOpacity = Float(shadow.shadowOpacity)
            layer.cornerRadius = layer.shadowRadius
            layer.masksToBounds = false
        } else {
            layer.shadowColor = UIColor.clear.cgColor
            layer.masksToBounds = true
        }

        // 分隔线
        if separator.isHidden == false {
            contentView.setupSeparator(color: separator.backgroundColor, ats: .minY, insets: .zero)
            contentView.association?.separator?.isHidden = false
            contentView.association?.separator?.backgroundColor = separator.backgroundColor.cgColor
        } else {
            contentView.association?.separator?.isHidden = true
        }

        // 中间按钮
        highlighted.targetView.updateSubviews(highlighted)

        // tab
        let size = CGSize(width: highlighted.isHidden ? width / max(CGFloat(attributes.elements.count), 1) : width / CGFloat(attributes.elements.count + 1), height: NXKit.toolViewOffset)
        for (index, element) in attributes.elements.enumerated() {
            element.size = CGSize(width: size.width, height: size.height)
            element.targetView.isHidden = false
            element.targetView.frame = CGRect(x: size.width * CGFloat(index), y: 0, width: size.width, height: size.height)
            if index >= attributes.elements.count / 2 && highlighted.isHidden == false {
                element.targetView.frame = CGRect(x: size.width * CGFloat(index + 1), y: 0, width: size.width, height: size.height)
            }
            element.targetView.tag = index
            element.targetView.setupEvent(UIControl.Event.touchUpInside) { [weak self] _, v in

                guard let __toolView = self,
                      let __elementView = v as? NXToolView.ElementView,
                      __elementView.tag >= 0 && __elementView.tag < __toolView.attributes.elements.count
                else {
                    return
                }

                self?.onSelectView(at: __elementView.tag)
            }
            contentView.addSubview(element.targetView)
        }

        for (index, element) in attributes.elements.enumerated() {
            element.targetView.isHidden = false
            element.isSelected = index == attributes.index
            element.targetView.updateSubviews(element)
        }
    }

    open func onSelectView(at index: Int) {
        if attributes.index == index {
            return
        }

        if let completion = onSelect {
            completion(attributes.index, index)
        } else {
            didSelectView(at: index)
        }
    }

    open func didSelectView(at index: Int) {
        guard
            index >= 0,
            index < attributes.elements.count,
            attributes.index != index else { return }

        let element = attributes.elements[index]
        attributes.index = index

        if element.badge.isResetable {
            element.badge.value = 0
        }

        updateSubviews(nil)
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        // 设置阴影
        if shadow.isHidden == false {
            layer.shadowColor = shadow.shadowColor.cgColor
            layer.shadowOffset = shadow.shadowOffset
            layer.shadowRadius = shadow.shadowRadius
            layer.shadowOpacity = Float(shadow.shadowOpacity)
            layer.cornerRadius = layer.shadowRadius
            layer.masksToBounds = false
        } else {
            layer.shadowColor = UIColor.clear.cgColor
            layer.masksToBounds = true
        }
    }

    // 处理超出部分的点击
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if highlighted.isHidden == false {
            let convert = self.convert(point, to: highlighted.targetView)
            if highlighted.targetView.point(inside: convert, with: event) {
                return highlighted.targetView
            }
        }
        return super.hitTest(point, with: event)
    }
}

extension NXToolView {
    open class Highlighted: NXKit.View {
        public let image = NXKit.Image(completion: nil)
        public let targetView = NXToolView.HighlightedView(frame: CGRect(x: 0, y: 0, width: 80, height: 50))

        public required init() {
            super.init()
        }

        public init(completion: NXKit.Completion<NXToolView.Highlighted>?) {
            super.init()
            completion?(self)
        }
    }

    open class HighlightedView: NXControl {
        public let imageView = UIImageView(frame: CGRect.zero)
        override open func setupSubviews() {
            backgroundColor = UIColor.clear

            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 0
            imageView.layer.masksToBounds = true
            addSubview(imageView)
        }

        override open func updateSubviews(_ value: Any?) {
            guard let element = value as? NXToolView.Highlighted else {
                return
            }

            frame = element.frame
            isHidden = element.isHidden
            backgroundColor = element.backgroundColor
            layer.cornerRadius = element.cornerRadius

            imageView.image = element.image.value?.withRenderingMode(element.image.renderingMode)
            imageView.frame = element.image.frame
            imageView.tintColor = element.image.color
        }
    }
}

extension NXToolView {
    open class Badge {
        public var type = NXToolView.BadgeType.numeric // 是否直接显示数字
        public var value: Int = 0 // 消息数量
        public var backgroundColor = UIColor.red // 消息背景色
        public var color = UIColor.white // 消息前景色
        public var borderColor = UIColor.red
        public var borderWidth: CGFloat = 0
        public var size: CGFloat = 11
        public var insets = UIEdgeInsets(top: 1.5, left: 1.5, bottom: 1.5, right: 1.5)
        public var isResetable = false // 点击后数字是否清0
    }

    public enum BadgeType {
        case numeric
        case dot
    }

    open class ElementAttributes {
        open var image: UIImage?
        fileprivate var appearance: NXToolView.AppearanceAttributes?

        init(image: UIImage? = nil) {
            self.image = image
        }
    }

    open class Element: NXKit.View {
        public var title = ""
        public let selected = NXToolView.ElementAttributes()
        public let unselected = NXToolView.ElementAttributes()
        public let badge = NXToolView.Badge()

        public var space: CGFloat = 0.0
        public var isSelected = false
        public let targetView = NXToolView.ElementView(frame: CGRect(x: 0, y: 0, width: NXKit.width / 4.0, height: NXKit.toolViewOffset))

        public required init() {
            super.init()
        }

        public init(completion: NXKit.Completion<NXToolView.Element>?) {
            super.init()
            completion?(self)
        }
    }

    open class ElementView: NXControl {
        public let assetView = UIImageView(frame: CGRect.zero)
        public let titleView = UILabel(frame: CGRect.zero)
        public let badgeView = UILabel(frame: CGRect.zero)

        override open func setupSubviews() {
            super.setupSubviews()
            addSubview(assetView)

            titleView.font = NXKit.font(11)
            titleView.textAlignment = .center
            addSubview(titleView)

            badgeView.layer.masksToBounds = true
            badgeView.textAlignment = .center
            addSubview(badgeView)
        }

        override open func updateSubviews(_ value: Any?) {
            super.updateSubviews(value)

            guard let element = value as? NXToolView.Element else {
                return
            }
            var __raw: (size: CGSize, height: CGFloat) = (CGSize(width: 28.0, height: 28.0), 14.0)
            if element.isSelected {
                if let image = element.selected.image {
                    __raw.size = image.size
                }
            } else {
                if let image = element.unselected.image {
                    __raw.size = image.size
                }
            }

            let space: CGFloat = __raw.size.height + element.space + __raw.height
            assetView.frame = CGRect(x: (element.width - __raw.size.width) / 2.0, y: (element.height - space) / 2.0, width: __raw.size.width, height: __raw.size.height)
            titleView.frame = CGRect(x: 0, y: assetView.frame.maxY + element.space, width: width, height: __raw.height)

            if element.isSelected {
                if let appearance = element.selected.appearance {
                    assetView.image = element.selected.image?.withRenderingMode(appearance.renderingMode)
                    assetView.tintColor = appearance.color

                    titleView.text = element.title
                    titleView.textColor = appearance.color
                }
            } else {
                if let appearance = element.unselected.appearance {
                    assetView.image = element.unselected.image?.withRenderingMode(appearance.renderingMode)
                    assetView.tintColor = appearance.color

                    titleView.text = element.title
                    titleView.textColor = appearance.color
                }
            }

            if element.badge.value > 0 {
                badgeView.isHidden = false
                if element.badge.type == .numeric {
                    var badgeValue = "\(element.badge.value)"
                    if element.badge.value > 99 {
                        badgeValue = "99+"
                    }
                    // 6.87, 13.13
                    var __size = badgeValue.stringSize(font: NXKit.font(element.badge.size), size: CGSize(width: 100, height: 100))
                    __size.width = max(element.badge.insets.left, 0) + __size.width + max(element.badge.insets.right, 0)
                    __size.height = max(element.badge.insets.top, 0) + __size.height + max(element.badge.insets.bottom, 0)
                    if __size.width < __size.height {
                        __size.width = __size.height
                    }
                    badgeView.layer.borderWidth = element.badge.borderWidth
                    badgeView.layer.borderColor = element.badge.borderColor.cgColor
                    badgeView.layer.cornerRadius = __size.height / 2.0
                    badgeView.backgroundColor = element.badge.backgroundColor
                    badgeView.text = badgeValue
                    badgeView.textColor = element.badge.color
                    badgeView.font = NXKit.font(element.badge.size)
                    badgeView.frame = CGRect(x: assetView.frame.maxX - __size.width / 2.0, y: assetView.frame.minY, width: __size.width, height: __size.height)
                } else {
                    let __size = CGSize(width: 6, height: 6)
                    badgeView.layer.borderWidth = 0
                    badgeView.layer.cornerRadius = __size.height / 2.0
                    badgeView.backgroundColor = element.badge.backgroundColor
                    badgeView.text = ""
                    badgeView.frame = CGRect(x: assetView.frame.maxX - __size.width, y: assetView.frame.minY, width: __size.width, height: __size.height)
                }
            } else {
                badgeView.isHidden = true
            }
        }
    }
}
