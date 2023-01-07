//
//  NXActionView.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/31.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

extension NXActionView {
    @discardableResult
    class public func alert(title: String, subtitle:String, actions:[String], completion:NX.Event<String, Int>?) -> NXActionView {
        let __actions = actions.map { (title) -> NXAbstract in
            return NXAbstract(title:title, value: nil, completion: {(__action) in
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
                __action.title.color = NX.blackColor
                __action.title.font = NX.font(16, .bold)
                __action.title.textAlignment = .center
                __action.subtitle.isHidden = true
                __action.arrow.isHidden = true
            })
        }
        
        return NXActionView.alert(title: title, subtitle: subtitle, actions: __actions, completion: completion)
    }
    
    @discardableResult
    class public func alert(title: String, subtitle:String, actions:[NXAbstract], completion:NX.Event<String, Int>?) -> NXActionView {

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
         title:20,20,actionView.ctxs.header.frame.width - 40, 30
         空白10
         center:20,60,actionView.ctxs.header.frame.width - 40, __height
         空白20
         */
        let actionView = NXActionView(frame: UIScreen.main.bounds)
        actionView.ctxs.key = NXActionView.Key.alert.rawValue
        actionView.ctxs.wrap(header: .header(true, false, true, false, title, subtitle))//header
        actionView.ctxs.wrap(center: .center(actions))//center
        actionView.ctxs.wrap(footer: .none)//footer
        actionView.updateSubviews("", nil)
        actionView.ctxs.completion = completion
        actionView.open(animation: actionView.ctxs.animation, completion: nil)
        return actionView
    }
    
    @discardableResult
    class public func action(actions: [String], completion:NX.Event<String, Int>?) -> NXActionView {
        let __actions = actions.map { (title) -> NXAbstract in
            return NXAbstract(title:title, value: nil, completion: { (__action) in
                __action.asset.isHidden = true
                __action.title.isHidden = false
                __action.subtitle.isHidden = true
            })
        }
        return NXActionView.action(actions: __actions, header:.none, footer: .footer(false,"取消"), completion: completion)
    }
    
    @discardableResult
    class public func action(actions: [NXAbstract], completion:NX.Event<String, Int>?) -> NXActionView {
        return NXActionView.action(actions: actions, header:.none, footer: .footer(false,"取消"), completion: completion)
    }
    
    @discardableResult
    class public func action(actions: [NXAbstract], header:NXActionView.Attachment, footer: NXActionView.Attachment, completion:NX.Event<String, Int>?) -> NXActionView {
        let actionView = NXActionView(frame: UIScreen.main.bounds)
        actionView.ctxs.key = NXActionView.Key.action.rawValue
        actionView.ctxs.wrap(header: header)//header
        actionView.ctxs.wrap(center: .center(actions))//center
        actionView.ctxs.wrap(footer: footer)//footer
        actionView.updateSubviews("", nil)
        actionView.ctxs.completion = completion
        actionView.open(animation: actionView.ctxs.animation, completion: nil)
        return actionView
    }
}

extension NXActionView {
    public enum Key : String {
        case alert = "center.alert"             //中部弹框
        case action = "footer.action"           //底部弹出一横排的排列
        case flow = "footer.flow"                //底部弹出混合式排列
        case unknown = "unknown"
    }
    
    public enum Attachment {
        case header(_ lhs:Bool, _ center:Bool, _ rhs:Bool, _ description:Bool, _ centerValue:String, _ descriptionValue:String)
        case center(_ actions:[NXAbstract])
        case footer(_ center:Bool, _ centerValue:String)
        
        case custom(_ customView:UIView)             //定制
        case whitespace(_ height:CGFloat)            //视图存在，但是没有任何需要展示的信息
        case none                                    //无底部
    }
}

public class NXActionViewAttributes: NXOverlayAttributes {
    public var key = NXActionView.Key.action.rawValue
    public let header = NXActionView.Header()
    public let center = NXActionView.Center()
    public let footer = NXActionView.Footer()
    public var devide = CGFloat(6.0) //底部分开的高度，默认是6pt(只有在底部高度>0的时候有效)
    public var max = NX.height * 0.70
    public var isAnimation = true
    
