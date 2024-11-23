//
//  NXActionView.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/31.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

public extension NXActionView {
    @discardableResult
    class func alert(title: String, subtitle: String, actions: [String], completion: NXKit.Event<String, Int>?) -> NXActionView {
        let __actions = actions.map { title -> NXAbstract in
            return NXAbstract(title: title, value: nil, completion: { __action in
                __action.asset.isHidden = true
                __action.title.isHidden = false
                if actions.count == 2 {
                    __action.size = CGSize(width: NXKit.Association.size.width * 0.5, height: NXKit.Association.size.height)
                    __action.title.frame = CGRect(x: 0, y: 0, width: __action.size.width, height: __action.size.height)
                } else {
                    __action.size = CGSize(width: NXKit.Association.size.width, height: NXKit.Association.size.height)
                    __action.title.frame = CGRect(x: 0, y: 0, width: __action.size.width, height: __action.size.height)
                }
                __action.title.color = NXKit.blackColor
                __action.title.font = NXKit.font(16, .bold)
                __action.title.textAlignment = .center
                __action.subtitle.isHidden = true
                __action.arrow.isHidden = true
            })
        }

        return NXActionView.alert(title: title, subtitle: subtitle, actions: __actions, completion: completion)
    }

    @discardableResult
    class func alert(title: String, subtitle: String, actions: [NXAbstract], completion: NXKit.Event<String, Int>?) -> NXActionView {
        for (_, action) in actions.enumerated() {
            if actions.count == 2 {
                action.size = CGSize(width: NXKit.Association.size.width * 0.5, height: NXKit.Association.size.height)
                action.title.frame = CGRect(x: 0, y: 0, width: action.size.width, height: action.size.height)
            } else {
                action.size = CGSize(width: NXKit.Association.size.width, height: NXKit.Association.size.height)
                action.title.frame = CGRect(x: 0, y: 0, width: NXKit.Association.size.width, height: action.size.height)
            }
        }

        /*
         空白：20
         title:20,20,actionView.ctxs.header.frame.width - 40, 30
         空白10
         center:20,60,actionView.ctxs.header.frame.width - 40, __height
         空白20
         */
        let actionView = NXActionView(frame: UIScreen.main.bounds)
        actionView.ctxs.key = NXActionView.Key.alert.rawValue
        actionView.ctxs.wrap(header: .header(true, false, true, false, title, subtitle)) // header
        actionView.ctxs.wrap(center: .center(actions)) // center
        actionView.ctxs.wrap(footer: .none) // footer
        actionView.updateSubviews(nil)
        actionView.ctxs.completion = completion
        actionView.open(animation: actionView.ctxs.animation, completion: nil)
        return actionView
    }

    @discardableResult
    class func action(actions: [String], completion: NXKit.Event<String, Int>?) -> NXActionView {
        let __actions = actions.map { title -> NXAbstract in
            return NXAbstract(title: title, value: nil, completion: { __action in
                __action.asset.isHidden = true
                __action.title.isHidden = false
                __action.subtitle.isHidden = true
            })
        }
        return NXActionView.action(actions: __actions, header: .none, footer: .footer(false, "取消"), completion: completion)
    }

    @discardableResult
    class func action(actions: [NXAbstract], completion: NXKit.Event<String, Int>?) -> NXActionView {
        return NXActionView.action(actions: actions, header: .none, footer: .footer(false, "取消"), completion: completion)
    }

    @discardableResult
    class func action(actions: [NXAbstract], header: NXActionView.Attachment, footer: NXActionView.Attachment, completion: NXKit.Event<String, Int>?) -> NXActionView {
        let actionView = NXActionView(frame: UIScreen.main.bounds)
        actionView.ctxs.key = NXActionView.Key.action.rawValue
        actionView.ctxs.wrap(header: header) // header
        actionView.ctxs.wrap(center: .center(actions)) // center
        actionView.ctxs.wrap(footer: footer) // footer
        actionView.updateSubviews(nil)
        actionView.ctxs.completion = completion
        actionView.open(animation: actionView.ctxs.animation, completion: nil)
        return actionView
    }
}

public extension NXActionView {
    enum Key: String {
        case alert = "center.alert" // 中部弹框
        case action = "footer.action" // 底部弹出一横排的排列
        case flow = "footer.flow" // 底部弹出混合式排列
        case unknown
    }

