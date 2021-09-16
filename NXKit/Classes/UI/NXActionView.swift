//
//  NXActionView.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/31.
//  Copyright © 2018年 无码科技. All rights reserved.
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
        
        actionView.wrapped.header.frame.size = CGSize(width: NXDevice.width * 0.8, height: 80.0 + size.height)
        actionView.wrapped.header.separator.ats = NX.Ats.maxY
        actionView.wrapped.header.backgroundColor = NX.backgroundColor
        actionView.wrapped.header.isHidden = false
        
        actionView.wrapped.header.title.isHidden = false
        actionView.wrapped.header.title.value = (title.count > 0) ? title : "温馨提示"
        actionView.wrapped.header.title.frame = CGRect(x: 20, y: 20, width: actionView.wrapped.header.frame.width - 40, height: 30)
        actionView.wrapped.header.title.font = NX.font(17, true)
        
        actionView.wrapped.header.lhs.isHidden = true
        
        actionView.wrapped.header.center.isHidden = false
        actionView.wrapped.header.center.frame = CGRect(x: 20, y: 60, width: actionView.wrapped.header.frame.width - 40, height: size.height)
        actionView.wrapped.header.center.font = NX.font(15, false)
        actionView.wrapped.header.center.value = subtitle
        actionView.wrapped.header.center.isAttributed = true
        actionView.wrapped.header.center.numberOfLines = 0
        
        actionView.wrapped.header.rhs.isHidden = true
        
        //center
        actionView.wrapped.center.actions = actions
        
        //footer
        actionView.wrapped.footer.isHidden = true
        actionView.wrapped.footer.frame.size = CGSize.zero
        
        setup?("setup", actionView)
                
        actionView.updateSubviews(NXActionView.Key.Center.alert.rawValue, nil)
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
        return NXActionView.action(actions: __actions, header:(.none, ""), footer: (.footer(false, true, false), "取消"), setup: nil, completion: completion)
    }
    
    @discardableResult
    class public func action(actions: [NXAction], completion:NX.Completion<String, Int>?) -> NXActionView {
        return NXActionView.action(actions: actions, header:(.none, ""), footer: (.footer(false, true, false), "取消"), setup:nil, completion: completion)
    }
    
    @discardableResult
    class public func action(actions: [NXAction], header:NXActionView.Attachment, footer: NXActionView.Attachment, setup:NX.Completion<String, NXActionView>?, completion:NX.Completion<String, Int>?) -> NXActionView {
        
        let actionView = NXActionView(frame: UIScreen.main.bounds)
        //header
        
        if case .header(let lhs, let center, let rhs, let title) = header.enumeration {
            actionView.wrapped.header.isHidden = false
            actionView.wrapped.header.frame.size = CGSize(width: NXDevice.width, height: 60)
            actionView.wrapped.header.separator.ats = NX.Ats.maxY
            
            actionView.wrapped.header.lhs.isHidden = !rhs
            if actionView.wrapped.header.lhs.isHidden == false {
                actionView.wrapped.header.lhs.image = UIImage.image(image:NX.image(named:"icon-overlay-close.png"), color:NX.darkGrayColor)
            }
            
            actionView.wrapped.header.center.isHidden = !center
            if actionView.wrapped.header.center.isHidden == false {
                actionView.wrapped.header.center.value = header.title
            }
            
            actionView.wrapped.header.rhs.isHidden = !lhs
            if actionView.wrapped.header.rhs.isHidden == false {
                actionView.wrapped.header.rhs.value = "确定"
            }

            actionView.wrapped.header.title.isHidden = !title
        }
        else if case .whitespace = header.enumeration {
            actionView.wrapped.header.isHidden = false
            actionView.wrapped.header.frame.size = CGSize(width: NXDevice.width, height: 32)
            actionView.wrapped.header.separator.ats = NX.Ats.maxY
            
            actionView.wrapped.header.title.isHidden = true
            actionView.wrapped.header.lhs.isHidden = true
            actionView.wrapped.header.center.isHidden = true
            actionView.wrapped.header.rhs.isHidden = true
        }
        else if case .custom(let customView) = header.enumeration {
            actionView.wrapped.header.isHidden = false
            actionView.wrapped.header.frame.size = CGSize(width: NXDevice.width, height: customView.frame.size.height)
            actionView.wrapped.header.separator.ats = NX.Ats.maxY
            
            actionView.wrapped.header.title.isHidden = true
            actionView.wrapped.header.lhs.isHidden = true
            actionView.wrapped.header.center.isHidden = true
            actionView.wrapped.header.rhs.isHidden = true
            actionView.wrapped.header.customView = customView
        }
        else if case .none = header.enumeration {
            actionView.wrapped.header.isHidden = true
            actionView.wrapped.header.frame.size = CGSize(width: NXDevice.width, height: 0)
            actionView.wrapped.header.separator.ats = []
            
            actionView.wrapped.header.title.isHidden = true
            actionView.wrapped.header.lhs.isHidden = true
            actionView.wrapped.header.center.isHidden = true
            actionView.wrapped.header.rhs.isHidden = true
        }
        
        //center
        actionView.wrapped.center.actions = actions

        //footer
        actionView.wrapped.footer.isHidden = false
        actionView.wrapped.footer.separator.ats = []
        actionView.wrapped.footer.center.value = footer.title.count > 0 ? footer.title : "取消"
        if case .footer(let lhs, let center, let rhs) = footer.enumeration {
            actionView.wrapped.footer.frame.size = CGSize(width: NXDevice.width, height: 60+NXDevice.bottomOffset)
            actionView.wrapped.footer.title.isHidden = true
            actionView.wrapped.footer.lhs.isHidden = !lhs
            actionView.wrapped.footer.center.isHidden = !center
            actionView.wrapped.footer.center.frame = CGRect(x: 0, y: 0, width: NXDevice.width, height: 60)
            actionView.wrapped.footer.center.font = NX.font(17)
            actionView.wrapped.footer.center.color = NX.mainColor
            actionView.wrapped.footer.rhs.isHidden = !rhs
        }
        else if case .whitespace = footer.enumeration {
            actionView.wrapped.footer.frame.size = CGSize(width: NXDevice.width, height: 32.0+NXDevice.bottomOffset)
            actionView.wrapped.footer.title.isHidden = true
            actionView.wrapped.footer.lhs.isHidden = true
            actionView.wrapped.footer.center.isHidden = true
            actionView.wrapped.footer.rhs.isHidden = true
            
            actionView.wrapped.devide = 0.0
        }
        else if case .custom(let customView) = footer.enumeration {
            actionView.wrapped.footer.frame.size = CGSize(width: NXDevice.width, height: customView.frame.size.height+NXDevice.bottomOffset)
            actionView.wrapped.footer.title.isHidden = true
            actionView.wrapped.footer.lhs.isHidden = true
            actionView.wrapped.footer.center.isHidden = true
            actionView.wrapped.footer.rhs.isHidden = true
            actionView.wrapped.footer.customView = customView
        }
        else if case .none = footer.enumeration {
            actionView.wrapped.footer.frame.size = CGSize(width: NXDevice.width, height: NXDevice.bottomOffset)
            actionView.wrapped.footer.title.isHidden = true
            actionView.wrapped.footer.lhs.isHidden = true
            actionView.wrapped.footer.center.isHidden = true
            actionView.wrapped.footer.rhs.isHidden = true
            
            actionView.wrapped.devide = 0.0
        }
        
        setup?("setup", actionView)
        
        actionView.updateSubviews(NXActionView.Key.Footer.action.rawValue, nil)
        actionView.completion = completion
        actionView.open(animation: actionView.animation, completion: nil)
        return actionView
    }
}