    public func wrap(header attachment:NXActionView.Attachment) {
        if self.key == NXActionView.Key.alert.rawValue {
            /*
             空白：20
             centerValue:20,20,actionView.ctxs.header.frame.width - 40, 30
             空白10
             descriptionValue:20,60,actionView.ctxs.header.frame.width - 40, __height
             空白20
             */
            if case .header(_, _, _, _, let centerValue, let descriptionValue) = attachment {
                //header
                self.header.frame.size = CGSize(width: NX.width * 0.8, height: 20)
                self.header.separator.ats = NX.Ats.maxY
                self.header.backgroundColor = NX.cellBackgroundColor
                self.header.isHidden = false
                //header-left
                self.header.lhs.isHidden = true
                
                //header-center
                self.header.center.isHidden = centerValue.count <= 0
                self.header.center.value = centerValue
                self.header.center.numberOfLines = 0
                self.header.center.lineSpacing = 3.0
                self.header.center.font = NX.font(17, .bold)
                if true {
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.lineSpacing = self.header.description.lineSpacing
                    self.header.description.attributedString = NSAttributedString(string: self.header.center.value,
                                                            attributes: [NSAttributedString.Key.font:self.header.center.font,
                                                                         NSAttributedString.Key.foregroundColor:self.header.center.color,
                                                                NSAttributedString.Key.paragraphStyle:paragraph])
                }
                
                if(centerValue.count > 0){
                    var sizeTitle = String.size(of: centerValue,
                                                size: CGSize(width: NX.Association.size.width-40, height: NX.height*0.6),
                                                font: self.header.center.font,
                                                style:{ paragraphStyle in
                        paragraphStyle.lineSpacing = 3.0
                    })
                    sizeTitle.height = ceil(Swift.max(24.0, sizeTitle.height)) + 2.0
                    self.header.center.frame = CGRect(x: 20, y: self.header.frame.size.height, width: self.header.frame.width - 40, height: sizeTitle.height)
                    self.header.frame.size.height = self.header.frame.size.height + sizeTitle.height
                }
                
                if(centerValue.count > 0 && descriptionValue.count > 0){
                    self.header.frame.size.height = self.header.frame.size.height + 10
                }
                
                //header-right
                self.header.rhs.isHidden = true
                
                //header-description
                self.header.description.isHidden = descriptionValue.count <= 0
                self.header.description.font = NX.font(15.5, .regular)
                self.header.description.value = descriptionValue
                self.header.description.lineSpacing = 2.5
                self.header.description.numberOfLines = 0
                if true {
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.lineSpacing = self.header.description.lineSpacing
                    self.header.description.attributedString = NSAttributedString(string: self.header.description.value,
                                                            attributes: [NSAttributedString.Key.font:self.header.description.font,
                                                                         NSAttributedString.Key.foregroundColor:self.header.description.color,
                                                                         NSAttributedString.Key.paragraphStyle:paragraph])
                }
                
                
                

                if descriptionValue.count > 0 {
                    var sizeSubtitle = String.size(of: descriptionValue,
                                                   size: CGSize(width: NX.Association.size.width-40, height: NX.height*0.6),
                                                   font: self.header.description.font,
                                                   style: { paragraphStyle in
                        paragraphStyle.lineSpacing = 2.5
                    })
                    sizeSubtitle.height = ceil(Swift.max(20.0, sizeSubtitle.height)) + 2.0
                    
                    self.header.description.frame = CGRect(x: 20, y: self.header.frame.size.height, width: self.header.frame.width - 40, height: sizeSubtitle.height)
                    self.header.frame.size.height = self.header.frame.size.height + sizeSubtitle.height
                }
                self.header.frame.size.height = self.header.frame.size.height + 20;
            }
        }
        else if self.key == NXActionView.Key.action.rawValue || self.key == NXActionView.Key.flow.rawValue {
            if case .header(let lhs, let center, let rhs, _, let centerValue, _) = attachment {
                self.header.isHidden = false
                self.header.frame.size = CGSize(width: NX.width, height: 60)
                self.header.separator.ats = NX.Ats.maxY
                self.header.backgroundColor = NX.cellBackgroundColor
                
                self.header.lhs.isHidden = lhs
                if self.header.lhs.isHidden == false {
                    self.header.lhs.color = NX.blackColor
                    self.header.lhs.image = NX.image(named:"icon-close.png", mode: .alwaysTemplate)
                }
                
                self.header.center.isHidden = center
                if self.header.center.isHidden == false {
                    self.header.center.value = centerValue
                }
                
                self.header.rhs.isHidden = rhs
                if self.header.rhs.isHidden == false {
                    self.header.lhs.color = NX.blackColor
                    self.header.rhs.value = "确定"
                }

                self.header.description.isHidden = true
            }
            else if case .custom(let customView) = attachment {
                self.header.isHidden = false
                self.header.frame.size = CGSize(width: NX.width, height: customView.frame.size.height)
                self.header.separator.ats = NX.Ats.maxY
                
                self.header.lhs.isHidden = true
                self.header.center.isHidden = true
                self.header.rhs.isHidden = true
                self.header.description.isHidden = true
                self.header.customView = customView
            }
            else if case .whitespace(let height) = attachment {
                self.header.isHidden = false
                self.header.frame.size = CGSize(width: NX.width, height: height)
                self.header.separator.ats = NX.Ats.maxY
                
                self.header.lhs.isHidden = true
                self.header.center.isHidden = true
                self.header.rhs.isHidden = true
                self.header.description.isHidden = true
            }
            else if case .none = attachment {
                self.header.isHidden = true
                self.header.frame.size = CGSize(width: NX.width, height: 0)
                self.header.separator.ats = []
                
                self.header.lhs.isHidden = true
                self.header.center.isHidden = true
                self.header.rhs.isHidden = true
                self.header.description.isHidden = true
            }
        }
        else if self.key == NXActionView.Key.unknown.rawValue {
            
        }
    }
    
