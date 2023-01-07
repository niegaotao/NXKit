//
//  NXNavigationController.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/8.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    /// 全屏返回手势，默认开启全屏手势返回，如果要禁掉全屏手势返回，请在相应的控制器中执行如下代码即可
    public let panRecognizer = UIPanGestureRecognizer()
    /// 动画相关
    public let ctxs = NXNavigationController.Associated()
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.initialize()
    }
    
    public override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        self.initialize()
    }
    
    ///设置
    open func initialize() {
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = UIRectEdge.all
        if #available(iOS 11.0, *) {
        }
        else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.ctxs.owner = self
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSubviews()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.ctxs.willAppear?("", self)
        self.ctxs.willAppear = nil
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.ctxs.didAppear?("", self)
        self.ctxs.didAppear = nil
    }
    
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.ctxs.willDisappear?("", self)
        self.ctxs.willDisappear = nil
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.ctxs.didDisappear?("", self)
        self.ctxs.didDisappear = nil
    }
    
    
    open func setupSubviews(){
        self.setNavigationBarHidden(true, animated: false)
        
        ///添加全屏POP手势
        self.setupPanRecognizer()
    }
    
    /// 全屏POP手势
    private func setupPanRecognizer(){
        guard let edge = interactivePopGestureRecognizer else { return }
        guard let targetView = edge.view else {return}
        guard let targetEntity = (edge.value(forKey: "_targets") as? [NSObject])?.first else { return }
        guard let target = targetEntity.value(forKey: "target") else { return }
        let action = Selector(("handleNavigationTransition:"))
        
        panRecognizer.addTarget(target, action: action)
        panRecognizer.delegate = self as UIGestureRecognizerDelegate
        targetView.addGestureRecognizer(panRecognizer)
    }
    
    
    ///是否支持自动旋转屏幕
    open func shouldAutorotate() -> Bool {
        return self.topViewController?.shouldAutorotate ?? false
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        return self.presentedViewController ?? self.topViewController
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        return self.presentedViewController ?? self.topViewController
    }
    
    
    /// 重写父类push方法
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let viewController = viewController as? NXViewController {
            viewController.ctxs.navigation = .push
            viewController.ctxs.orientation = .right
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    ///当push完成后回触发completion
    open func pushViewController(_ viewController: NXViewController, animated: Bool, completion:NX.Event<String, NXViewController>?){
        viewController.ctxs.didAppear = completion
        self.pushViewController(viewController, animated: animated)
    }
    
    override open func present(_ viewController: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if let viewController = viewController as? NXViewController {
            viewController.ctxs.navigation = .present
        }
        super.present(viewController, animated: flag, completion: completion)
    }
    
    
    ///全屏返回手势
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if self.panRecognizer == gestureRecognizer {
            
            //未识别时
            let state = panRecognizer.state
            if state != .began && state != .possible {
                return false
            }
            
            //在根控制器页面的时候不支持手势返回
            if self.viewControllers.count <= 1 {
                return false
            }
            
            //没有向右滑动的分量就不触发
            let translation = panRecognizer.translation(in: panRecognizer.view)
            if translation.x <= CGFloat(0.0) {
                return false
            }
            
            //某些页面会设置不允许手势返回，采用block是因为可以在当前页面接收到右滑手势返回事件
            if let fromViewController = self.topViewController as? NXViewController {
                //如过有弹出的自定义视图不支持手势返回
                if fromViewController.ctxs.subviewControllers.count > 0 {
                    return false
                }
                return fromViewController.ctxs.panRecognizer("", panRecognizer)
            }
            
            //支持返回
            return true
        }
        
        //默认支持手势返回
        return true
    }
    
    
    /// 弹出一个视图控制器
    ///
    /// - Parameters:
    ///   - viewController: 要弹出的视图控制器
    ///   - animated: 是否需要动画，动画方向默认从右侧进入
    open func openViewController(_ viewController: NXViewController, animated: Bool){
        //添加到的父视图控制器:必须栈顶的视图控制器
        guard let to = self.topViewController as? NXViewController else {return}
        
        ctxs.semaphore.wait()
        viewController.ctxs.navigation = .overlay
        
        to.ctxs.subviewControllers.append(viewController)
        viewController.ctxs.superviewController = to
        
        viewController.view.frame = to.view.bounds
        viewController.view.backgroundColor = UIColor.clear
        
        viewController.ctxs.transitionView = NXTransitionView(frame: to.view.bounds, owner:viewController)
        viewController.ctxs.transitionView?.backgroundColor = NX.transitionInoutBackgroundColor
        to.view.addSubview(viewController.ctxs.transitionView!)
        viewController.ctxs.transitionView?.addSubview(viewController.view)
        
        if viewController.ctxs.orientation == .left {
            viewController.view.x = -to.view.width
            UIView.animate(withDuration: animated ? self.ctxs.duration : 0.0,
                           delay: 0.0,
                           options: [.curveEaseInOut],
                           animations: {
                            viewController.view.x = 0.0
                            viewController.ctxs.transitionView?.backgroundColor = NX.transitionBackgroundColor
            },completion: {(_) in
                self.ctxs.semaphore.signal()
            })
        }
        else if viewController.ctxs.orientation == .right {
            viewController.view.x = to.view.width
            UIView.animate(withDuration: animated ? self.ctxs.duration:0.0,
                           delay: 0.0,
                           options: [.curveEaseInOut],
                           animations: {
                            viewController.view.x = 0.0
                            viewController.ctxs.transitionView?.backgroundColor = NX.transitionBackgroundColor
            }, completion: {(_) in
                self.ctxs.semaphore.signal()
            })
        }
        else if viewController.ctxs.orientation == .top {
            viewController.view.y = -to.view.height
            UIView.animate(withDuration: animated ? self.ctxs.duration:0.0,
                           delay: 0.0,
                           options: [.curveEaseInOut],
                           animations: {
                            viewController.view.y = 0.0
                            viewController.ctxs.transitionView?.backgroundColor = NX.transitionBackgroundColor
            }, completion: {(_) in
                self.ctxs.semaphore.signal()
            })
        }
        else if viewController.ctxs.orientation == .bottom {
            viewController.view.y = to.view.height
            UIView.animate(withDuration: animated ? self.ctxs.duration:0.0,
                           delay: 0.0,
                           options: [.curveEaseInOut],
                           animations: {
                            viewController.view.y = 0.0
                            viewController.ctxs.transitionView?.backgroundColor = NX.transitionBackgroundColor
            }, completion: {(_) in
                self.ctxs.semaphore.signal()
            })
        }
        else{
            self.ctxs.semaphore.signal()
        }
    }
    
    
    /// 移除一个视图控制器
    ///
    /// - Parameters:
    ///   - viewController: 要移除的视图控制器
    ///   - animated: 是否需要动画
    open func closeViewController(_ viewController: NXViewController, animated: Bool){
        guard let parentViewController = viewController.ctxs.superviewController else {return}
        guard let index = parentViewController.ctxs.subviewControllers.lastIndex(of: viewController) else { return }
        self.ctxs.semaphore.wait()
        if viewController.ctxs.orientation == .left {
            self.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: animated ? self.ctxs.duration:0.0,
                           delay: 0.0,
                           options: [.curveEaseInOut],
                           animations: {
                            viewController.view.x = -viewController.view.width
                            viewController.ctxs.transitionView?.backgroundColor = NX.transitionInoutBackgroundColor
            }, completion:{ (completed) in
                viewController.ctxs.transitionView?.removeFromSuperview()
                viewController.ctxs.transitionView = nil
                viewController.ctxs.superviewController = nil
                
                parentViewController.ctxs.subviewControllers.remove(at: index)
                self.view.isUserInteractionEnabled = true
                if let vc = self.currentViewController as? NXViewController {
                    vc.updateNavigationBar()
                }
                self.ctxs.semaphore.signal()
            })
        }
        else if viewController.ctxs.orientation == .right {
            self.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: animated ? self.ctxs.duration:0.0,
                           delay: 0.0,
                           options: [.curveEaseInOut],
                           animations: {
                            viewController.view.x = viewController.view.width
                            viewController.ctxs.transitionView?.backgroundColor = NX.transitionInoutBackgroundColor
            }, completion:{ (completed) in
                viewController.ctxs.transitionView?.removeFromSuperview()
                viewController.ctxs.transitionView = nil
                viewController.ctxs.superviewController = nil
                
                parentViewController.ctxs.subviewControllers.remove(at: index)
                self.view.isUserInteractionEnabled = true
                if let vc = self.currentViewController as? NXViewController {
                    vc.updateNavigationBar()
                }
                self.ctxs.semaphore.signal()
            })
        }
        else if viewController.ctxs.orientation == .top {
            self.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: animated ? self.ctxs.duration:0.0,
                           delay: 0.0,
                           options: [.curveEaseInOut],
                           animations: {
                            viewController.view.y = -viewController.view.height
                            viewController.ctxs.transitionView?.backgroundColor = NX.transitionInoutBackgroundColor
            }, completion:{ (completed) in
                viewController.ctxs.transitionView?.removeFromSuperview()
                viewController.ctxs.transitionView = nil
                viewController.ctxs.superviewController = nil
                
                parentViewController.ctxs.subviewControllers.remove(at: index)
                self.view.isUserInteractionEnabled = true
                if let vc = self.currentViewController as? NXViewController {
                    vc.updateNavigationBar()
                }
                self.ctxs.semaphore.signal()
            })
        }
        else if viewController.ctxs.orientation == .bottom {
            self.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: animated ? self.ctxs.duration:0.0,
                           delay: 0.0,
                           options: [.curveEaseInOut],
                           animations: {
                            viewController.view.y = viewController.view.height
                            viewController.ctxs.transitionView?.backgroundColor = NX.transitionInoutBackgroundColor
            }, completion:{ (completed) in
                viewController.ctxs.transitionView?.removeFromSuperview()
                viewController.ctxs.transitionView = nil
                viewController.ctxs.superviewController = nil
                
                parentViewController.ctxs.subviewControllers.remove(at: index)
                self.view.isUserInteractionEnabled = true
                if let vc = self.currentViewController as? NXViewController {
                    vc.updateNavigationBar()
                }
                self.ctxs.semaphore.signal()
            })
        }
        else {
            self.ctxs.semaphore.signal()
        }
    }
    
    //移除栈中非栈顶的控制器
    @discardableResult
    open func skipViewController(_ vc:UIViewController?) -> Bool {
        guard let __vc = vc else {
            return false
        }
        self.viewControllers.removeAll { (__viewController) -> Bool in
            return __vc == __viewController
        }
        return true
    }
    
    //移除栈中非栈顶的控制器
    @discardableResult
    open func skipViewControllers(_ __viewControllers:[UIViewController]) -> Bool {
        self.viewControllers.removeAll { (__viewController) -> Bool in
            return __viewControllers.contains(__viewController)
        }
        return true
    }
    
    //返回当前可见的视图控制器[全屏带导航栏的]
    open var currentViewController : UIViewController? {
        //默认是栈顶视图控制器:如果没有栈视图控制器就不会有模态和自定义显示出来的
        guard var __returnViewController = self.topViewController else {
            return nil
        }
        
        if let showViewController = self.visibleViewController, showViewController != __returnViewController {
            //这种情况存在模态控制器
            __returnViewController = showViewController
            while __returnViewController.presentedViewController != nil {
                if let vc = __returnViewController.presentedViewController {
                    __returnViewController = vc
                }
            }
            return __returnViewController
        }
        else {
            //这种情况没有模态控制器
            if let vc = __returnViewController as? NXViewController {
                if let __vc = vc.ctxs.subviewControllers.last {
                    //先查找自定义加上去的视图控制器
                    return __vc
                }
                else if let __vc = __returnViewController as? NXToolViewController {
                    //再查找NXToolViewController中的
                    return __vc.selectedViewController
                }
            }
            return __returnViewController
        }
    }
    
    deinit {
        NX.print(NSStringFromClass(self.classForCoder))
    }
}

extension NXNavigationController {
    open class Associated {
        weak var owner : NXNavigationController? = nil
        public let semaphore = DispatchSemaphore(value: 1)
        open var duration : TimeInterval = 0.3
        
        open var willAppear : NX.Event<String, NXNavigationController>? = nil
        open var didAppear: NX.Event<String, NXNavigationController>? = nil
        open var willDisappear: NX.Event<String, NXNavigationController>? = nil
        open var didDisappear: NX.Event<String, NXNavigationController>? = nil
        
        ///初始化方法
        public init(){}
    }
}

open class NXWrappedNavigationController<C:UIViewController>: NXNavigationController {
    public let viewController = C()
    
    open override func initialize() {
        super.initialize()
        self.pushViewController(viewController, animated:false)
    }
}
