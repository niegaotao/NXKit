//
//  NXNavigationController.swift
//  NXKit
//
//  Created by niegaotao on 2018/5/8.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

open class NXNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    /// 全屏返回手势，默认开启全屏手势返回，如果要禁掉全屏手势返回，请在相应的控制器中执行如下代码即可
    public let panRecognizer = UIPanGestureRecognizer()
    /// 动画相关
    public let ctxs = NXNavigationController.Associated()
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.setup()
    }
    
    public override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        self.setup()
    }
    
    ///设置
    open func setup() {
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
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //在这里回调告知新的视图控制器已经加载完毕，用于在某些特殊场景移除上一个页面
        if let callbackViewAppeared = self.ctxs.callbackViewAppeared {
            callbackViewAppeared()
            self.ctxs.callbackViewAppeared = nil
        }
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
    
    
    /// 重写父类push方法
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        NX.log { return "class=\(viewController.self)"}
        if let viewController = viewController as? NXViewController {
            viewController.ctxs.operation = .push
            viewController.ctxs.oriention = .right
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    ///当push完成后回触发completion
    open func pushViewController(_ viewController: NXViewController, animated: Bool, completion:(() -> ())?){
        viewController.ctxs.callbackViewAppeared = completion
        self.pushViewController(viewController, animated: animated)
    }
    
    override open func present(_ viewController: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if let viewController = viewController as? NXViewController {
            viewController.ctxs.operation = .present
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
                return fromViewController.ctxs.allowsTransitionBack()
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
    open func showSubviewController(_ viewController: NXViewController, animated: Bool){
        //添加到的父视图控制器:必须栈顶的视图控制器
        guard let to = self.topViewController as? NXViewController else {return}
        
        ctxs.semaphore.wait()
        viewController.ctxs.operation = .overlay
        
        to.ctxs.subviewControllers.append(viewController)
        viewController.ctxs.superviewController = to
        
        viewController.view.frame = to.view.bounds
        viewController.view.backgroundColor = UIColor.clear
        
        viewController.ctxs.transitionView = NXTransitionView(frame: to.view.bounds, owner:viewController)
        viewController.ctxs.transitionView?.backgroundColor = NX.minAlphaOfColor
        to.view.addSubview(viewController.ctxs.transitionView!)
        viewController.ctxs.transitionView?.addSubview(viewController.view)
        
        if viewController.ctxs.oriention == .left {
            viewController.view.x = -to.view.w
            UIView.animate(withDuration: animated ? self.ctxs.duration : 0.0,
                           delay: 0.0,
                           options: [.curveEaseInOut],
                           animations: {
                            viewController.view.x = 0.0
                            viewController.ctxs.transitionView?.backgroundColor = NX.maxAlphaOfColor
            },completion: {(_) in
                self.ctxs.semaphore.signal()
            })
        }
        else if viewController.ctxs.oriention == .right {
            viewController.view.x = to.view.w
            UIView.animate(withDuration: animated ? self.ctxs.duration:0.0,
                           delay: 0.0,
                           options: [.curveEaseInOut],
                           animations: {
                            viewController.view.x = 0.0
                            viewController.ctxs.transitionView?.backgroundColor = NX.maxAlphaOfColor
            }, completion: {(_) in
                self.ctxs.semaphore.signal()
            })
        }
        else if viewController.ctxs.oriention == .top {
            viewController.view.y = -to.view.h
            UIView.animate(withDuration: animated ? self.ctxs.duration:0.0,
                           delay: 0.0,
                           options: [.curveEaseInOut],
                           animations: {
                            viewController.view.y = 0.0
                            viewController.ctxs.transitionView?.backgroundColor = NX.maxAlphaOfColor
            }, completion: {(_) in
                self.ctxs.semaphore.signal()
            })
        }
        else if viewController.ctxs.oriention == .bottom {
            viewController.view.y = to.view.h
            UIView.animate(withDuration: animated ? self.ctxs.duration:0.0,
                           delay: 0.0,
                           options: [.curveEaseInOut],
                           animations: {
                            viewController.view.y = 0.0
                            viewController.ctxs.transitionView?.backgroundColor = NX.maxAlphaOfColor
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
    open func removeSubviewController(_ viewController: NXViewController, animated: Bool){
        guard let parentViewController = viewController.ctxs.superviewController else {return}
        guard let index = parentViewController.ctxs.subviewControllers.lastIndex(of: viewController) else { return }
        self.ctxs.semaphore.wait()
        if viewController.ctxs.oriention == .left {
            self.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: animated ? self.ctxs.duration:0.0,
                           delay: 0.0,
                           options: [.curveEaseInOut],
                           animations: {
                            viewController.view.x = -viewController.view.w
                            viewController.ctxs.transitionView?.backgroundColor = NX.minAlphaOfColor
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
        else if viewController.ctxs.oriention == .right {
            self.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: animated ? self.ctxs.duration:0.0,
                           delay: 0.0,
                           options: [.curveEaseInOut],
                           animations: {
                            viewController.view.x = viewController.view.w
                            viewController.ctxs.transitionView?.backgroundColor = NX.minAlphaOfColor
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
        else if viewController.ctxs.oriention == .top {
            self.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: animated ? self.ctxs.duration:0.0,
                           delay: 0.0,
                           options: [.curveEaseInOut],
                           animations: {
                            viewController.view.y = -viewController.view.h
                            viewController.ctxs.transitionView?.backgroundColor = NX.minAlphaOfColor
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
        else if viewController.ctxs.oriention == .bottom {
            self.view.isUserInteractionEnabled = false
            UIView.animate(withDuration: animated ? self.ctxs.duration:0.0,
                           delay: 0.0,
                           options: [.curveEaseInOut],
                           animations: {
                            viewController.view.y = viewController.view.h
                            viewController.ctxs.transitionView?.backgroundColor = NX.minAlphaOfColor
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
        NX.log { return String(describing: self)}
    }
}

extension NXNavigationController {
    open class Associated {
        weak var owner : NXNavigationController? = nil
        public let semaphore = DispatchSemaphore(value: 1)
        open var callbackViewAppeared: (() -> ())?
        open var duration : TimeInterval = 0.3
        
        ///初始化方法
        public init(){}
    }
}

open class NXMixedNavigationController<C:UIViewController>: NXNavigationController {
    public let viewController = C()
    
    open override func setup() {
        super.setup()
        self.pushViewController(viewController, animated:false)
    }
}