    public func wrap(center attachment:NXActionView.Attachment) {
        if self.key == NXActionView.Key.alert.rawValue {
            if case .center(let actions) = attachment {
                self.center.actions = actions
                self.center.isHidden = false
            }
        }
        else if self.key == NXActionView.Key.action.rawValue || self.key == NXActionView.Key.flow.rawValue {
            if case .center(let actions) = attachment {
                self.center.actions = actions
                self.center.isHidden = false
            }
        }
        else if self.key == NXActionView.Key.unknown.rawValue {
            
        }
    }
    
    public func wrap(footer attachment:NXActionView.Attachment) {
        if self.key == NXActionView.Key.alert.rawValue {
            self.footer.isHidden = true
            self.footer.frame.size = CGSize.zero
        }
        else if self.key == NXActionView.Key.action.rawValue || self.key == NXActionView.Key.flow.rawValue {
            self.footer.separator.ats = []
            if case .footer(let center, let centerValue) = attachment {
                self.footer.backgroundColor = NX.barBackgroundColor
                self.footer.isHidden = false
                self.footer.frame.size = CGSize(width: NX.width, height: 60+NX.bottomOffset)
                self.footer.content.isHidden = center
                self.footer.content.frame = CGRect(x: 0, y: 0, width: NX.width, height: 60)
                self.footer.content.font = NX.font(17)
                self.footer.content.color = NX.mainColor
                self.footer.content.value = centerValue.count > 0 ? centerValue : "取消"
            }
            else if case .custom(let customView) = attachment {
                self.footer.frame.size = CGSize(width: NX.width, height: customView.frame.size.height+NX.bottomOffset)
                self.footer.content.isHidden = true
                self.footer.customView = customView
            }
            else if case .whitespace(let height) = attachment {
                self.footer.isHidden = true
                self.footer.frame.size = CGSize(width: NX.width, height: height+NX.bottomOffset)
                self.footer.content.isHidden = true
                self.devide = 0.0
            }
            else if case .none = attachment {
                self.footer.isHidden = true
                self.footer.frame.size = CGSize(width: NX.width, height: NX.bottomOffset)
                self.footer.content.isHidden = true
                self.devide = 0.0
            }
        }
        else if self.key == NXActionView.Key.unknown.rawValue {
            
        }
    }
}

