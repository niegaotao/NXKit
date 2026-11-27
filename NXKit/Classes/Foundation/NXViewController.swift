//
//  NXViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/8.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXViewController: UIViewController {
    /// ctxs.index用于记录分页加载的索引，xyz备用
    public let ctxs = NXViewController.Association()

    /// 导航栏
    open var navigationView = NXNavigationView(frame: CGRect(x: 0, y: 0, width: NXKit.width, height: NXKit.safeAreaInsets.top + 44.0))

    /// 内容视图，不会被导航栏覆盖
    open var contentView = UIView(frame: CGRect(x: 0, y: NXKit.safeAreaInsets.top + 44.0, width: NXKit.width, height: NXKit.height - NXKit.safeAreaInsets.top - 44.0))

    /// 页面无内容时的加载动画
    open var animationView: (UIView & NXAnimationViewProtocol)?

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    /// 子类中有需要在viewDidLoad之前的逻辑放在这个函数中，而不用重写构造函数
    open func initialize() {
        NXKit.print("\(NSStringFromClass(classForCoder)), \(Unmanaged<AnyObject>.passUnretained(self as AnyObject).toOpaque())")
        extendedLayoutIncludesOpaqueBars = true
        edgesForExtendedLayout = UIRectEdge.all
        if #available(iOS 11.0, *) {}
        else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = NXKit.viewBackgroundColor

        contentView.frame = CGRect(x: 0, y: NXKit.safeAreaInsets.top + 44.0, width: view.width, height: view.height - NXKit.safeAreaInsets.top - 44.0)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(contentView)

        navigationView.frame = CGRect(x: 0, y: 0, width: view.width, height: NXKit.safeAreaInsets.top + 44.0)
        navigationView.autoresizingMask = [.flexibleWidth]
        navigationView.controller = self
        view.addSubview(navigationView)
        navigationView.updateSubviews(nil)
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !ctxs.lifecycleValue.contains(NXKit.Lifecycle.viewWillAppear) {
            ctxs.lifecycleValue = ctxs.lifecycleValue.union(NXKit.Lifecycle.viewWillAppear)
            ctxs.lifecycle?(NXKit.Lifecycle.viewWillAppear, self)
        }

        // 更新状态栏样式
        updateNavigationAppearance()
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !ctxs.lifecycleValue.contains(NXKit.Lifecycle.viewDidAppear) {
            ctxs.lifecycleValue = ctxs.lifecycleValue.union(NXKit.Lifecycle.viewDidAppear)
            ctxs.lifecycle?(NXKit.Lifecycle.viewDidAppear, self)
        }
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if !ctxs.lifecycleValue.contains(NXKit.Lifecycle.viewWillDisappear) {
            ctxs.lifecycleValue = ctxs.lifecycleValue.union(NXKit.Lifecycle.viewWillDisappear)
            ctxs.lifecycle?(NXKit.Lifecycle.viewWillDisappear, self)
        }
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if !ctxs.lifecycleValue.contains(NXKit.Lifecycle.viewDidDisappear) {
            ctxs.lifecycleValue = ctxs.lifecycleValue.union(NXKit.Lifecycle.viewDidDisappear)
            ctxs.lifecycle?(NXKit.Lifecycle.viewDidDisappear, self)
        }
    }

    // 开始动画
    open func startAnimating() {
        if !ctxs.isLoaded {
            if let animationView = animationView {
                animationView.frame = contentView.bounds
                contentView.addSubview(animationView)
                contentView.bringSubviewToFront(animationView)
                animationView.startAnimating()
            }
        }
    }

    // 结束动画
    open func stopAnimating(_: Bool = true) {
        animationView?.stopAnimating()
        if !ctxs.isLoaded {
            ctxs.isLoaded = true
        }
    }

    // 创建视图:父类不会自动调用
    open func setupSubviews() {}

    // 更新视图：父类不会自动调用
    open func updateSubviews(_: Any?) {}

    // 更新导航栏：父类会自动调用
    open func updateNavigationAppearance() {
        setNeedsStatusBarAppearanceUpdate()
    }

    /// 关闭当前控制器
    open func close() {
        if ctxs.navigation == .push {
            if let count = navigationController?.viewControllers.count, count > 1 {
                navigationController?.popViewController(animated: true)
            }
        } else if ctxs.navigation == .present {
            dismiss(animated: true, completion: nil)
        } else if ctxs.navigation == .overlay {
            if let navigationController = ctxs.superviewController?.navigationController as? NXNavigationController {
                navigationController.closeViewController(self, animated: true)
            }
        }
    }

    // 返回按钮点击
    open func onBackPressed() {
        close()
    }

    // 开始网络请求：处理加载框的开启/关闭,网络异常,参数异常等情况
    open func request(_: String, _: Any?, _: NXKit.Event<String, Any?>? = nil) {}

    // 页面内的相关逻辑操作
    open func dispose(_: String, _: Any?, _: NXKit.Event<String, Any?>? = nil) {}

    // 是否支持通过重力感应自动转屏幕
    open func shouldAutorotate() -> Bool {
        return ctxs.shouldAutorotate
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return ctxs.statusBarStyle
    }

    override open var prefersStatusBarHidden: Bool {
        return ctxs.statusBarHidden
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return ctxs.supportedOrientations
    }

    override open func present(_ viewController: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if let viewController = viewController as? NXViewController {
            viewController.ctxs.navigation = .present
        }
        super.present(viewController, animated: flag, completion: completion)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        NXKit.print("\(NSStringFromClass(self.classForCoder)), \(Unmanaged<AnyObject>.passUnretained(self as AnyObject).toOpaque())")
    }
}

extension NXViewController {
    open class Association {
        open var index = 0 /// 用于记录当前正在请求或者展示的页面index，多用于分页加载
        open var state = NXKit.Reload.initialized /// 当前刷新状态
        open var isLoaded: Bool = false /// 页面是否加载成功过

        open var lifecycleValue = NXKit.Lifecycle.initialized
        open var lifecycle: NXKit.Event<NXKit.Lifecycle, NXViewController>?

        /// 状态栏样式
        open var shouldAutorotate = false
        open var statusBarStyle = UIStatusBarStyle.default
        open var statusBarHidden = false
        open var supportedOrientations = UIInterfaceOrientationMask.portrait

        /// 是否允许手势返回：某些页面会设置不允许手势返回，采用block是因为可以在当前页面接收到右滑手势返回事件
        open var onBackInvoked: ((UIPanGestureRecognizer) -> (Bool)) = { _ in true }

        /// 进行的什么操作
        open var navigation = NXKit.Navigation.push
        /// 从哪个方向载入
        open var orientation = NXKit.Orientation.right
        /// 转场动画过程中需要的容器视图
        open var transitionView: NXTransitionView?
        /// 两级页面之间传递信息
        open var event: NXKit.Event<String, Any?>?
        /// 覆盖的视图控制器
        public var viewControllers = [NXViewController]()
        /// 容器试图管理器
        public weak var superviewController: NXViewController?

        /// 初始化方法
        public init() {}
    }
}

open class NXWrappedViewController<C: UIViewController>: NXViewController {
    public let viewController = C()

    override open func viewDidLoad() {
        super.viewDidLoad()

        navigationView.isHidden = true
        contentView.isHidden = true

        if let vc = viewController as? NXViewController {
            vc.ctxs.superviewController = self
        }
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}
