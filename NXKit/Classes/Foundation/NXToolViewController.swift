//
//  NXToolViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/7/2.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXToolViewController: NXChildrenViewController {
    public let toolView = NXToolView(frame: CGRect(x: 0, y: 0, width: NXKit.width, height: NXKit.toolViewOffset + NXKit.safeAreaInsets.bottom))

    open class Attributes: NXToolView.Attributes {
        open var viewControllers = [UIViewController]()

        override public init() {}

        @discardableResult
        public func copy(fromValue: NXToolViewController.Attributes) -> NXToolViewController.Attributes {
            super.copy(fromValue: fromValue)
            viewControllers = fromValue.viewControllers
            return self
        }
    }

    public let attributes = NXToolViewController.Attributes()

    override open func viewDidLoad() {
        super.viewDidLoad()

        navigationView.isHidden = true
        contentView.isHidden = true

        setupSubviews()
    }

    override open func setupSubviews() {
        toolView.frame = CGRect(x: 0, y: view.height - NXKit.toolViewOffset - NXKit.safeAreaInsets.bottom, width: view.width, height: NXKit.toolViewOffset + NXKit.safeAreaInsets.bottom)
        toolView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        toolView.onSelect = { [weak self] fromValue, toValue in
            self?.didSelectViewController(fromValue: fromValue, toValue: toValue)
        }
        view.addSubview(toolView)
    }

    override open func updateSubviews(_ value: Any?) {
        if let attributes = value as? NXToolViewController.Attributes {
            self.attributes.copy(fromValue: attributes)
            self.attributes.index = min(max(0, attributes.index), viewControllers.count)
        }

        for vc in viewControllers {
            vc.removeFromParent()
            if vc.isViewLoaded {
                vc.view.removeFromSuperview()
            }
        }
        viewControllers.removeAll()
        viewControllers.append(contentsOf: attributes.viewControllers)
        for subviewController in viewControllers {
            if let subviewController = subviewController as? NXViewController {
                subviewController.ctxs.superviewController = self
            }
            addChild(subviewController)
        }

        toolView.updateSubviews(attributes)

        if attributes.index >= 0 && attributes.index < viewControllers.count {
            let toViewController = viewControllers[attributes.index]
            fromViewController(nil, toViewController: toViewController, animated: false)
        }
    }

    // 选中
    open func didSelectViewController(fromValue _: Int, toValue: Int) {
        guard toValue >= 0,
              toValue < attributes.viewControllers.count,
              attributes.index != toValue else { return }

        toolView.didSelectView(at: toValue)
        let fromViewController = viewControllers[attributes.index]
        let toViewController = viewControllers[toValue]
        self.fromViewController(fromViewController, toViewController: toViewController, animated: true)
        attributes.index = toValue
    }

    // 切换操作
    open func fromViewController(_ fromViewController: UIViewController?, toViewController: UIViewController?, animated _: Bool) {
        if let toViewController = toViewController {
            toViewController.view.frame = view.bounds
            toViewController.beginAppearanceTransition(true, animated: true)
        }

        if let fromViewController = fromViewController {
            fromViewController.beginAppearanceTransition(false, animated: true)
            fromViewController.view.removeFromSuperview()
            fromViewController.endAppearanceTransition()
        }

        if let toViewController = toViewController {
            toViewController.view.frame = view.bounds
            currentViewController = toViewController
            view.insertSubview(toViewController.view, belowSubview: toolView)
            toViewController.endAppearanceTransition()
        }

        updateNavigationAppearance()
    }
}