public class NXActionView: NXAbstractOverlay<NXActionViewAttributes> {
    public let headerView = NXActionView.HeaderView(frame:CGRect.zero)
    public let centerView = NXActionView.CenterView(frame:CGRect.zero)
    public let footerView = NXActionView.FooterView(frame:CGRect.zero)
    
    public override func setupSubviews() {
        super.setupSubviews()
        
        //0.背景
        self.backgroundView.setupEvent(.touchUpInside, action: { [weak self] (event, sender) in
            guard let __weakself = self else { return }
            __weakself.close(animation: __weakself.ctxs.animation, completion: { (isCompleted) in
                __weakself.ctxs.close?("background", nil)
            })
        })
        
        self.contentView.backgroundColor = NX.backgroundColor

        
        //1.中间
        self.centerView.isHidden = true
        self.centerView.event = {[weak self] (_ index: Int, _ action:NXAbstract) in
            guard let __weakself = self else { return }
            if action.raw.isCloseable {
                __weakself.close(animation: __weakself.ctxs.animation, completion: { (isCompleted) in
                    __weakself.ctxs.completion?("", index)
                })
            }
            else {
                __weakself.ctxs.completion?("", index)
            }
        }
        self.contentView.addSubview(self.centerView)
                
        //2.头部
        self.headerView.isHidden = true
        self.headerView.lhsView.setupEvent(.touchUpInside) {[weak self] (e, v) in
            guard let __weakself = self else { return }
            __weakself.close(animation: __weakself.ctxs.animation, completion: {(_ isCompleted) in
                __weakself.ctxs.close?("header.lhs", nil)
            })
        }
        self.headerView.rhsView.setupEvent(.touchUpInside) {[weak self] (e, v) in
            guard let __weakself = self else { return }
            __weakself.close(animation: __weakself.ctxs.animation, completion: {(_ isCompleted) in
                __weakself.ctxs.close?("header.rhs", nil)
            })
        }
        self.contentView.addSubview(self.headerView)
        
        //3.脚部
        self.footerView.isHidden = true
        self.footerView.contentView.setupEvent(.touchUpInside) {[weak self] (e, v) in
            guard let __weakself = self else { return }
            __weakself.close(animation: __weakself.ctxs.animation, completion: {(_ isCompleted) in
                __weakself.ctxs.close?("footer.center", nil)
            })
        }
        self.contentView.addSubview(self.footerView)
    }
    