    enum Attachment {
        case header(_ lhs: Bool, _ center: Bool, _ rhs: Bool, _ description: Bool, _ centerValue: String, _ descriptionValue: String)
        case center(_ actions: [NXAbstract])
        case footer(_ center: Bool, _ centerValue: String)

        case custom(_ customView: UIView) // 定制
        case whitespace(_ height: CGFloat) // 视图存在，但是没有任何需要展示的信息
        case none // 无底部
    }
}

public class NXActionViewAttributes: NXOverlayAttributes {
    public var key = NXActionView.Key.action.rawValue
    public let header = NXActionView.Header()
    public let center = NXActionView.Center()
    public let footer = NXActionView.Footer()
    public var devide = CGFloat(6.0) // 底部分开的高度，默认是6pt(只有在底部高度>0的时候有效)
    public var max = NXKit.height * 0.70
    public var isAnimation = true

    public func wrap(header attachment: NXActionView.Attachment) {
        if key == NXActionView.Key.alert.rawValue {
            /*
             空白：20
             centerValue:20,20,actionView.ctxs.header.frame.width - 40, 30
             空白10
             descriptionValue:20,60,actionView.ctxs.header.frame.width - 40, __height
             空白20
             */
            if case let .header(_, _, _, _, centerValue, descriptionValue) = attachment {
                // header
                header.frame.size = CGSize(width: NXKit.width * 0.8, height: 20)
                header.separator.ats = NXKit.Ats.maxY
                header.backgroundColor = NXKit.cellBackgroundColor
                header.isHidden = false
                // header-left
                header.lhs.isHidden = true

                // header-center
                header.center.isHidden = centerValue.count <= 0
                header.center.value = centerValue
                header.center.numberOfLines = 0
                header.center.lineSpacing = 3.0
                header.center.font = NXKit.font(17, .bold)
                if true {
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.lineSpacing = header.description.lineSpacing
                    header.description.attributedString = NSAttributedString(string: header.center.value,
                                                                             attributes: [NSAttributedString.Key.font: header.center.font,
                                                                                          NSAttributedString.Key.foregroundColor: header.center.color,
                                                                                          NSAttributedString.Key.paragraphStyle: paragraph])
                }

                if centerValue.count > 0 {
                    var sizeTitle = String.size(of: centerValue,
                                                size: CGSize(width: NXKit.Association.size.width - 40, height: NXKit.height * 0.6),
                                                font: header.center.font,
                                                style: { paragraphStyle in
                                                    paragraphStyle.lineSpacing = 3.0
                                                })
                    sizeTitle.height = ceil(Swift.max(24.0, sizeTitle.height)) + 2.0
                    header.center.frame = CGRect(x: 20, y: header.frame.size.height, width: header.frame.width - 40, height: sizeTitle.height)
                    header.frame.size.height = header.frame.size.height + sizeTitle.height
                }

                if centerValue.count > 0 && descriptionValue.count > 0 {
                    header.frame.size.height = header.frame.size.height + 10
                }

                // header-right
                header.rhs.isHidden = true

                // header-description
                header.description.isHidden = descriptionValue.count <= 0
                header.description.font = NXKit.font(15.5, .regular)
                header.description.value = descriptionValue
                header.description.lineSpacing = 2.5
                header.description.numberOfLines = 0
                if true {
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.lineSpacing = header.description.lineSpacing
                    header.description.attributedString = NSAttributedString(string: header.description.value,
                                                                             attributes: [NSAttributedString.Key.font: header.description.font,
                                                                                          NSAttributedString.Key.foregroundColor: header.description.color,
                                                                                          NSAttributedString.Key.paragraphStyle: paragraph])
                }

                if descriptionValue.count > 0 {
                    var sizeSubtitle = String.size(of: descriptionValue,
                                                   size: CGSize(width: NXKit.Association.size.width - 40, height: NXKit.height * 0.6),
                                                   font: header.description.font,
                                                   style: { paragraphStyle in
                                                       paragraphStyle.lineSpacing = 2.5
                                                   })
                    sizeSubtitle.height = ceil(Swift.max(20.0, sizeSubtitle.height)) + 2.0

                    header.description.frame = CGRect(x: 20, y: header.frame.size.height, width: header.frame.width - 40, height: sizeSubtitle.height)
                    header.frame.size.height = header.frame.size.height + sizeSubtitle.height
                }
                header.frame.size.height = header.frame.size.height + 20
            }
        } else if key == NXActionView.Key.action.rawValue || key == NXActionView.Key.flow.rawValue {
            if case let .header(lhs, center, rhs, _, centerValue, _) = attachment {
                header.isHidden = false
                header.frame.size = CGSize(width: NXKit.width, height: 60)
                header.separator.ats = NXKit.Ats.maxY
                header.backgroundColor = NXKit.cellBackgroundColor

                header.lhs.isHidden = lhs
                if header.lhs.isHidden == false {
                    header.lhs.color = NXKit.blackColor
                    header.lhs.image = NXKit.image(named: "icon-close.png", mode: .alwaysTemplate)
                }

                header.center.isHidden = center
                if header.center.isHidden == false {
                    header.center.value = centerValue
                }

                header.rhs.isHidden = rhs
                if header.rhs.isHidden == false {
                    header.lhs.color = NXKit.blackColor
                    header.rhs.value = "确定"
                }

                header.description.isHidden = true
            } else if case let .custom(customView) = attachment {
                header.isHidden = false
                header.frame.size = CGSize(width: NXKit.width, height: customView.frame.size.height)
                header.separator.ats = NXKit.Ats.maxY

                header.lhs.isHidden = true
                header.center.isHidden = true
                header.rhs.isHidden = true
                header.description.isHidden = true
                header.customView = customView
            } else if case let .whitespace(height) = attachment {
                header.isHidden = false
                header.frame.size = CGSize(width: NXKit.width, height: height)
                header.separator.ats = NXKit.Ats.maxY

                header.lhs.isHidden = true
                header.center.isHidden = true
                header.rhs.isHidden = true
                header.description.isHidden = true
            } else if case .none = attachment {
                header.isHidden = true
                header.frame.size = CGSize(width: NXKit.width, height: 0)
                header.separator.ats = []

                header.lhs.isHidden = true
                header.center.isHidden = true
                header.rhs.isHidden = true
                header.description.isHidden = true
            }
        } else if key == NXActionView.Key.unknown.rawValue {}
    }

