//
//  NXActionView.swift
//  NXKit
//
<<<<<<< HEAD
//  Created by niegaotao on 2021/5/31.
//  Copyright © 2018年 无码科技. All rights reserved.
=======
//  Created by niegaotao on 2020/5/31.
//  Copyright © 2020年 TIMESCAPE. All rights reserved.
>>>>>>> 54b3e71c2be9f4a23c8c9b48586689a860947b51
//

import UIKit

extension NXActionView {
    @discardableResult
    class public func alert(title: String, subtitle:String, actions:[String], completion:NX.Completion<String, Int>?) -> NXActionView {
        let __actions = actions.map { (title) -> NXAction in
            return NXAction(title:title, value: nil, completion: {(_, __action) in
                __action.asset.isHidden = true
                __action.title.isHidden = false
                if actions.count == 2 {
                    __action.ctxs.size = CGSize(width: NX.Association.size.width*0.5, height: NX.Association.size.height)
                    __action.title.frame = CGRect(x: 0, y: 0, width: __action.ctxs.width, height: __action.ctxs.height)
                }
                else {
                    __action.ctxs.size = CGSize(width: NX.Association.size.width, height: NX.Association.size.height)
                    __action.title.frame = CGRect(x: 0, y: 0, width: __action.ctxs.width, height: __action.ctxs.height)
                }
                __action.title.color = NX.darkBlackColor
                __action.title.font = NX.font(16, true)
                __action.title.textAlignment = .center
                __action.subtitle.isHidden = true
                __action.arrow.isHidden = true
            })
        }
        
        return NXActionView.alert(title: title, subtitle: subtitle, actions: __actions, setup:nil, completion: completion)
    }
    
    @discardableResult
    class public func alert(title: String, subtitle:String, actions:[NXAction], completion:NX.Completion<String, Int>?) -> NXActionView {
        return NXActionView.alert(title: title, subtitle: subtitle, actions: actions, setup: nil, completion: completion)
    }
    
    @discardableResult
    class public func alert(title: String, subtitle:String, actions:[NXAction], setup:NX.Completion<String, NXActionView>?, completion:NX.Completion<String, Int>?) -> NXActionView {
        for (_, action) in actions.enumerated() {
            if actions.count == 2 {
                action.ctxs.size = CGSize(width: NX.Association.size.width*0.5, height: NX.Association.size.height)
                action.title.frame = CGRect(x: 0, y: 0, width: action.ctxs.width, height: action.ctxs.height)
            }
            else {
                action.ctxs.size = CGSize(width: NX.Association.size.width, height: NX.Association.size.height)
                action.title.frame = CGRect(x: 0, y: 0, width: NX.Association.size.width, height: action.ctxs.height)
            }
        }
        
        /*
         空白：20
         title:20,20,actionView.wrapped.header.frame.width - 40, 30
         空白10
         center:20,60,actionView.wrapped.header.frame.width - 40, __height
         空白20
         */
        let actionView = NXActionView(frame: UIScreen.main.bounds)
        //header
        var size = subtitle.stringSize(font: NX.font(15, false), size: CGSize(width: NX.Association.size.width-40, height: NXDevice.height*0.6))
        size.height = ceil(max(20.0, size.height*1.25)) + 2.0
        
        actionView.ctxs.header.frame.size = CGSize(width: NXDevice.width * 0.8, height: 80.0 + size.height)
        actionView.ctxs.header.separator.ats = NX.Ats.maxY
        actionView.ctxs.header.backgroundColor = NX.backgroundColor
        actionView.ctxs.header.isHidden = false
        
        actionView.ctxs.header.title.isHidden = false
        actionView.ctxs.header.title.value = (title.count > 0) ? title : "温馨提示"
        actionView.ctxs.header.title.frame = CGRect(x: 20, y: 20, width: actionView.ctxs.header.frame.width - 40, height: 30)
        actionView.ctxs.header.title.font = NX.font(17, true)
        
        actionView.ctxs.header.lhs.isHidden = true
        