    open override func updateSubviews(_ action: String, _ value:Any?) {
        if self.ctxs.key.contains("center") {
            self.ctxs.animation = NXOverlay.Animation.center.rawValue
            
            self.ctxs.size = CGSize(width: NX.width * 0.8, height: 0.0)
            self.contentView.layer.cornerRadius = 8
            self.contentView.layer.masksToBounds = true
            self.contentView.backgroundColor = NX.backgroundColor
            self.backgroundView.isUserInteractionEnabled = false
        }
        else if self.ctxs.key.contains("footer") {
            self.ctxs.animation = NXOverlay.Animation.footer.rawValue
            
            self.ctxs.size = CGSize(width: NX.width * 1.0, height: 0.0)
            
            if self.ctxs.devide > 0 {
                self.ctxs.center.backgroundColor = NX.viewBackgroundColor
            }
            else {
                self.ctxs.center.backgroundColor = NX.backgroundColor
            }
        }
        
        self.ctxs.header.frame.size.width = self.ctxs.size.width
        self.ctxs.footer.frame.size.width = self.ctxs.size.width
        self.ctxs.center.frame.size.width = self.ctxs.size.width
        
        
        self.ctxs.center.frame.size.height = NXActionView.Center.center(self.ctxs).height
        self.ctxs.center.frame.size.height = min(self.ctxs.center.frame.height, self.ctxs.max - ctxs.header.frame.size.height - self.ctxs.footer.frame.height) //最优高度

        //1
        if self.ctxs.header.frame.size.height > 0 {
            self.ctxs.header.frame.origin = CGPoint(x: 0, y: 0)
            self.ctxs.size.height = self.ctxs.size.height + self.ctxs.header.frame.size.height
        }
        
        
        //2
        if self.ctxs.center.frame.size.height > 0 {
            self.ctxs.center.frame.origin = CGPoint(x: 0, y: self.ctxs.size.height)
            self.ctxs.size.height = self.ctxs.size.height + self.ctxs.center.frame.size.height
        }

        //3
        if self.ctxs.footer.frame.size.height > 0 {
            self.ctxs.size.height = self.ctxs.size.height + ctxs.devide
            self.ctxs.footer.frame.origin = CGPoint(x: 0, y: self.ctxs.size.height)
            self.ctxs.size.height = self.ctxs.size.height + self.ctxs.footer.frame.size.height
        }
        
        if self.ctxs.key.contains("footer") && self.ctxs.center.isHidden == false {
            self.ctxs.center.insets = UIEdgeInsets(top: self.ctxs.header.height, left: 0, bottom: self.ctxs.footer.height, right: 0)
            var __frame = self.ctxs.center.frame
            __frame.origin.y = 0
            __frame.size.height = __frame.size.height  + self.ctxs.center.insets.top + self.ctxs.center.insets.bottom
            self.ctxs.center.frame = __frame
        }
        
        self.headerView.updateSubviews("",self.ctxs)
        self.centerView.updateSubviews("", self.ctxs)
        self.footerView.updateSubviews("", self.ctxs)

        
        if self.ctxs.key.contains("center") {
            self.contentView.frame = CGRect(x: (self.frame.size.width - self.ctxs.size.width)/2.0, y: (self.frame.size.height-self.ctxs.size.height)/2.0, width: self.ctxs.size.width, height: self.ctxs.size.height)
        }
        else if self.ctxs.key.contains("footer"){
            self.contentView.frame = CGRect(x: (self.frame.size.width - self.ctxs.size.width)/2.0, y: self.frame.size.height-self.ctxs.size.height, width: self.ctxs.size.width, height: self.ctxs.size.height)
        }
    }
}

extension NXActionView {
    open class Header : NX.View {
        public let lhs = NX.Attribute { (__sender) in
            __sender.frame = CGRect(x: 16, y: (60-44)/2, width: 84, height: 44)
            __sender.font = NX.font(16, .regular)
            __sender.color = NX.mainColor
            __sender.textAlignment = .left
            __sender.backgroundColor = .clear
        }
        
        public let center = NX.Attribute { (__sender) in
            __sender.frame = CGRect(x: 100, y: (60-44)/2, width: NX.width-200, height: 44)
            __sender.font = NX.font(16, .bold)
            __sender.color = NX.blackColor
            __sender.textAlignment = .center
            __sender.backgroundColor = .clear
        }
        
        public let rhs = NX.Attribute { (__sender) in
            __sender.frame = CGRect(x: NX.width-16-84, y: (60-44)/2, width: 84, height: 44)
            __sender.color = NX.mainColor
            __sender.textAlignment = .right
            __sender.backgroundColor = .clear
        }
        
        public let description = NX.Attribute { (__sender) in
            __sender.textAlignment = .center
            __sender.font = NX.font(18, .bold)
            __sender.color = NX.blackColor
            __sender.backgroundColor = .clear
        }
        
        public let separator = NX.Separator{(__attribute) in
            
        }
        
        public var customView: UIView? = nil
    }
    