    public func wrap(center attachment: NXActionView.Attachment) {
        if key == NXActionView.Key.alert.rawValue {
            if case let .center(actions) = attachment {
                center.actions = actions
                center.isHidden = false
            }
        } else if key == NXActionView.Key.action.rawValue || key == NXActionView.Key.flow.rawValue {
            if case let .center(actions) = attachment {
                center.actions = actions
                center.isHidden = false
            }
        } else if key == NXActionView.Key.unknown.rawValue {}
    }

    public func wrap(footer attachment: NXActionView.Attachment) {
        if key == NXActionView.Key.alert.rawValue {
            footer.isHidden = true
            footer.frame.size = CGSize.zero
        } else if key == NXActionView.Key.action.rawValue || key == NXActionView.Key.flow.rawValue {
            footer.separator.ats = []
            if case let .footer(center, centerValue) = attachment {
                footer.backgroundColor = NXKit.barBackgroundColor
                footer.isHidden = false
                footer.frame.size = CGSize(width: NXKit.width, height: 60 + NXKit.safeAreaInsets.bottom)
                footer.content.isHidden = center
                footer.content.frame = CGRect(x: 0, y: 0, width: NXKit.width, height: 60)
                footer.content.font = NXKit.font(17)
                footer.content.color = NXKit.primaryColor
                footer.content.value = centerValue.count > 0 ? centerValue : "取消"
            } else if case let .custom(customView) = attachment {
                footer.frame.size = CGSize(width: NXKit.width, height: customView.frame.size.height + NXKit.safeAreaInsets.bottom)
                footer.content.isHidden = true
                footer.customView = customView
            } else if case let .whitespace(height) = attachment {
                footer.isHidden = true
                footer.frame.size = CGSize(width: NXKit.width, height: height + NXKit.safeAreaInsets.bottom)
                footer.content.isHidden = true
                devide = 0.0
            } else if case .none = attachment {
                footer.isHidden = true
                footer.frame.size = CGSize(width: NXKit.width, height: NXKit.safeAreaInsets.bottom)
                footer.content.isHidden = true
                devide = 0.0
            }
        } else if key == NXActionView.Key.unknown.rawValue {}
    }
}

