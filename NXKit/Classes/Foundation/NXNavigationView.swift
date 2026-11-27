//
//  NXNavigationView.swift
//  NXKit
//
//  Created by niegaotao on 2020/6/23.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXNavigationView: NXBackgroundView<UIImageView, UIView> {
    open weak var controller: UIViewController?

    open var backBarButton = NXNavigationView.Bar.back(image: NXKit.image(named: "navi-back.png", mode: .alwaysTemplate), title: nil) // 默认
    open var leftView: UIView? {
        willSet {
            leftView?.removeFromSuperview()
        }
        didSet {
            updateSubviews(nil)
        }
    }

    open var title: String = "" {
        didSet {
            updateSubviews(nil)
        }
    }

    open var titleView = UILabel(frame: CGRect(x: 75.0, y: NXKit.safeAreaInsets.top, width: NXKit.width - 75.0 * 2, height: 44.0))
    open var centerView: UIView? {
        willSet {
            centerView?.removeFromSuperview()
        }
        didSet {
            updateSubviews(nil)
        }
    }

    open var rightBarButton: NXNavigationView.Bar? {
        willSet {
            rightBarButton?.removeFromSuperview()
        }
        didSet {
            updateSubviews(nil)
        }
    }

    open var rightView: UIView? {
        willSet {
            rightView?.removeFromSuperview()
        }
        didSet {
            updateSubviews(nil)
        }
    }

    open var isBackBarButtonHidden = false

    open var separator = CALayer()

    override open func setupSubviews() {
        super.setupSubviews()

        // 这是整个导航栏的背景颜色
        backgroundView.frame = bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.tintColor = NXKit.barBackgroundColor
        backgroundView.image = UIImage.image(color: NXKit.barBackgroundColor)?.withRenderingMode(.alwaysTemplate)

        // 整个导航栏的子控件
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.backgroundColor = UIColor.clear

        titleView.frame = CGRect(x: 75.0, y: NXKit.safeAreaInsets.top, width: contentView.width - 75.0 * 2, height: contentView.height - NXKit.safeAreaInsets.top)
        titleView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleView.textColor = NXKit.barForegroundColor
        titleView.tintColor = NXKit.barForegroundColor
        titleView.font = NXKit.font(17, .bold)
        titleView.textAlignment = .center
        contentView.addSubview(titleView)

        backBarButton.addTarget(nil, action: nil, completion: { [weak self] _ in
            if let viewController = self?.controller as? NXViewController {
                viewController.onBackPressed()
            } else if let navigationController = self?.controller?.navigationController {
                navigationController.popViewController(animated: true)
            }
        })
        backBarButton.autoresizingMask = [.flexibleHeight]
        backBarButton.frame = CGRect(x: 15, y: NXKit.safeAreaInsets.top, width: backBarButton.width, height: contentView.height - NXKit.safeAreaInsets.top)
        backBarButton.isHidden = true
        contentView.addSubview(backBarButton)

        separator.frame = CGRect(x: 0, y: contentView.height - NXKit.pixel, width: contentView.width, height: NXKit.pixel)
        separator.backgroundColor = NXKit.separatorColor.cgColor
        separator.isHidden = true
        contentView.layer.addSublayer(separator)
    }

    override open func updateSubviews(_: Any?) {
        separator.frame = CGRect(x: 0, y: contentView.height - NXKit.pixel, width: contentView.width, height: NXKit.pixel)

        if true {
            let size = backBarButton.frame.size
            backBarButton.frame = CGRect(x: 15, y: NXKit.safeAreaInsets.top + (contentView.height - NXKit.safeAreaInsets.top - size.height) / 2, width: size.width, height: size.height)

            if let controller = controller,
               let viewControllers = self.controller?.navigationController?.viewControllers,
               let index = viewControllers.firstIndex(of: controller), index >= 1
            {
                backBarButton.isHidden = isBackBarButtonHidden
            }
        }

        if let leftView = leftView {
            let size = leftView.frame.size
            leftView.frame = CGRect(x: 15, y: NXKit.safeAreaInsets.top + (contentView.height - NXKit.safeAreaInsets.top - size.height) / 2, width: size.width, height: size.height)
            if leftView.superview == nil {
                contentView.addSubview(leftView)
            }
            backBarButton.isHidden = true
        }

        if true {
            if title.count > 0 {
                titleView.text = title
            } else if let title = controller?.title, title.count > 0 {
                titleView.text = title
            }
            let size = titleView.frame.size
            titleView.frame = CGRect(x: titleView.x, y: NXKit.safeAreaInsets.top + (contentView.height - NXKit.safeAreaInsets.top - size.height) / 2, width: size.width, height: size.height)
        }

        if let centerView = centerView {
            let size = centerView.frame.size
            centerView.frame = CGRect(x: centerView.x, y: NXKit.safeAreaInsets.top + (contentView.height - NXKit.safeAreaInsets.top - size.height) / 2, width: size.width, height: size.height)
            if centerView.superview == nil {
                contentView.addSubview(centerView)
            }
            titleView.isHidden = true
        }

        if let rightView = rightView {
            let size = rightView.frame.size
            rightView.frame = CGRect(x: contentView.width - 15 - size.width, y: NXKit.safeAreaInsets.top + (contentView.height - NXKit.safeAreaInsets.top - size.height) / 2, width: size.width, height: size.height)
            if rightView.superview == nil {
                contentView.addSubview(rightView)
            }
        } else if let rightBarButton = rightBarButton {
            let size = rightBarButton.frame.size
            rightBarButton.frame = CGRect(x: contentView.width - 15 - size.width, y: NXKit.safeAreaInsets.top + (contentView.height - NXKit.safeAreaInsets.top - size.height) / 2, width: size.width, height: size.height)
            if rightBarButton.superview == nil {
                contentView.addSubview(rightBarButton)
            }
        }
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        separator.backgroundColor = NXKit.separatorColor.cgColor
    }
}

