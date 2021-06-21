//
//  LEYViewController.swift
//  NXFoundation
//
//  Created by firelonely on 2018/5/8.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit


open class LEYViewController: UIViewController {
    ///ctxs.index用于记录分页加载的索引，xyz备用
    public let ctxs = LEYViewController.Associated()
    
    ///导航栏
    open var naviView = LEYNaviView(frame: CGRect(x: 0, y: 0, width: LEYDevice.width, height: LEYDevice.topOffset))
    
    ///内容视图，不会被导航栏覆盖
    open var contentView = UIView(frame: CGRect(x: 0, y: LEYDevice.topOffset, width: LEYDevice.width, height: LEYDevice.height-LEYDevice.topOffset))
    
    ///页面无内容时的加载动画
    open var animationView : LEYAnimationWrappedView? = nil
    
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

        self.view.backgroundColor = LEYApp.viewBackgroundColor
        
        self.contentView.frame = CGRect(x: 0, y: LEYDevice.topOffset, width: self.view.w, height: self.view.h-LEYDevice.topOffset)
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.backgroundColor = LEYApp.contentViewBackgroundColor
        self.view.addSubview(self.contentView)
        
        
        if let __animationView = self.ctxs.animationViewClass?.init(frame: self.contentView.bounds) {
            self.animationView = __animationView
            self.contentView.addSubview(__animationView)
        }
        
        
        self.naviView.frame = CGRect(x: 0, y: 0, width: self.view.w, height: LEYDevice.topOffset)
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
        if LEYApp.isViewControllerBasedStatusBarAppearance == false {
            LEYApp.Bar.update(self.ctxs.statusBarStyle)
        }
        else if let superviewController = self.ctxs.superviewController {
            if let viewController = superviewController as? LEYToolViewController, viewController.selectedViewController == self {
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
            if let naviController = self.ctxs.superviewController?.navigationController as? LEYNavigationController {
                naviController.removeSubviewController(self, animated: true)
            }
        }
    }
    
    //返回按钮点击
    open func backBarAction(){
        self.close()
    }
    
    //开始网络请求：处理加载框的开启/关闭,网络异常,参数异常等情况
    open func request(_ action:String, _ value:Any?, _ completion: LEYApp.Completion<String, Any?>? = nil){
    
    }
    
    //页面内的相关逻辑操作
    open func dispose(_ action:String, _ value:Any?, _ completion:LEYApp.Completion<String, Any?>? = nil){
        
    }
    
    //是否支持通过重力感应自动转屏幕
    open func shouldAutorotate() -> Bool {
        return false
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        var currentValue = self.ctxs.statusBarStyle
        if let viewController =  self as? LEYToolViewController, let selectedViewController = viewController.selectedViewController {
            currentValue = selectedViewController.ctxs.statusBarStyle
        }
        else if let viewController = self.ctxs.subviewControllers.last, viewController.ctxs.statusBarStyle != .none {
            currentValue = viewController.ctxs.statusBarStyle
        }
        
        if currentValue == LEYApp.Bar.Value.unspecified {
            return UIStatusBarStyle.default
        }
        else if currentValue == LEYApp.Bar.Value.light {
            return UIStatusBarStyle.lightContent
        }
        else if currentValue == LEYApp.Bar.Value.dark {
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

        if let viewController =  self as? LEYToolViewController, let selectedViewController = viewController.selectedViewController {
            currentValue = selectedViewController.ctxs.statusBarStyle
        }
        else if let viewController = self.ctxs.subviewControllers.last, viewController.ctxs.statusBarStyle != .none {
            currentValue = viewController.ctxs.statusBarStyle
        }
        return currentValue == LEYApp.Bar.Value.hidden
    }
    
    override open func present(_ viewController: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if let viewController = viewController as? LEYViewController {
            viewController.ctxs.operation = .present
        }
        super.present(viewController, animated: flag, completion: completion)
    }
    
    deinit {
        LEYApp.log { return String(describing: self)}
        NotificationCenter.default.removeObserver(self)
    }
}


extension LEYViewController {
    open class Associated {
        open var index : Int = 0 ///用于记录当前正在请求或者展示的页面index，多用于分页加载
        open var next : Int = 1  ///用于记录下一页的索引值
        public let reload = LEYViewController.Reload()///当前刷新状态
        
        ///是否被其他UIViewController包装了，某些情况被包装的需要隐藏掉导航栏
        open var isWrapped : Bool = false
        ///页面是否为空，如有缓存数据则可置为false。false不用展示加载动画
        open var isEmpty : Bool = true
        
        ///以下三个备用，可以使用的场景比如存储分段选择控件的selectedIndex
        open var x: Int = 0
        open var y: Int = 0
        open var z: Int = 0
        
        ///状态栏样式
        open var statusBarStyle = LEYApp.Bar.Value.dark
        
        ///空页面加载动画
        open var animationViewClass : LEYAnimationWrappedView.Type? = LEYApp.Animation.animationClass
        
        ///页面加载完毕触发(触发后会强制置为nil)
        open var callbackViewAppeared: (() -> ())?
        ///是否允许手势返回：某些页面会设置不允许手势返回，采用block是因为可以在当前页面接收到右滑手势返回事件
        open var allowsTransitionBack : (() -> (Bool)) = {return true}
        
        ///进行的什么操作
        open var operation = LEYViewController.Operation.push
        ///从哪个方向载入
        open var oriention = LEYViewController.Orientation.right
        ///转场动画过程中需要的容器视图
        open var transitionView: LEYTransitionView?
        ///两级页面之间传递信息
        open var completion : LEYApp.Completion<String, Any?>? = nil
        ///导航栏顶部的分割线
        public let separator = LEYApp.Separator { (_, __sender) in
            __sender.insets = UIEdgeInsets.zero
            __sender.isHidden = LEYApp.isSeparatorHidden
            __sender.backgroundColor = LEYApp.separatorColor
        }
        ///覆盖的视图控制器
        public var subviewControllers = [LEYViewController]()
        ///容器试图管理器
        public weak var superviewController : LEYViewController? = nil
        
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
    
    open class Reload : NSObject{
        open var index = ""//当前页面的id
        open var next = ""//如果有下一页，则表示下一页的id
        open var state = LEYViewController.Reload.State.update //初始值刷新状态
        open var isSupported = false
        
        public enum State : Int {
            case initialized //初始状态
            case update      //下拉刷新
            case more        //上拉加载更多
        }
    }
}


open class LEYMixedViewController<C:UIViewController>: LEYViewController {
    public let viewController = C()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.naviView.isHidden = true
        self.contentView.isHidden = true
        
        self.addChild(viewController)
        self.view.addSubview(viewController.view)
    }
}