public class NXActionView: NXAbstractOverlay<NXActionViewAttributes> {
    public let headerView = NXActionView.HeaderView(frame: CGRect.zero)
    public let centerView = NXActionView.CenterView(frame: CGRect.zero)
    public let footerView = NXActionView.FooterView(frame: CGRect.zero)

    override public func setupSubviews() {
        super.setupSubviews()

        // 0.背景
        backgroundView.setupEvent(.touchUpInside, action: { [weak self] _, _ in
            guard let __weakself = self else { return }
            __weakself.close(animation: __weakself.ctxs.animation, completion: { _ in
                __weakself.ctxs.close?("background", nil)
            })
        })

        contentView.backgroundColor = NXKit.backgroundColor

        // 1.中间
        centerView.isHidden = true
        centerView.event = { [weak self] (_ index: Int, _ action: NXAbstract) in
            guard let __weakself = self else { return }
            if action.raw.isCloseable {
                __weakself.close(animation: __weakself.ctxs.animation, completion: { _ in
                    __weakself.ctxs.completion?("", index)
                })
            } else {
                __weakself.ctxs.completion?("", index)
            }
        }
        contentView.addSubview(centerView)

        // 2.头部
        headerView.isHidden = true
        headerView.lhsView.setupEvent(.touchUpInside) { [weak self] _, _ in
            guard let __weakself = self else { return }
            __weakself.close(animation: __weakself.ctxs.animation, completion: { (_ isCompleted) in
                __weakself.ctxs.close?("header.lhs", nil)
            })
        }
        headerView.rhsView.setupEvent(.touchUpInside) { [weak self] _, _ in
            guard let __weakself = self else { return }
            __weakself.close(animation: __weakself.ctxs.animation, completion: { (_ isCompleted) in
                __weakself.ctxs.close?("header.rhs", nil)
            })
        }
        contentView.addSubview(headerView)

        // 3.脚部
        footerView.isHidden = true
        footerView.contentView.setupEvent(.touchUpInside) { [weak self] _, _ in
            guard let __weakself = self else { return }
            __weakself.close(animation: __weakself.ctxs.animation, completion: { (_ isCompleted) in
                __weakself.ctxs.close?("footer.center", nil)
            })
        }
        contentView.addSubview(footerView)
    }

    override open func updateSubviews(_: Any?) {
        if ctxs.key.contains("center") {
            ctxs.animation = NXOverlay.Animation.center.rawValue

            ctxs.size = CGSize(width: NXKit.width * 0.8, height: 0.0)
            contentView.layer.cornerRadius = 8
            contentView.layer.masksToBounds = true
            contentView.backgroundColor = NXKit.backgroundColor
            backgroundView.isUserInteractionEnabled = false
        } else if ctxs.key.contains("footer") {
            ctxs.animation = NXOverlay.Animation.footer.rawValue

            ctxs.size = CGSize(width: NXKit.width * 1.0, height: 0.0)

            if ctxs.devide > 0 {
                ctxs.center.backgroundColor = NXKit.viewBackgroundColor
            } else {
                ctxs.center.backgroundColor = NXKit.backgroundColor
            }
        }

        ctxs.header.frame.size.width = ctxs.size.width
        ctxs.footer.frame.size.width = ctxs.size.width
        ctxs.center.frame.size.width = ctxs.size.width

        ctxs.center.frame.size.height = NXActionView.Center.center(ctxs).height
        ctxs.center.frame.size.height = min(ctxs.center.frame.height, ctxs.max - ctxs.header.frame.size.height - ctxs.footer.frame.height) // 最优高度

        // 1
        if ctxs.header.frame.size.height > 0 {
            ctxs.header.frame.origin = CGPoint(x: 0, y: 0)
            ctxs.size.height = ctxs.size.height + ctxs.header.frame.size.height
        }

        // 2
        if ctxs.center.frame.size.height > 0 {
            ctxs.center.frame.origin = CGPoint(x: 0, y: ctxs.size.height)
            ctxs.size.height = ctxs.size.height + ctxs.center.frame.size.height
        }

        // 3
        if ctxs.footer.frame.size.height > 0 {
            ctxs.size.height = ctxs.size.height + ctxs.devide
            ctxs.footer.frame.origin = CGPoint(x: 0, y: ctxs.size.height)
            ctxs.size.height = ctxs.size.height + ctxs.footer.frame.size.height
        }

        if ctxs.key.contains("footer") && ctxs.center.isHidden == false {
            ctxs.center.insets = UIEdgeInsets(top: ctxs.header.height, left: 0, bottom: ctxs.footer.height, right: 0)
            var __frame = ctxs.center.frame
            __frame.origin.y = 0
            __frame.size.height = __frame.size.height + ctxs.center.insets.top + ctxs.center.insets.bottom
            ctxs.center.frame = __frame
        }

        headerView.updateSubviews(ctxs)
        centerView.updateSubviews(ctxs)
        footerView.updateSubviews(ctxs)

        if ctxs.key.contains("center") {
            contentView.frame = CGRect(x: (ctxs.size.width - ctxs.size.width) / 2.0, y: (ctxs.size.height - ctxs.size.height) / 2.0, width: ctxs.size.width, height: ctxs.size.height)
        } else if ctxs.key.contains("footer") {
            contentView.frame = CGRect(x: (frame.size.width - ctxs.size.width) / 2.0, y: frame.size.height - ctxs.size.height, width: ctxs.size.width, height: ctxs.size.height)
        }
    }
}