    public class HeaderView : NXLCRView<NXButton, UILabel, NXButton> {
        public let descriptionView = UILabel(frame: CGRect.zero)
        public var value : NXActionViewAttributes? = nil
        public override func setupSubviews() {
            super.setupSubviews()
            
            lhsView.frame = CGRect(x: 16, y: (self.height-44)/2, width: 84, height: 44)
            lhsView.contentHorizontalAlignment = .left
            lhsView.titleLabel?.font = NX.font(16)
            lhsView.layer.masksToBounds = true
            
            centerView.frame = CGRect(x: 100, y: (self.height-44)/2, width:self.width - 100 * 2 , height: 44)
            centerView.textAlignment = .center
            centerView.font = NX.font(18, .bold)
            centerView.textColor = NX.blackColor
            centerView.numberOfLines = 1
            centerView.layer.masksToBounds = true
            
            rhsView.frame = CGRect(x: self.width-16-84, y: (self.height-44)/2, width: 84, height: 44)
            rhsView.contentHorizontalAlignment = .right
            rhsView.titleLabel?.font = NX.font(16)
            rhsView.layer.masksToBounds = true
            
            descriptionView.isHidden = true
            descriptionView.textAlignment = .center
            descriptionView.font = NX.font(17, .regular)
            descriptionView.numberOfLines = 0
            descriptionView.textColor = NX.blackColor
            descriptionView.layer.masksToBounds = true
            self.addSubview(descriptionView)
        }
        
        public override func updateSubviews(_ action:String, _ value: Any?){
            guard let wrapped = value as? NXActionViewAttributes else {
                return
            }
            self.value = wrapped
            let metadata = wrapped.header

            self.isHidden = metadata.isHidden
            self.frame = metadata.frame
            self.backgroundColor = metadata.backgroundColor
            if metadata.isHidden {
                return
            }
            
            if let __customView = metadata.customView {
                __customView.isHidden = false
                if(__customView.superview != self){
                    self.addSubview(__customView)
                }
            }
            
            NX.View.update(metadata.lhs, self.lhsView)
            NX.View.update(metadata.center, self.centerView)
            NX.View.update(metadata.rhs, self.rhsView)
            NX.View.update(metadata.description, self.descriptionView)
            
            if metadata.separator.ats == NX.Ats.maxY {
                self.setupSeparator(color: metadata.separator.backgroundColor, ats: .maxY)
                self.association?.separator?.isHidden = false
            }
            else{
                self.association?.separator?.isHidden = true
            }
        }
        
        public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            self.updateSubviews("", self.value)
        }
    }
}

extension NXActionView {
    public class Center : NX.View {
        public var actions = [NXAbstract]()
        public var insets = UIEdgeInsets.zero
        public var customView: UIView? = nil
        public class func center(_ wrapped:NXActionViewAttributes) -> CGSize {
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
                        action.raw.isHighlighted = true
                        action.raw.isEnabled = true
                        if(index == 0){
                            action.raw.separator.ats = .maxX
                        }
                        else{
                            action.raw.separator.ats = []
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
                        action.raw.isHighlighted = true
                        action.raw.isEnabled = true
                        action.raw.separator.ats = (index == metadata.actions.count-1) ? [] : .maxY;
                        
                        contentSize.height = contentSize.height + action.ctxs.height
                    }
                }
                wrapped.isAnimation = false
            }
            else if wrapped.key == NXActionView.Key.action.rawValue {
                for (index, action) in metadata.actions.enumerated() {
                    action.ctxs.width = metadata.frame.width;
                    action.raw.separator.ats = (index == metadata.actions.count-1) ? []: .maxY;
                    
                    contentSize.height = contentSize.height + action.ctxs.height
                }
            }
            else if wrapped.key == NXActionView.Key.flow.rawValue {
                var offsetValue : (x:CGFloat, y:CGFloat, rowHeight:CGFloat) = (0,0,0)
                for (idx, action) in metadata.actions.enumerated() {
                    if offsetValue.x + action.ctxs.width <= metadata.frame.width {
                        //可以排在同一行
                        offsetValue.x = offsetValue.x + action.ctxs.width
                        if offsetValue.rowHeight < action.ctxs.height {
                            offsetValue.rowHeight = action.ctxs.height
                        }
                    }
                    else {
                        //新开一行
                        offsetValue.y = offsetValue.y + offsetValue.rowHeight
                        
                        offsetValue.x = action.ctxs.width
                        offsetValue.rowHeight = action.ctxs.height
                    }
                    if idx == metadata.actions.count - 1 {
                        offsetValue.y = offsetValue.y + offsetValue.rowHeight
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
    
    public class CenterView : NXCView<NXCollectionView>, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        private(set) var ctxs = NXActionViewAttributes()
        public var event : NX.Event<Int, NXAbstract>? = nil
        
        public override func setupSubviews() {
            super.setupSubviews()
            
            self.contentView.frame = self.bounds
            if let layout = self.contentView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.minimumLineSpacing = 0.0
                layout.minimumInteritemSpacing = 0.0
                layout.scrollDirection = .vertical
                layout.sectionInset = UIEdgeInsets.zero
            }
            self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.contentView.backgroundColor = NX.backgroundColor
            self.contentView.delaysContentTouches = false
        }
        
        public override func updateSubviews(_ action:String, _ value: Any?){
            guard let __wrapped = value as? NXActionViewAttributes else {
                return
            }
            self.ctxs = __wrapped
            let metadata = __wrapped.center
            self.isHidden = metadata.isHidden
            self.frame = metadata.frame
            self.backgroundColor = metadata.backgroundColor
            
            if metadata.isHidden {
                return
            }
            
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
                self.contentView.backgroundColor = metadata.backgroundColor
                self.contentView.isHidden = false
                self.contentView.contentInset = metadata.insets
                self.contentView.frame = self.bounds
                self.contentView.reloadData()
            }
        }
        
        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.ctxs.center.actions.count
        }
        