        actionView.ctxs.header.center.isHidden = false
        actionView.ctxs.header.center.frame = CGRect(x: 20, y: 60, width: actionView.ctxs.header.frame.width - 40, height: size.height)
        actionView.ctxs.header.center.font = NX.font(15, false)
        actionView.ctxs.header.center.value = subtitle
        actionView.ctxs.header.center.isAttributed = true
        actionView.ctxs.header.center.numberOfLines = 0
        
        actionView.ctxs.header.rhs.isHidden = true
        
        //center
        actionView.ctxs.center.actions = actions
        
        //footer
        actionView.ctxs.footer.isHidden = true
        actionView.ctxs.footer.frame.size = CGSize.zero
        
        setup?("setup", actionView)
                
        actionView.updateSubviews(NXActionView.Key.alert.rawValue, nil)
        actionView.completion = completion
        actionView.open(animation: actionView.animation, completion: nil)
        return actionView
    }
    
    @discardableResult
    class public func action(actions: [String], completion:NX.Completion<String, Int>?) -> NXActionView {
        let __actions = actions.map { (title) -> NXAction in
            return NXAction(title:title, value: nil, completion: { (_,  __action) in
                __action.asset.isHidden = true
                __action.title.isHidden = false
                __action.subtitle.isHidden = true
            })
        }
        return NXActionView.action(actions: __actions, header:(.none, ""), footer: (.footer(true, false, true), "取消"), initialize: nil, completion: completion)
    }
    
    @discardableResult
    class public func action(actions: [NXAction], completion:NX.Completion<String, Int>?) -> NXActionView {
        return NXActionView.action(actions: actions, header:(.none, ""), footer: (.footer(true, false, true), "取消"), initialize:nil, completion: completion)
    }
    
    @discardableResult
    class public func action(actions: [NXAction], header:NXActionView.Attachment, footer: NXActionView.Attachment, initialize:NX.Completion<String, NXActionView>?, completion:NX.Completion<String, Int>?) -> NXActionView {
        
        let actionView = NXActionView(frame: UIScreen.main.bounds)
        //header
        
        if case .header(let lhs, let center, let rhs, let title) = header.enumeration {
            actionView.ctxs.header.isHidden = false
            actionView.ctxs.header.frame.size = CGSize(width: NXDevice.width, height: 60)
            actionView.ctxs.header.separator.ats = NX.Ats.maxY
            
            actionView.ctxs.header.lhs.isHidden = lhs
            if actionView.ctxs.header.lhs.isHidden == false {
                actionView.ctxs.header.lhs.image = UIImage.image(image:NX.image(named:"icon-overlay-close.png"), color:NX.darkGrayColor)
            }
            
            actionView.ctxs.header.center.isHidden = center
            if actionView.ctxs.header.center.isHidden == false {
                actionView.ctxs.header.center.value = header.title
            }
            
            actionView.ctxs.header.rhs.isHidden = rhs
            if actionView.ctxs.header.rhs.isHidden == false {
                actionView.ctxs.header.rhs.value = "确定"
            }

            actionView.ctxs.header.title.isHidden = title
        }
        else if case .whitespace = header.enumeration {
            actionView.ctxs.header.isHidden = false
            actionView.ctxs.header.frame.size = CGSize(width: NXDevice.width, height: 32)
            actionView.ctxs.header.separator.ats = NX.Ats.maxY
            
            actionView.ctxs.header.title.isHidden = true
            actionView.ctxs.header.lhs.isHidden = true
            actionView.ctxs.header.center.isHidden = true
            actionView.ctxs.header.rhs.isHidden = true
        }
        else if case .custom(let customView) = header.enumeration {
            actionView.ctxs.header.isHidden = false
            actionView.ctxs.header.frame.size = CGSize(width: NXDevice.width, height: customView.frame.size.height)
            actionView.ctxs.header.separator.ats = NX.Ats.maxY
            
            actionView.ctxs.header.title.isHidden = true
            actionView.ctxs.header.lhs.isHidden = true
            actionView.ctxs.header.center.isHidden = true
            actionView.ctxs.header.rhs.isHidden = true
            actionView.ctxs.header.customView = customView
        }
        else if case .none = header.enumeration {
            actionView.ctxs.header.isHidden = true
            actionView.ctxs.header.frame.size = CGSize(width: NXDevice.width, height: 0)
            actionView.ctxs.header.separator.ats = []
            
            actionView.ctxs.header.title.isHidden = true
            actionView.ctxs.header.lhs.isHidden = true
            actionView.ctxs.header.center.isHidden = true
            actionView.ctxs.header.rhs.isHidden = true
        }
        
