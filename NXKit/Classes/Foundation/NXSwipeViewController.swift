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
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width * CGFloat(toValue), y: 0), animated: true)
    }

    override open func updateSubviews(_ value: Any?) {
        if let attributes = value as? NXSwipeViewController.Attributes {
            self.attributes.copy(fromValue: attributes)
        }

        if attributes.location == .navigationView {
            navigationView.centerView = swipeView
        } else {
            contentView.addSubview(swipeView)
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

        layoutPages()
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutPages()
    }

    private var isLayingOutPages = false

    private func layoutPages() {
        let inNavigation = attributes.location == .navigationView
        let width = contentView.bounds.width
        let top: CGFloat = inNavigation ? 0 : 44
        let barWidth = inNavigation ? max(0, width - 160) : width
        let pageFrame = CGRect(x: 0, y: top, width: width, height: max(0, contentView.bounds.height - top))
        let sizeChanged = scrollView.bounds.size != pageFrame.size
        let selectedIndex = attributes.index
        let barSize = CGSize(width: barWidth, height: 44)
        if swipeView.bounds.size != barSize {
            swipeView.frame.size = barSize
            if inNavigation { navigationView.setNeedsLayout() }
        }
        isLayingOutPages = true
        defer { isLayingOutPages = false }
        scrollView.frame = pageFrame
        scrollView.contentSize = CGSize(width: width * CGFloat(viewControllers.count), height: pageFrame.height)
        for (index, controller) in viewControllers.enumerated() {
            controller.viewIfLoaded?.frame = CGRect(x: width * CGFloat(index), y: 0,
                                                    width: width, height: pageFrame.height)
        }
        if sizeChanged || (!scrollView.isDragging && !scrollView.isDecelerating) {
            let offset = CGPoint(x: width * CGFloat(selectedIndex), y: 0)
            if scrollView.contentOffset != offset {
                scrollView.contentOffset = offset
            }
        }
    }

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.width
        guard width > 0, !isLayingOutPages else { return }
        let index = Int((scrollView.contentOffset.x / width).rounded())
        if viewControllers.indices.contains(index) {
            attributes.index = index
            swipeView.didSelectView(at: index)
            currentViewController = viewControllers[index]
            if let vc = currentViewController {
                vc.view.frame = CGRect(origin: CGPoint(x: width * CGFloat(index), y: 0), size: scrollView.bounds.size)
                self.scrollView.addSubview(vc.view)
            }
        }
    }
}
