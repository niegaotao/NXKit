//
//  NXViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/8.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXViewController: UIViewController  {

    ///ctxs.index用于记录分页加载的索引，xyz备用
    public let ctxs = NXViewController.Association()
    
    ///导航栏
    open var navigationView = NXNavigationView(frame: CGRect(x: 0, y: 0, width: NX.width, height: NX.safeAreaInsets.top + 44.0))
    
    ///内容视图，不会被导航栏覆盖
    open var contentView = UIView(frame: CGRect(x: 0, y: NX.safeAreaInsets.top + 44.0, width: NX.width, height: NX.height-NX.safeAreaInsets.top - 44.0))
    
    ///页面无内容时的加载动画
    open var animationView = NX.AnimationClass.init(frame: CGRect.zero)
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    ///子类中有需要在viewDidLoad之前的逻辑放在这个函数中，而不用重写构造函数
    open func initialize() {
        NX.print("\(NSStringFromClass(self.classForCoder)), \(Unmanaged<AnyObject>.passUnretained(self as AnyObject).toOpaque())")
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = UIRectEdge.all
        if #available(iOS 11.0, *) {
        }
        else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = NX.viewBackgroundColor
        
        self.contentView.frame = CGRect(x: 0, y: NX.safeAreaInsets.top + 44.0, width: self.view.width, height: self.view.height-NX.safeAreaInsets.top - 44.0)
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.backgroundColor = NX.viewBackgroundColor
        self.view.addSubview(self.contentView)
        
        
        self.animationView.frame = self.contentView.bounds
        self.contentView.addSubview(self.animationView)
        
        
        self.navigationView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: NX.safeAreaInsets.top + 44.0)
        self.navigationView.autoresizingMask = [.flexibleWidth]
        self.navigationView.controller = self
        self.navigationView.separator.isHidden = self.ctxs.separator.isHidden
        self.navigationView.separator.backgroundColor = self.ctxs.separator.backgroundColor.cgColor
        self.view.addSubview(self.navigationView)
        self.navigationView.updateSubviews(nil)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.ctxs.lifecycleValue.contains(NX.Lifecycle.viewWillAppear){
            self.ctxs.lifecycleValue = self.ctxs.lifecycleValue.union(NX.Lifecycle.viewWillAppear)
            self.ctxs.lifecycle?(NX.Lifecycle.viewWillAppear, self)
        }
        
        //更新状态栏样式
        self.updateNavigationBar()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.ctxs.lifecycleValue.contains(NX.Lifecycle.viewDidAppear){
            self.ctxs.lifecycleValue = self.ctxs.lifecycleValue.union(NX.Lifecycle.viewDidAppear)
            self.ctxs.lifecycle?(NX.Lifecycle.viewDidAppear, self)
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !self.ctxs.lifecycleValue.contains(NX.Lifecycle.viewWillDisappear){
            self.ctxs.lifecycleValue = self.ctxs.lifecycleValue.union(NX.Lifecycle.viewWillDisappear)
            self.ctxs.lifecycle?(NX.Lifecycle.viewWillDisappear, self)
        }
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if !self.ctxs.lifecycleValue.contains(NX.Lifecycle.viewDidDisappear){
            self.ctxs.lifecycleValue = self.ctxs.lifecycleValue.union(NX.Lifecycle.viewDidDisappear)
            self.ctxs.lifecycle?(NX.Lifecycle.viewDidDisappear, self)
        }
    }
    
    //开始动画
    open func startAnimating(){
        if self.ctxs.isEmpty {
            self.animationView.superview?.bringSubviewToFront(self.animationView)
            self.animationView.startAnimating()
        }
    }
    
    //结束动画
    open func stopAnimating(_ isCompleted:Bool = true){
        self.animationView.stopAnimating(isCompleted)
        if self.ctxs.isEmpty {
            self.ctxs.isEmpty = false
        }
    }
    
    //创建视图:父类不会自动调用
    open func setupSubviews(){
        
    }
    
    //更新视图：父类不会自动调用
    open func updateSubviews(_ value: Any?){
        
    }
    
    //更新导航栏：父类会自动调用
    open func updateNavigationBar() {
        if let superviewController = self.ctxs.superviewController {
            if let viewController = superviewController as? NXToolViewController, viewController.selectedViewController == self {
                superviewController.updateNavigationBar()
            }
            else if superviewController.ctxs.subviewControllers.last == self {
                superviewController.updateNavigationBar()
            }
            else {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
        else {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    ///关闭当前控制器
    open func close(){
        if self.ctxs.navigation == .push {
            if let count = self.navigationController?.viewControllers.count, count > 1 {
                self.navigationController?.popViewController(animated: true)
            }
        }
        else if self.ctxs.navigation == .present {
            self.dismiss(animated: true, completion: nil)
        }
        else if self.ctxs.navigation == .overlay {
            if let navigationController = self.ctxs.superviewController?.navigationController as? NXNavigationController {
                navigationController.closeViewController(self, animated: true)
            }
        }
    }
    
    //返回按钮点击
    open func backBarAction(){
        self.close()
    }
    
    //开始网络请求：处理加载框的开启/关闭,网络异常,参数异常等情况
    open func request(_ operation:String, _ value:Any?, _ completion: NX.Event<String, Any?>? = nil){
    
    }
    
    //页面内的相关逻辑操作
    open func dispose(_ operation:String, _ value:Any?, _ completion:NX.Event<String, Any?>? = nil){
        
    }
    
    //是否支持通过重力感应自动转屏幕
    open func shouldAutorotate() -> Bool {
        return self.ctxs.shouldAutorotate
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        var currentValue = self.ctxs.statusBarStyle
        if let viewController = self as? NXToolViewController, let selectedViewController = viewController.selectedViewController {
            currentValue = selectedViewController.ctxs.statusBarStyle
        }
        else if let viewController = self.ctxs.subviewControllers.last, viewController.ctxs.statusBarStyle != .none {
            currentValue = viewController.ctxs.statusBarStyle
        }
        
        if currentValue == NX.StatusBarStyle.unspecified {
            return UIStatusBarStyle.default
        }
        else if currentValue == NX.StatusBarStyle.light {
            return UIStatusBarStyle.lightContent
        }
        else if currentValue == NX.StatusBarStyle.dark {
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    return UIStatusBarStyle.lightContent
                }
                else {
                    return UIStatusBarStyle.darkContent
                }
            }
            else{
                return UIStatusBarStyle.default
            }
        }
        return UIStatusBarStyle.lightContent
    }

    open override var prefersStatusBarHidden: Bool {
        var currentValue = self.ctxs.statusBarStyle

        if let viewController =  self as? NXToolViewController, let selectedViewController = viewController.selectedViewController {
            currentValue = selectedViewController.ctxs.statusBarStyle
        }
        else if let viewController = self.ctxs.subviewControllers.last, viewController.ctxs.statusBarStyle != .none {
            currentValue = viewController.ctxs.statusBarStyle
        }
        return currentValue == NX.StatusBarStyle.hidden
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.ctxs.orientationMask
    }
    
    override open func present(_ viewController: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if let viewController = viewController as? NXViewController {
            viewController.ctxs.navigation = .present
        }
        super.present(viewController, animated: flag, completion: completion)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        NX.print("\(NSStringFromClass(self.classForCoder)), \(Unmanaged<AnyObject>.passUnretained(self as AnyObject).toOpaque())")
    }
}


extension NXViewController {
    open class Association {
        open var index = 0 ///用于记录当前正在请求或者展示的页面index，多用于分页加载
        open var state = NX.Reload.initialized///当前刷新状态
        
        open var isWrapped : Bool = false ///是否被其他UIViewController包装了，某些情况被包装的需要隐藏掉导航栏
        open var isEmpty : Bool = true ///页面是否为空，如有缓存数据则可置为false。false不用展示加载动画
        
        ///以下三个备用，可以使用的场景比如存储分段选择控件的selectedIndex
        open var x: Int = 0
        open var y: Int = 0
        open var z: Int = 0
        
        open var lifecycleValue = NX.Lifecycle.initialized;
        open var lifecycle : NX.Event<NX.Lifecycle, NXViewController>? = nil;
        
        ///状态栏样式
        open var shouldAutorotate = false
        open var statusBarStyle = NX.StatusBarStyle.dark
        open var statusBarHidden = false
        open var orientationMask = UIInterfaceOrientationMask.portrait
        
        ///空页面加载动画
        open var animationViewClass = NX.AnimationClass
       
        ///是否允许手势返回：某些页面会设置不允许手势返回，采用block是因为可以在当前页面接收到右滑手势返回事件
        open var panRecognizer : ((String, UIPanGestureRecognizer) -> (Bool)) = {_, _ in return true}
        
        ///进行的什么操作
        open var navigation = NX.Navigation.push
        ///从哪个方向载入
        open var orientation = NX.Orientation.right
        ///转场动画过程中需要的容器视图
        open var transitionView: NXTransitionView?
        ///两级页面之间传递信息
        open var event : NX.Event<String, Any?>? = nil
        ///导航栏顶部的分割线
        public let separator = NX.Separator { (__sender) in
            __sender.insets = UIEdgeInsets.zero;
            __sender.isHidden = false;
            __sender.backgroundColor = NX.separatorColor;
        }
        ///覆盖的视图控制器
        public var subviewControllers = [NXViewController]()
        ///容器试图管理器
        public weak var superviewController : NXViewController? = nil
        
        ///初始化方法
        public init(){}
        
        static var index = 0
        static var next = 0
    }
}

open class NXWrappedViewController<C:UIViewController>: NXViewController {
    public let viewController = C()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationView.isHidden = true
        self.contentView.isHidden = true
        
        if let vc = self.viewController as? NXViewController {
            vc.ctxs.superviewController = self
        }
        self.addChild(viewController)
        self.view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}