extension NXActionView {
    open class Header: NXKit.View {
        public let lhs = NXKit.Attribute { __sender in
            __sender.frame = CGRect(x: 16, y: (60 - 44) / 2, width: 84, height: 44)
            __sender.font = NXKit.font(16, .regular)
            __sender.color = NXKit.primaryColor
            __sender.textAlignment = .left
            __sender.backgroundColor = .clear
        }

        public let center = NXKit.Attribute { __sender in
            __sender.frame = CGRect(x: 100, y: (60 - 44) / 2, width: NXKit.width - 200, height: 44)
            __sender.font = NXKit.font(16, .bold)
            __sender.color = NXKit.blackColor
            __sender.textAlignment = .center
            __sender.backgroundColor = .clear
        }

        public let rhs = NXKit.Attribute { __sender in
            __sender.frame = CGRect(x: NXKit.width - 16 - 84, y: (60 - 44) / 2, width: 84, height: 44)
            __sender.color = NXKit.primaryColor
            __sender.textAlignment = .right
            __sender.backgroundColor = .clear
        }

        public let description = NXKit.Attribute { __sender in
            __sender.textAlignment = .center
            __sender.font = NXKit.font(18, .bold)
            __sender.color = NXKit.blackColor
            __sender.backgroundColor = .clear
        }

        public let separator = NXKit.Separator { _ in
        }

        public var customView: UIView? = nil
    }

    public class HeaderView: NXLCRView<NXButton, UILabel, NXButton> {
        public let descriptionView = UILabel(frame: CGRect.zero)
        public var value: NXActionViewAttributes? = nil
        override public func setupSubviews() {
            super.setupSubviews()

            lhsView.frame = CGRect(x: 16, y: (height - 44) / 2, width: 84, height: 44)
            lhsView.contentHorizontalAlignment = .left
            lhsView.titleLabel?.font = NXKit.font(16)
            lhsView.layer.masksToBounds = true

            centerView.frame = CGRect(x: 100, y: (height - 44) / 2, width: width - 100 * 2, height: 44)
            centerView.textAlignment = .center
            centerView.font = NXKit.font(18, .bold)
            centerView.textColor = NXKit.blackColor
            centerView.numberOfLines = 1
            centerView.layer.masksToBounds = true

            rhsView.frame = CGRect(x: width - 16 - 84, y: (height - 44) / 2, width: 84, height: 44)
            rhsView.contentHorizontalAlignment = .right
            rhsView.titleLabel?.font = NXKit.font(16)
            rhsView.layer.masksToBounds = true

            descriptionView.isHidden = true
            descriptionView.textAlignment = .center
            descriptionView.font = NXKit.font(17, .regular)
            descriptionView.numberOfLines = 0
            descriptionView.textColor = NXKit.blackColor
            descriptionView.layer.masksToBounds = true
            addSubview(descriptionView)
        }