extension NXNavigationView {
    open class Bar: UIButton {
        open var dicValue: [String: Any]?
        override public init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = UIColor.clear
            setupSubviews()
        }

        public required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            backgroundColor = UIColor.clear
            setupSubviews()
        }

        open func setupSubviews() {
            frame.size = CGSize(width: 70.0, height: 44.0)
            setTitleColor(NXKit.barForegroundColor, for: .normal)
            setTitleColor(NXKit.lightGrayColor, for: .highlighted)
            tintColor = NXKit.barForegroundColor
            titleLabel?.font = NXKit.font(17)
        }

        open class func back(image: UIImage?, title: String?) -> NXNavigationView.Bar {
            let element = NXNavigationView.Bar(frame: CGRect.zero)
            element.contentHorizontalAlignment = .left
            element.updateSubviews(image, title)
            return element
        }

        open class func back(image: UIImage?, title: String?, target: Any?, action: Selector?) -> NXNavigationView.Bar {
            let element = NXNavigationView.Bar.back(image: image, title: title)
            element.addTarget(target, action: action, completion: nil)
            return element
        }

        open class func back(image: UIImage?, title: String?, completion: ((_ owner: NXNavigationView.Bar) -> Void)?) -> NXNavigationView.Bar {
            let element = NXNavigationView.Bar.back(image: image, title: title)
            element.addTarget(nil, action: nil, completion: completion)
            return element
        }

        open class func forward(image: UIImage?, title: String?) -> NXNavigationView.Bar {
            let element = NXNavigationView.Bar(frame: CGRect.zero)
            element.contentHorizontalAlignment = .right
            element.updateSubviews(image, title)
            return element
        }

        open class func forward(image: UIImage?, title: String?, target: Any?, action: Selector?) -> NXNavigationView.Bar {
            let element = NXNavigationView.Bar.forward(image: image, title: title)
            element.addTarget(target, action: action, completion: nil)
            return element
        }

        open class func forward(image: UIImage?, title: String?, completion: ((_ owner: NXNavigationView.Bar) -> Void)?) -> NXNavigationView.Bar {
            let element = NXNavigationView.Bar.forward(image: image, title: title)
            element.addTarget(nil, action: nil, completion: completion)
            return element
        }

        open func addTarget(_ target: Any?, action: Selector?, completion: ((_ owner: NXNavigationView.Bar) -> Void)?) {
            if let __completion = completion {
                setupEvent(UIControl.Event.touchUpInside) { _, _ in
                    __completion(self)
                }
            } else if let __target = target as? NSObject, let __action = action {
                setupEvent(UIControl.Event.touchUpInside) { _, _ in
                    if __target.responds(to: __action) {
                        __target.perform(__action)
                    }
                }
            } else {
                association?.removeTarget(self, event: UIControl.Event.touchUpInside)
            }
        }

        open func updateSubviews(_ image: UIImage?, _ title: String?) {
            setImage(image, for: .normal)
            setTitle(title, for: .normal)
        }
    }
}
