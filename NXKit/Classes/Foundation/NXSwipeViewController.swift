//
//  NXSwipeViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/6/13.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXSwipeViewController: NXChildrenViewController, UIScrollViewDelegate {
    open var scrollView = NXScrollView(frame: CGRect.zero)
    open var swipeView = NXSwipeView(frame: CGRect(x: 0, y: 0, width: NXKit.width, height: 44))

    open class Attributes: NXSwipeView.Attributes {
        open var viewControllers = [NXViewController]()

        override public init() {}

        @discardableResult
        public func copy(fromValue: NXSwipeViewController.Attributes) -> NXSwipeViewController.Attributes {
            super.copy(fromValue: fromValue)
            viewControllers = fromValue.viewControllers
            return self
        }
    }

    public let attributes = NXSwipeViewController.Attributes()

    override open func viewDidLoad() {
        super.viewDidLoad()

        // 滚动的容器
        swipeView.onSelect = { [weak self] fromIndex, toIndex in
            self?.didSelectViewController(fromValue: fromIndex, toValue: toIndex)
        }

        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.backgroundColor = NXKit.viewBackgroundColor
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.isSupportedMultirecognizers = true
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        contentView.addSubview(scrollView)
    }

    // 选中
    public func didSelectViewController(fromValue _: Int, toValue: Int) {
        guard toValue >= 0,
              toValue < attributes.viewControllers.count,
              attributes.index != toValue else { return }

        currentViewController = viewControllers[toValue]
        scrollView.setContentOffset(CGPoint(x: view.width * CGFloat(toValue), y: 0), animated: true)
    }

    override open func updateSubviews(_ value: Any?) {
        if let attributes = value as? NXSwipeViewController.Attributes {
            self.attributes.copy(fromValue: attributes)
        }

        if attributes.location == .navigationView {
            swipeView.frame = CGRect(x: 80, y: 0, width: NXKit.width - 80 * 2, height: 44)
            navigationView.centerView = swipeView
            navigationView.updateSubviews(nil)

            scrollView.frame = CGRect(x: 0, y: 0, width: NXKit.width, height: contentView.height)
            scrollView.contentSize = contentView.bounds.size
        } else if attributes.location == .contentView {
            swipeView.frame = CGRect(x: 0, y: 0, width: NXKit.width, height: 44)
            contentView.addSubview(swipeView)

            scrollView.frame = CGRect(x: 0, y: 44, width: NXKit.width, height: contentView.height - 44)
            scrollView.contentSize = contentView.bounds.size
        }

        // 移除历史数据
        for vc in viewControllers {
            vc.removeFromParent()
            if vc.isViewLoaded {
                vc.view.removeFromSuperview()
            }
        }
        viewControllers.removeAll()

        // 拼接新数据
        viewControllers.append(contentsOf: attributes.viewControllers)
        scrollView.contentSize = CGSize(width: contentView.width * Double(viewControllers.count),
                                        height: contentView.height)
        for (idx, vc) in viewControllers.enumerated() {
            if let vc = vc as? NXViewController {
                vc.ctxs.superviewController = self
            }
            addChild(vc)

            if attributes.index == idx {
                currentViewController = vc
                vc.view.frame = CGRect(origin: CGPoint(x: contentView.width * Double(attributes.index), y: 0), size: contentView.frame.size)
                scrollView.addSubview(vc.view)
            }
        }

        swipeView.updateSubviews(attributes)

        if attributes.index >= 1 {
            scrollView.setContentOffset(CGPoint(x: view.width * CGFloat(attributes.index), y: 0), animated: false)
        }
    }

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let p = scrollView.contentOffset
        let index = Int((p.x + CGFloat(NXKit.width) * 0.5) / CGFloat(NXKit.width))
        if index < viewControllers.count {
            attributes.index = index
            swipeView.didSelectView(at: index)
            currentViewController = viewControllers[index]
            if let vc = currentViewController {
                vc.view.frame = CGRect(origin: CGPoint(x: contentView.width * Double(index), y: 0), size: contentView.frame.size)
                self.scrollView.addSubview(vc.view)
            }
        }
    }
}