        //center
        actionView.ctxs.center.actions = actions

        //footer
        actionView.ctxs.footer.isHidden = false
        actionView.ctxs.footer.separator.ats = []
        actionView.ctxs.footer.center.value = footer.title.count > 0 ? footer.title : "取消"
        if case .footer(let lhs, let center, let rhs) = footer.enumeration {
            actionView.ctxs.footer.frame.size = CGSize(width: NXDevice.width, height: 60+NXDevice.bottomOffset)
            actionView.ctxs.footer.title.isHidden = true
            actionView.ctxs.footer.lhs.isHidden = lhs
            actionView.ctxs.footer.center.isHidden = center
            actionView.ctxs.footer.center.frame = CGRect(x: 0, y: 0, width: NXDevice.width, height: 60)
            actionView.ctxs.footer.center.font = NX.font(17)
            actionView.ctxs.footer.center.color = NX.mainColor
            actionView.ctxs.footer.rhs.isHidden = rhs
        }
        else if case .whitespace = footer.enumeration {
            actionView.ctxs.footer.frame.size = CGSize(width: NXDevice.width, height: 32.0+NXDevice.bottomOffset)
            actionView.ctxs.footer.title.isHidden = true
            actionView.ctxs.footer.lhs.isHidden = true
            actionView.ctxs.footer.center.isHidden = true
            actionView.ctxs.footer.rhs.isHidden = true
            
            actionView.ctxs.devide = 0.0
        }
        else if case .custom(let customView) = footer.enumeration {
            actionView.ctxs.footer.frame.size = CGSize(width: NXDevice.width, height: customView.frame.size.height+NXDevice.bottomOffset)
            actionView.ctxs.footer.title.isHidden = true
            actionView.ctxs.footer.lhs.isHidden = true
            actionView.ctxs.footer.center.isHidden = true
            actionView.ctxs.footer.rhs.isHidden = true
            actionView.ctxs.footer.customView = customView
        }
        else if case .none = footer.enumeration {
            actionView.ctxs.footer.frame.size = CGSize(width: NXDevice.width, height: NXDevice.bottomOffset)
            actionView.ctxs.footer.title.isHidden = true
            actionView.ctxs.footer.lhs.isHidden = true
            actionView.ctxs.footer.center.isHidden = true
            actionView.ctxs.footer.rhs.isHidden = true
            
            actionView.ctxs.devide = 0.0
        }
        
        initialize?("initialize", actionView)
        
        actionView.updateSubviews(NXActionView.Key.action.rawValue, nil)
        actionView.completion = completion
        actionView.open(animation: actionView.animation, completion: nil)
        return actionView
    }
}

extension NXActionView {
    public enum Key : String {
        case alert = "center.alert"             //中部弹框
        case action = "footer.action"           //底部弹出一横排的排列
        case mix = "footer.mix"                 //底部弹出混合式排列
        case unknown = "unknown"
    }
    
    open class Metadata : NX.View {
        public let title = NX.Attribute { (_, __sender) in
            __sender.textAlignment = .center
            __sender.font = NX.font(18, true)
            __sender.color = NX.darkBlackColor
            __sender.backgroundColor = .clear
        }
        
        public let lhs = NX.Attribute { (_, __sender) in
            __sender.frame = CGRect(x: 16, y: (60-44)/2, width: 84, height: 44)
            __sender.font = NX.font(16, false)
            __sender.color = NX.mainColor
            __sender.textAlignment = .left
            __sender.backgroundColor = .clear
        }
        
        public let center = NX.Attribute { (_, __sender) in
            __sender.frame = CGRect(x: 100, y: (60-44)/2, width: NXDevice.width-200, height: 44)
            __sender.font = NX.font(16, true)
            __sender.color = NX.darkBlackColor
            __sender.textAlignment = .center
            __sender.backgroundColor = .clear
        }
        