        public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
            let action = self.ctxs.center.actions[indexPath.item]
            return action.ctxs.size
        }
        
        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let action = self.ctxs.center.actions[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: action.ctxs.reuse, for: indexPath) as! NXActionViewCell
            cell.updateSubviews("update", action)
            return cell
        }
        
        public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if self.ctxs.isAnimation == true {
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
                    self.ctxs.isAnimation = false
                }
            }
        }
        
        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)
            
            let action = self.ctxs.center.actions[indexPath.item]
            if action.raw.isEnabled == true {
                if action.raw.isCloseable {
                    self.event?(indexPath.item, action)
                }
                else {
                    action.ctxs.event?("", indexPath.item)
                }
            }
        }
    }
}

extension NXActionView {
    public class Footer : NX.View {
        
        public let content = NX.Attribute { (__sender) in
            __sender.frame = CGRect(x: 100, y: (60-44)/2, width: NX.width-200, height: 44)
            __sender.font = NX.font(16, .bold)
            __sender.color = NX.blackColor
            __sender.textAlignment = .center
            __sender.backgroundColor = .clear
        }
        
        public let separator = NX.Separator{(__attribute) in
            
        }
        
        public var customView: UIView? = nil
    }
    
    public class FooterView : NXCView<NXButton> {
        public var value : NXActionViewAttributes? = nil
        
        public override func setupSubviews() {
            super.setupSubviews()
            
            self.backgroundColor = NX.backgroundColor
            
            //初始化一个button
            contentView.frame = CGRect(x: NX.insets.left, y: 10, width: self.width-NX.insets.left - NX.insets.right, height: 40)
            contentView.titleLabel?.font = NX.font(15)
            contentView.layer.masksToBounds = true
            
            //设置顶部分割线
            self.setupSeparator(color: NX.separatorColor, ats: .minY)
        }

        public override func updateSubviews(_ action:String, _ value: Any?){
            guard let wrapped = value as? NXActionViewAttributes else {
                return
            }
            self.value = wrapped
            let metadata = wrapped.footer
            self.isHidden = metadata.isHidden
            self.frame = metadata.frame
            self.backgroundColor = metadata.backgroundColor
           
            if metadata.isHidden {
                return
            }
            
            if let __customView = metadata.customView {
                __customView.isHidden = false
                if(__customView.superview != self){
                    self.addSubview(__customView)
                }
            }
            
            NX.View.update(metadata.content, self.contentView)
            
            if metadata.separator.ats == NX.Ats.minY {
                self.setupSeparator(color: NX.separatorColor, ats: .minY)
                self.association?.separator?.isHidden = false
            }
            else{
                self.association?.separator?.isHidden = true
            }
        }
        
        public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            self.updateSubviews("", self.value)
        }
    }
}

