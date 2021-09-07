//
//  NXViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/8.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

open class NXViewController: UIViewController  {

    ///ctxs.index用于记录分页加载的索引，xyz备用
    public let ctxs = NXViewController.Association<Int>()
    
    ///导航栏
    open var naviView = NXNaviView(frame: CGRect(x: 0, y: 0, width: NXDevice.width, height: NXDevice.topOffset))
    
    ///内容视图，不会被导航栏覆盖
    open var contentView = UIView(frame: CGRect(x: 0, y: NXDevice.topOffset, width: NXDevice.width, height: NXDevice.height-NXDevice.topOffset))
    
    ///页面无内容时的加载动画
    open var animationView : NXAnimationWrappedView? = nil
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    ///子类中有需要在viewDidLoad之前的逻辑放在这个函数中，而不用重写构造函数
    open func setup() {
        NX.print(NSStringFromClass(self.classForCoder))
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
        
        self.contentView.frame = CGRect(x: 0, y: NXDevice.topOffset, width: self.view.w, height: self.view.h-NXDevice.topOffset)
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.backgroundColor = NX.contentViewBackgroundColor
        self.view.addSubview(self.contentView)
        
        
        if let __animationView = self.ctxs.animationViewClass?.init(frame: self.contentView.bounds) {
            self.animationView = __animationView
            self.contentView.addSubview(__animationView)
        }
        
        
        self.naviView.frame = CGRect(x: 0, y: 0, width: self.view.w, height: NXDevice.topOffset)
        self.naviView.autoresizingMask = [.flexibleWidth]
        self.naviView.controller = self
        self.naviView.separator.isHidden = self.ctxs.separator.isHidden
        self.naviView.separator.backgroundColor = self.ctxs.separator.backgroundColor.cgColor
        self.view.addSubview(self.naviView)
        self.naviView.updateSubviews("update", nil)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //更新状态栏样式
        self.updateNavigationBar()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //在这里回调告知新的视图控制器已经加载完毕，用于在某些特殊场景移除上一个页面
        if let callbackViewAppeared = self.ctxs.callbackViewAppeared {
            callbackViewAppeared()
            self.ctxs.callbackViewAppeared = nil
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //开始动画
    open func startAnimating(){
        guard let __animationView = self.animationView else {
            return
        }
        if self.ctxs.isEmpty {
            __animationView.superview?.bringSubviewToFront(__animationView)
            __animationView.startAnimating()
        }
    }
    
    //结束动画
    open func stopAnimating(_ isCompleted:Bool = true){
        self.animationView?.stopAnimating(isCompleted)
        if self.ctxs.isEmpty {
            self.ctxs.isEmpty = false
        }
    }
    
    //创建视图:父类不会自动调用
    open func setupSubviews(){
        
    }
    
    //更新视图：父类不会自动调用
    open func updateSubviews(_ action: String, _ value: [String:Any]?){
        
    }
    
    //更新导航栏：父类会自动调用
    open func updateNavigationBar() {
        if NX.isViewControllerBasedStatusBarAppearance == false {
            NX.UI.update(self.ctxs.statusBarStyle)
        }
        else if let superviewController = self.ctxs.superviewController {
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
        if self.ctxs.operation == .push {
            if let count = self.navigationController?.viewControllers.count, count > 1 {
                self.navigationController?.popViewController(animated: true)
            }
        }
        else if self.ctxs.operation == .present {
            self.dismiss(animated: true, completion: nil)
        }
        else if self.ctxs.operation == .overlay {
            if let naviController = self.ctxs.superviewController?.navigationController as? NXNavigationController {
                naviController.removeSubviewController(self, animated: true)
            }
        }
    }
    
    //返回按钮点击
    open func backBarAction(){
        self.close()
    }
    
    //开始网络请求：处理加载框的开启/关闭,网络异常,参数异常等情况
    open func request(_ action:String, _ value:Any?, _ completion: NX.Completion<String, Any?>? = nil){
    
    }
    
    //页面内的相关逻辑操作
    open func dispose(_ action:String, _ value:Any?, _ completion:NX.Completion<String, Any?>? = nil){
        
    }
    
    //是否支持通过重力感应自动转屏幕
    open func shouldAutorotate() -> Bool {
        return false
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        var currentValue = self.ctxs.statusBarStyle
        if let viewController =  self as? NXToolViewController, let selectedViewController = viewController.selectedViewController {
            currentValue = selectedViewController.ctxs.statusBarStyle
        }
        else if let viewController = self.ctxs.subviewControllers.last, viewController.ctxs.statusBarStyle != .none {
            currentValue = viewController.ctxs.statusBarStyle
        }
        
        if currentValue == NX.Bar.unspecified {
            return UIStatusBarStyle.default
        }
        else if currentValue == NX.Bar.light {
            return UIStatusBarStyle.lightContent
        }
        else if currentValue == NX.Bar.dark {
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
        return currentValue == NX.Bar.hidden
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.ctxs.orientationMask
    }
    
    override open func present(_ viewController: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if let viewController = viewController as? NXViewController {
            viewController.ctxs.operation = .present
        }
        super.present(viewController, animated: flag, completion: completion)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        NX.print(NSStringFromClass(self.classForCoder))
    }
}


extension NXViewController {
    open class Association<Index:NXInitialValue> {
        open var index = Index.initialValue ///用于记录当前正在请求或者展示的页面index，多用于分页加载
        open var next = Index.initialValue  ///用于记录下一页next，多用于分页加载
        open var reload = NXViewController.Reload.initialized///当前刷新状态
        
        open var isWrapped : Bool = false ///是否被其他UIViewController包装了，某些情况被包装的需要隐藏掉导航栏
        open var isEmpty : Bool = true ///页面是否为空，如有缓存数据则可置为false。false不用展示加载动画
        
        ///以下三个备用，可以使用的场景比如存储分段选择控件的selectedIndex
        open var x: Int = 0
        open var y: Int = 0
        open var z: Int = 0
        
        ///状态栏样式
        open var statusBarStyle = NX.Bar.dark
        open var statusBarHidden = false
        open var orientationMask = UIInterfaceOrientationMask.portrait
        
        ///空页面加载动画
        open var animationViewClass : NXAnimationWrappedView.Type? = NX.UI.AnimationClass
        
        ///页面加载完毕触发(触发后会强制置为nil)
        open var callbackViewAppeared: (() -> ())?
        ///是否允许手势返回：某些页面会设置不允许手势返回，采用block是因为可以在当前页面接收到右滑手势返回事件
        open var panRecognizer : ((String, UIPanGestureRecognizer) -> (Bool)) = {_, _ in return true}
        
        ///进行的什么操作
        open var operation = NXViewController.Operation.push
        ///从哪个方向载入
        open var oriention = NXViewController.Orientation.right
        ///转场动画过程中需要的容器视图
        open var transitionView: NXTransitionView?
        ///两级页面之间传递信息
        open var completion : NX.Completion<String, Any?>? = nil
        ///导航栏顶部的分割线
        public let separator = NX.Separator { (_, __sender) in
            __sender.insets = UIEdgeInsets.zero;
            __sender.isHidden = NX.UI.isSeparatorHidden;
            __sender.backgroundColor = NX.separatorColor;
        }
        ///覆盖的视图控制器
        public var subviewControllers = [NXViewController]()
        ///容器试图管理器
        public weak var superviewController : NXViewController? = nil
        
        ///初始化方法
        public init(){}
    }
    
    public enum Operation  {
        case push       //打开页面通过push方式打开的
        case present    //打开页面通过present方式打开的
        case overlay    //打开页面通过overlay方式打开的
    }
    
    public enum Orientation : Int {
        case top        //从顶部进入
        case left       //从左侧进入
        case bottom     //从底部进入
        case right      //从右侧进入
    }
    
    public enum Reload : Int {
        case initialized //初始状态
        case update      //下拉刷新
        case more        //上拉加载更多
    }
}


open class NXMixedViewController<C:UIViewController>: NXViewController {
    public let viewController = C()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.naviView.isHidden = true
        self.contentView.isHidden = true
        
        self.addChild(viewController)
        self.view.addSubview(viewController.view)
    }
}