        public let rhs = NX.Attribute { (_, __sender) in
            __sender.frame = CGRect(x: NXDevice.width-16-84, y: (60-44)/2, width: 84, height: 44)
            __sender.color = NX.mainColor
            __sender.textAlignment = .right
            __sender.backgroundColor = .clear
        }
        
        public let separator = NX.Separator{(_, __attribute) in
            
        }
        
        open var customView: UIView? = nil
        
        open var actions = [NXAction]()
        open var insets = UIEdgeInsets.zero
        
        open class func center(_ wrapped:NXActionViewAttributes) -> CGSize {
            let  metadata = wrapped.center
            var contentSize = CGSize(width: metadata.frame.width, height: 0)
            if let __customView = metadata.customView {
                contentSize.height = __customView.frame.size.height
            }
            else if wrapped.key == NXActionView.Key.alert.rawValue {
                if metadata.actions.count == 2 {
                    for index in 0...1 {
                        let action = metadata.actions[index]
                        action.ctxs.width = metadata.frame.width * 0.5
                        action.title.frame = CGRect(x: 0, y: 0, width: action.ctxs.width, height: action.ctxs.height)
                        action.appearance.isHighlighted = true
                        action.appearance.isEnabled = true
                        if(index == 0){
                            action.appearance.separator.ats = .maxX
                        }
                        else{
                            action.appearance.separator.ats = []
                        }
                        contentSize.height = action.ctxs.height
                    }
                }
                else {
                    //1个/3个/4个
                    for index in 0...metadata.actions.count-1 {
                        let action = metadata.actions[index]
                        action.ctxs.width = metadata.frame.width
                        action.title.frame = CGRect(x: 0, y: 0, width: action.ctxs.width, height: action.ctxs.height)
                        action.appearance.isHighlighted = true
                        action.appearance.isEnabled = true
                        action.appearance.separator.ats = (index == metadata.actions.count-1) ? [] : .maxY;
                        
                        contentSize.height = contentSize.height + action.ctxs.height
                    }
                }
                wrapped.isAnimation = false
            }
            else if wrapped.key == NXActionView.Key.action.rawValue {
                for (index, action) in metadata.actions.enumerated() {
                    action.ctxs.width = metadata.frame.width;
                    action.appearance.separator.ats = (index == metadata.actions.count-1) ? []: .maxY;
                    
                    contentSize.height = contentSize.height + action.ctxs.height
                }
            }
            else if wrapped.key == NXActionView.Key.mix.rawValue {
                var offsetValue : (x:CGFloat, y:CGFloat, max:CGFloat) = (0,0,0)
                for (idx, action) in metadata.actions.enumerated() {
                    if offsetValue.x + action.ctxs.width <= metadata.frame.width {
                        //可以排在同一行
                        offsetValue.x = offsetValue.x + action.ctxs.width
                        if offsetValue.max < action.ctxs.height {
                            offsetValue.max = action.ctxs.height
                        }
                    }
                    else {
                        //新开一行
                        offsetValue.y = offsetValue.y + offsetValue.max
                        
                        offsetValue.x = action.ctxs.width
                        offsetValue.max = action.ctxs.height
                    }
                    if idx == metadata.actions.count - 1 {
                        offsetValue.y = offsetValue.y + offsetValue.max
                    }
                }
                contentSize.height = contentSize.height + offsetValue.y
            }
            else {
                contentSize.height = 0.0
            }
            contentSize.height = contentSize.height + metadata.insets.top + metadata.insets.bottom
            return contentSize
        }
    }
    
    public enum Enumeration {
        case header(_ lhs:Bool, _ center:Bool, _ rhs:Bool, _ title:Bool)
        case footer(_ lhs:Bool, _ center:Bool, _ rhs:Bool)
        case whitespace                                //视图存在，但是没有任何需要展示的信息
        case custom(_ customView:UIView)             //定制
        case none                                   //无底部
    }
    public typealias Attachment = (enumeration:NXActionView.Enumeration, title:String)
}