        override public func updateSubviews(_ value: Any?) {
            guard let wrapped = value as? NXActionViewAttributes else {
                return
            }
            self.value = wrapped
            let metadata = wrapped.header

            isHidden = metadata.isHidden
            frame = metadata.frame
            backgroundColor = metadata.backgroundColor
            if metadata.isHidden {
                return
            }

            if let __customView = metadata.customView {
                __customView.isHidden = false
                if __customView.superview != self {
                    addSubview(__customView)
                }
            }

            NXKit.View.update(metadata.lhs, lhsView)
            NXKit.View.update(metadata.center, centerView)
            NXKit.View.update(metadata.rhs, rhsView)
            NXKit.View.update(metadata.description, descriptionView)

            if metadata.separator.ats == NXKit.Ats.maxY {
                setupSeparator(color: metadata.separator.backgroundColor, ats: .maxY)
                association?.separator?.isHidden = false
            } else {
                association?.separator?.isHidden = true
            }
        }

        override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            updateSubviews(value)
        }
    }
}

public extension NXActionView {
    class Center: NXKit.View {
        public var actions = [NXAbstract]()
        public var insets = UIEdgeInsets.zero
        public var customView: UIView? = nil
        public class func center(_ wrapped: NXActionViewAttributes) -> CGSize {
            let metadata = wrapped.center
            var contentSize = CGSize(width: metadata.frame.width, height: 0)
            if let __customView = metadata.customView {
                contentSize.height = __customView.frame.size.height
            } else if wrapped.key == NXActionView.Key.alert.rawValue {
                if metadata.actions.count == 2 {
                    for index in 0 ... 1 {
                        let action = metadata.actions[index]
                        action.size.width = metadata.frame.width * 0.5
                        action.title.frame = CGRect(x: 0, y: 0, width: action.size.width, height: action.size.height)
                        action.raw.isHighlighted = true
                        action.raw.isEnabled = true
                        if index == 0 {
                            action.raw.separator.ats = .maxX
                        } else {
                            action.raw.separator.ats = []
                        }
                        contentSize.height = action.size.height
                    }
                } else {
                    // 1个/3个/4个
                    for index in 0 ... metadata.actions.count - 1 {
                        let action = metadata.actions[index]
                        action.size.width = metadata.size.width
                        action.title.frame = CGRect(x: 0, y: 0, width: action.size.width, height: action.size.height)
                        action.raw.isHighlighted = true
                        action.raw.isEnabled = true
                        action.raw.separator.ats = (index == metadata.actions.count - 1) ? [] : .maxY

                        contentSize.height = contentSize.height + action.size.height
                    }
                }
                wrapped.isAnimation = false
            } else if wrapped.key == NXActionView.Key.action.rawValue {
                for (index, action) in metadata.actions.enumerated() {
                    action.size.width = metadata.frame.width
                    action.raw.separator.ats = (index == metadata.actions.count - 1) ? [] : .maxY

                    contentSize.height = contentSize.height + action.size.height
                }
            } else if wrapped.key == NXActionView.Key.flow.rawValue {
                var offsetValue: (x: CGFloat, y: CGFloat, rowHeight: CGFloat) = (0, 0, 0)
                for (idx, action) in metadata.actions.enumerated() {
                    if offsetValue.x + action.size.width <= metadata.frame.width {
                        // 可以排在同一行
                        offsetValue.x = offsetValue.x + action.size.width
                        if offsetValue.rowHeight < action.size.height {
                            offsetValue.rowHeight = action.size.height
                        }
                    } else {
                        // 新开一行
                        offsetValue.y = offsetValue.y + offsetValue.rowHeight

                        offsetValue.x = action.size.width
                        offsetValue.rowHeight = action.size.height
                    }
                    if idx == metadata.actions.count - 1 {
                        offsetValue.y = offsetValue.y + offsetValue.rowHeight
                    }
                }
                contentSize.height = contentSize.height + offsetValue.y
            } else {
                contentSize.height = 0.0
            }
            contentSize.height = contentSize.height + metadata.insets.top + metadata.insets.bottom
            return contentSize
        }
    }

    class CenterView: NXCView<NXCollectionView>, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        private(set) var ctxs = NXActionViewAttributes()
        public var event: NXKit.Event<Int, NXAbstract>? = nil