extension NXActionView {
    public enum Key : String {
        public enum Center : String {
            case alert = "center.alert"             //中部弹框
            case customize = "center.customize"     //中部弹出自定义样式
        }
        public enum Footer : String {
            case action = "footer.action"           //底部弹出一横排的排列
            case mix = "footer.mix"                 //底部弹出混合式排列
            case customize = "footer.customize"     //底部弹出自定义样式
        }
        case unknown = "unknown"
    }
    
    open class Wrapped: NX.Rect {
        open var key = NXActionView.Key.Footer.action.rawValue
        open var header = NXActionView.Metadata()
        open var center = NXActionView.Metadata()
        open var footer = NXActionView.Metadata()
        open var devide = CGFloat(6.0) //底部分开的高度，默认是6pt(只有在底部高度>0的时候有效)
        open var max = NXDevice.height * 0.80
        open var isAnimation = true
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
        
        open class func center(_ wrapped:NXActionView.Wrapped) -> CGSize {
            let  metadata = wrapped.center
            var contentSize = CGSize(width: metadata.frame.width, height: 0)
            if wrapped.key == NXActionView.Key.Center.alert.rawValue {
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
            else if wrapped.key == NXActionView.Key.Footer.action.rawValue {
                for (index, action) in metadata.actions.enumerated() {
                    action.ctxs.width = metadata.frame.width;
                    action.appearance.separator.ats = (index == metadata.actions.count-1) ? []: .maxY;
                    
                    contentSize.height = contentSize.height + action.ctxs.height
                }
            }
            else if wrapped.key == NXActionView.Key.Footer.mix.rawValue {
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
            else if let __customView = metadata.customView {
                contentSize.height = __customView.frame.size.height
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

open class NXActionView: NXOverlay {
    public let wrapped = NXActionView.Wrapped()
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
        self.wrapped.key = action
        
        if self.wrapped.key.contains("center") {
            self.animation = NXOverlay.Animation.center.rawValue
            
            self.wrapped.size = CGSize(width: NXDevice.width * 0.8, height: 0.0)
            self.contentView.layer.cornerRadius = 8
            self.contentView.layer.masksToBounds = true
            self.contentView.backgroundColor = NX.backgroundColor
            self.backgroundView.isUserInteractionEnabled = false
        }
        else if self.wrapped.key.contains("footer"){
            self.animation = NXOverlay.Animation.footer.rawValue
            
            if self.wrapped.devide > 0 {
                self.contentView.backgroundColor = NX.contentViewBackgroundColor
            }
            else {
                self.contentView.backgroundColor = NX.backgroundColor
            }
            self.wrapped.size = CGSize(width: NXDevice.width * 1.0, height: 0.0)
        }
        
        self.wrapped.header.frame.size.width = self.wrapped.size.width
        self.wrapped.footer.frame.size.width = self.wrapped.size.width
        self.wrapped.center.frame.size.width = self.wrapped.size.width
        
        
        self.wrapped.center.frame.size.height = NXActionView.Metadata.center(self.wrapped).height
        self.wrapped.center.frame.size.height = min(self.wrapped.center.frame.height, self.wrapped.max - wrapped.header.frame.size.height - self.wrapped.footer.frame.height) //最优高度

        //1
        if self.wrapped.header.frame.size.height > 0 {
            self.wrapped.header.frame.origin = CGPoint(x: 0, y: 0)
            self.headerView.frame = self.wrapped.header.frame
            self.wrapped.size.height = self.wrapped.size.height + self.wrapped.header.frame.size.height
            
            self.headerView.updateSubviews("update",self.wrapped)
            self.headerView.isHidden = false
        }
        else{
            self.headerView.isHidden = true
        }
        
        //2
        if self.wrapped.center.frame.size.height > 0 {
            self.wrapped.center.frame.origin = CGPoint(x: 0, y: self.wrapped.size.height)
            self.centerView.frame = self.wrapped.center.frame
            self.wrapped.size.height = self.wrapped.size.height + self.wrapped.center.frame.size.height
            
            self.centerView.updateSubviews("update", self.wrapped)
            self.centerView.isHidden = false
        }
        else {
            self.centerView.isHidden = true
        }
        
        //3
        if self.wrapped.footer.frame.size.height > 0 {
            self.wrapped.size.height = self.wrapped.size.height + wrapped.devide
            
            self.wrapped.footer.frame.origin = CGPoint(x: 0, y: self.wrapped.size.height)
            self.footerView.frame = self.wrapped.footer.frame
            self.wrapped.size.height = self.wrapped.size.height + self.wrapped.footer.frame.size.height
            
            self.footerView.updateSubviews("update", self.wrapped)
            self.footerView.isHidden = false
        }
        else{
            self.footerView.isHidden = true
        }
        
        if self.wrapped.key.contains("center") {
            self.contentView.frame = CGRect(x: (self.frame.size.width - self.wrapped.size.width)/2.0, y: (self.frame.size.height-self.wrapped.size.height)/2.0, width: self.wrapped.size.width, height: self.wrapped.size.height)
        }
        else if self.wrapped.key.contains("footer"){
            self.contentView.frame = CGRect(x: (self.frame.size.width - self.wrapped.size.width)/2.0, y: self.frame.size.height-self.wrapped.size.height, width: self.wrapped.size.width, height: self.wrapped.size.height)
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
            guard let wrapped = value as? NXActionView.Wrapped else {
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
        private(set) var wrapped = NXActionView.Wrapped()
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
            self.contentView.register(NXActionViewCell.self, forCellWithReuseIdentifier: "NXActionViewCell")
            self.contentView.delaysContentTouches = false
        }
        
        open override func updateSubviews(_ action:String, _ value: Any?){
            guard let __wrapped = value as? NXActionView.Wrapped else {
                return
            }
            self.wrapped = __wrapped
            let metadata = __wrapped.center
            
            metadata.actions.forEach { (option) in
                if let cls = option.ctxs.cls, cls != NXActionViewCell.self {
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
            guard let wrapped = value as? NXActionView.Wrapped else {
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