open class NXActionViewAttributes: NXOverlayAttributes {
    open var key = NXActionView.Key.action.rawValue
    open var header = NXActionView.Metadata()
    open var center = NXActionView.Metadata()
    open var footer = NXActionView.Metadata()
    open var devide = CGFloat(6.0) //底部分开的高度，默认是6pt(只有在底部高度>0的时候有效)
    open var max = NXDevice.height * 0.80
    open var isAnimation = true
}

open class NXActionView: NXOverlay {
    public let ctxs = NXActionViewAttributes()
    public let headerView = NXActionView.HeaderView(frame:CGRect.zero)
    public let centerView = NXActionView.CenterView(frame:CGRect.zero)
    public let footerView = NXActionView.FooterView(frame:CGRect.zero)
    
    open override func setupSubviews() {
        super.setupSubviews()
        
        //0.背景
        self.backgroundView.setupEvents([.touchUpInside], action: { [weak self] (event, sender) in
            guard let __weakself = self else { return }
            __weakself.close(animation: __weakself.animation, completion: { (isCompleted) in
                __weakself.closeCompletion?("background", nil)
            })
        })
                
        //1.头部
        self.headerView.isHidden = true
        self.headerView.lhsView.setupEvents([.touchUpInside]) {[weak self] (e, v) in
            guard let __weakself = self else { return }
            __weakself.close(animation: __weakself.animation, completion: {(_ isCompleted) in
                __weakself.closeCompletion?("header.lhs", nil)
            })
        }
        self.headerView.rhsView.setupEvents([.touchUpInside]) {[weak self] (e, v) in
            guard let __weakself = self else { return }
            __weakself.close(animation: __weakself.animation, completion: {(_ isCompleted) in
                __weakself.closeCompletion?("header.rhs", nil)
            })
        }
        self.contentView.addSubview(self.headerView)
        
        //2.中间
        self.centerView.isHidden = true
        self.centerView.completion = {[weak self] (_ action:NXAction, _ index: Int) in
            guard let __weakself = self else { return }
            if action.appearance.isCloseable {
                __weakself.close(animation: __weakself.animation, completion: { (isCompleted) in
                    __weakself.completion?("", index)
                })
            }
            else {
                __weakself.completion?("", index)
            }
        }
        self.contentView.addSubview(self.centerView)
        
        //3.脚部
        self.footerView.isHidden = true
        self.footerView.lhsView.setupEvents([.touchUpInside]) { [weak self] (e, v) in
            guard let __weakself = self else { return }
            __weakself.close(animation: __weakself.animation, completion: {(_ isCompleted) in
                __weakself.closeCompletion?("footer.lhs", nil)
            })
        }
        self.footerView.centerView.setupEvents([.touchUpInside]) {[weak self] (e, v) in
            guard let __weakself = self else { return }
            __weakself.close(animation: __weakself.animation, completion: {(_ isCompleted) in
                __weakself.closeCompletion?("footer.center", nil)
            })
        }
        self.footerView.rhsView.setupEvents([.touchUpInside]) {[weak self] (e, v) in
            guard let __weakself = self else { return }
            __weakself.close(animation: __weakself.animation, completion: {(_ isCompleted) in
                __weakself.closeCompletion?("footer.rhs", nil)
            })
        }
        self.contentView.addSubview(self.footerView)
    }
    