        override public func setupSubviews() {
            super.setupSubviews()

            contentView.frame = bounds
            if let layout = contentView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.minimumLineSpacing = 0.0
                layout.minimumInteritemSpacing = 0.0
                layout.scrollDirection = .vertical
                layout.sectionInset = UIEdgeInsets.zero
            }
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            contentView.backgroundColor = NXKit.backgroundColor
            contentView.delaysContentTouches = false
        }

        override public func updateSubviews(_ value: Any?) {
            guard let __wrapped = value as? NXActionViewAttributes else {
                return
            }
            ctxs = __wrapped
            let metadata = __wrapped.center
            isHidden = metadata.isHidden
            frame = metadata.frame
            backgroundColor = metadata.backgroundColor

            if metadata.isHidden {
                return
            }

            for option in metadata.actions {
                if let cls = option.reuse.cls as? NXCollectionViewCell.Type {
                    contentView.register(cls, forCellWithReuseIdentifier: option.reuse.id)
                }
            }
            contentView.dataSource = self
            contentView.delegate = self

            if let __customView = metadata.customView {
                __customView.isHidden = false
                addSubview(__customView)
                contentView.isHidden = true
            } else {
                contentView.backgroundColor = metadata.backgroundColor
                contentView.isHidden = false
                contentView.contentInset = metadata.insets
                contentView.frame = bounds
                contentView.reloadData()
            }
        }

        public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
            return ctxs.center.actions.count
        }

        public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let action = ctxs.center.actions[indexPath.item]
            return action.size
        }

        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let action = ctxs.center.actions[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: action.reuse.id, for: indexPath) as! NXActionViewCell
            cell.updateSubviews(action)
            return cell
        }

        public func collectionView(_: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt _: IndexPath) {
            if ctxs.isAnimation == true {
                var rotation = CATransform3DMakeTranslation(0, -2, 0.0)
                rotation.m43 = 1.0 / -600.0
                cell.layer.shadowColor = UIColor.black.cgColor
                cell.layer.shadowOffset = CGSize(width: 5, height: 5)
                cell.alpha = 0
                cell.layer.transform = rotation

                UIView.animate(withDuration: 0.5, animations: {
                    cell.layer.transform = CATransform3DIdentity
                    cell.alpha = 1.0
                    cell.layer.shadowOffset = CGSize.zero
                }) { _ in
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.ctxs.isAnimation = false
                }
            }
        }

        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)

            let action = ctxs.center.actions[indexPath.item]
            if action.raw.isEnabled == true {
                if action.raw.isCloseable {
                    event?(indexPath.item, action)
                } else {
                    action.event?("", indexPath.item)
                }
            }
        }
    }
}

public extension NXActionView {
    class Footer: NXKit.View {
        public let content = NXKit.Attribute { __sender in
            __sender.frame = CGRect(x: 100, y: (60 - 44) / 2, width: NXKit.width - 200, height: 44)
            __sender.font = NXKit.font(16, .bold)
            __sender.color = NXKit.blackColor
            __sender.textAlignment = .center
            __sender.backgroundColor = .clear
        }

        public let separator = NXKit.Separator { _ in
        }

        public var customView: UIView? = nil
    }

    class FooterView: NXCView<NXButton> {
        public var value: NXActionViewAttributes? = nil

        override public func setupSubviews() {
            super.setupSubviews()

            backgroundColor = NXKit.backgroundColor

            // 初始化一个button
            contentView.frame = CGRect(x: 16.0, y: 10, width: width - 16.0 - 16.0, height: 40)
            contentView.titleLabel?.font = NXKit.font(15)
            contentView.layer.masksToBounds = true

            // 设置顶部分割线
            setupSeparator(color: NXKit.separatorColor, ats: .minY)
        }

        override public func updateSubviews(_ value: Any?) {
            guard let wrapped = value as? NXActionViewAttributes else {
                return
            }
            self.value = wrapped
            let metadata = wrapped.footer
            isHidden = metadata.isHidden
            frame = metadata.frame
            backgroundColor = metadata.backgroundColor

            if metadata.isHidden {
                return
            }

            if let __customView = metadata.customView {
                __customView.isHidden = false
                if __customView.superview != self {
                    addSubview(__customView)
                }
            }

            NXKit.View.update(metadata.content, contentView)

            if metadata.separator.ats == NXKit.Ats.minY {
                setupSeparator(color: NXKit.separatorColor, ats: .minY)
                association?.separator?.isHidden = false
            } else {
                association?.separator?.isHidden = true
            }
        }

        override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            updateSubviews(value)
        }
    }
}