    open override func updateSubviews(_ action: NXActionView.Key.RawValue, _ value: Any?) {
        self.ctxs.key = action
        
        if self.ctxs.key.contains("center") {
            self.animation = NXOverlay.Animation.center.rawValue
            
            self.ctxs.size = CGSize(width: NXDevice.width * 0.8, height: 0.0)
            self.contentView.layer.cornerRadius = 8
            self.contentView.layer.masksToBounds = true
            self.contentView.backgroundColor = NX.backgroundColor
            self.backgroundView.isUserInteractionEnabled = false
        }
        else if self.ctxs.key.contains("footer"){
            self.animation = NXOverlay.Animation.footer.rawValue
            
            if self.ctxs.devide > 0 {
                self.contentView.backgroundColor = NX.contentViewBackgroundColor
            }
            else {
                self.contentView.backgroundColor = NX.backgroundColor
            }
            self.ctxs.size = CGSize(width: NXDevice.width * 1.0, height: 0.0)
        }
        
        self.ctxs.header.frame.size.width = self.ctxs.size.width
        self.ctxs.footer.frame.size.width = self.ctxs.size.width
        self.ctxs.center.frame.size.width = self.ctxs.size.width
        
        
        self.ctxs.center.frame.size.height = NXActionView.Metadata.center(self.ctxs).height
        self.ctxs.center.frame.size.height = min(self.ctxs.center.frame.height, self.ctxs.max - ctxs.header.frame.size.height - self.ctxs.footer.frame.height) //最优高度

        //1
        if self.ctxs.header.frame.size.height > 0 {
            self.ctxs.header.frame.origin = CGPoint(x: 0, y: 0)
            self.headerView.frame = self.ctxs.header.frame
            self.ctxs.size.height = self.ctxs.size.height + self.ctxs.header.frame.size.height
            
            self.headerView.updateSubviews("update",self.ctxs)
            self.headerView.isHidden = false
        }
        else{
            self.headerView.isHidden = true
        }
        
        //2
        if self.ctxs.center.frame.size.height > 0 {
            self.ctxs.center.frame.origin = CGPoint(x: 0, y: self.ctxs.size.height)
            self.centerView.frame = self.ctxs.center.frame
            self.ctxs.size.height = self.ctxs.size.height + self.ctxs.center.frame.size.height
            
            self.centerView.updateSubviews("update", self.ctxs)
            self.centerView.isHidden = false
        }
        else {
            self.centerView.isHidden = true
        }
        
        //3
        if self.ctxs.footer.frame.size.height > 0 {
            self.ctxs.size.height = self.ctxs.size.height + ctxs.devide
            
            self.ctxs.footer.frame.origin = CGPoint(x: 0, y: self.ctxs.size.height)
            self.footerView.frame = self.ctxs.footer.frame
            self.ctxs.size.height = self.ctxs.size.height + self.ctxs.footer.frame.size.height
            
            self.footerView.updateSubviews("update", self.ctxs)
            self.footerView.isHidden = false
        }
        else{
            self.footerView.isHidden = true
        }
        
        if self.ctxs.key.contains("center") {
            self.contentView.frame = CGRect(x: (self.frame.size.width - self.ctxs.size.width)/2.0, y: (self.frame.size.height-self.ctxs.size.height)/2.0, width: self.ctxs.size.width, height: self.ctxs.size.height)
        }
        else if self.ctxs.key.contains("footer"){
            self.contentView.frame = CGRect(x: (self.frame.size.width - self.ctxs.size.width)/2.0, y: self.frame.size.height-self.ctxs.size.height, width: self.ctxs.size.width, height: self.ctxs.size.height)
        }
    }
}

extension NXActionView {
    open class HeaderView : NXHeaderView {
        open var titleView = UILabel(frame: CGRect.zero)
        
        open override func setupSubviews() {
            super.setupSubviews()
            
            lhsView.layer.masksToBounds = true
            centerView.layer.masksToBounds = true
            rhsView.layer.masksToBounds = true
            
            titleView.isHidden = true
            titleView.textAlignment = .center
            titleView.font = NX.font(18, true)
            titleView.numberOfLines = 1
            titleView.textColor = NX.darkBlackColor
            titleView.layer.masksToBounds = true
            self.addSubview(titleView)
        }
        
        open override func updateSubviews(_ action:String, _ value: Any?){
            guard let wrapped = value as? NXActionViewAttributes else {
                return
            }
            let metadata = wrapped.header
            
            self.backgroundColor = metadata.backgroundColor
            self.frame.size.height = metadata.frame.size.height
            
            if let __customView = metadata.customView {
                __customView.isHidden = false
                self.addSubview(__customView)
            }
            
            NX.View.update(metadata.title, self.titleView)
            NX.View.update(metadata.lhs, self.lhsView)
            NX.View.update(metadata.center, self.centerView)
            NX.View.update(metadata.rhs, self.rhsView)
            
            if metadata.separator.ats == NX.Ats.maxY {
                self.setupSeparator(color: metadata.separator.backgroundColor, ats: .maxY)
                self.association?.separator?.isHidden = false
            }
            else{
                self.association?.separator?.isHidden = true
            }
        }
    }
}

extension NXActionView {
    open class CenterView : NXCView<NXCollectionView>, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        private(set) var wrapped = NXActionViewAttributes()
        open var completion : NX.Completion<NXAction, Int>? = nil
        
        open override func setupSubviews() {
            super.setupSubviews()
            
            self.contentView.frame = self.bounds
            self.contentView.wrapped?.minimumLineSpacing = 0.0
            self.contentView.wrapped?.minimumInteritemSpacing = 0.0
            self.contentView.wrapped?.scrollDirection = .vertical
            self.contentView.wrapped?.sectionInset = UIEdgeInsets.zero
            self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.contentView.backgroundColor = NX.backgroundColor
            self.contentView.delaysContentTouches = false
        }
        
        open override func updateSubviews(_ action:String, _ value: Any?){
            guard let __wrapped = value as? NXActionViewAttributes else {
                return
            }
            self.wrapped = __wrapped
            let metadata = __wrapped.center
            
            metadata.actions.forEach { (option) in
                if let cls = option.ctxs.cls as? NXCollectionViewCell.Type {
                    self.contentView.register(cls, forCellWithReuseIdentifier: option.ctxs.reuse)
                }
            }
            self.contentView.dataSource = self
            self.contentView.delegate = self
            
            if let __customView = metadata.customView {
                __customView.isHidden = false
                self.addSubview(__customView)
                self.contentView.isHidden = true
            }
            else{
                self.contentView.isHidden = false
                self.contentView.contentInset = metadata.insets
                self.contentView.frame = self.bounds
                self.contentView.reloadData()
            }
        }
        
        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.wrapped.center.actions.count
        }
        
        public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
            let action = self.wrapped.center.actions[indexPath.item]
            return action.ctxs.size
        }
        
        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let action = self.wrapped.center.actions[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: action.ctxs.reuse, for: indexPath) as! NXActionViewCell
            cell.updateSubviews("update", action)
            return cell
        }
        
        public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if self.wrapped.isAnimation == true {
                var rotation = CATransform3DMakeTranslation(0, -2, 0.0)
                rotation.m43 = 1.0 / -600.0
                cell.layer.shadowColor = UIColor.black.cgColor
                cell.layer.shadowOffset = CGSize(width: 5, height: 5)
                cell.alpha = 0
                cell.layer.transform = rotation;
                
                UIView.animate(withDuration: 0.5, animations: {
                    cell.layer.transform = CATransform3DIdentity
                    cell.alpha = 1.0
                    cell.layer.shadowOffset = CGSize.zero
                }) { (finished) in
                    
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                    self.wrapped.isAnimation = false
                }
            }
        }
        
        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)
            
            let action = self.wrapped.center.actions[indexPath.item]
            if action.appearance.isEnabled == true {
                self.completion?(action, indexPath.item)
            }
        }
    }
}

extension NXActionView {
    open class FooterView : NXFooterView {
        open override func updateSubviews(_ action:String, _ value: Any?){
            guard let wrapped = value as? NXActionViewAttributes else {
                return
            }
            let metadata = wrapped.footer
            self.backgroundColor = metadata.backgroundColor
            self.frame.size.height = metadata.frame.size.height
            
            if let __customView = metadata.customView {
                __customView.isHidden = false
                self.addSubview(__customView)
            }
            
            NX.View.update(metadata.lhs, self.lhsView)
            NX.View.update(metadata.center, self.centerView)
            NX.View.update(metadata.rhs, self.rhsView)
            
            if metadata.separator.ats == NX.Ats.minY {
                self.setupSeparator(color: NX.separatorColor, ats: .minY)
                self.association?.separator?.isHidden = false
            }
            else{
                self.association?.separator?.isHidden = true
            }
        }
    }
}

