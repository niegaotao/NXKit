//
//  NXActionView+NXFoundation.swift
//  NXKit
//
//  Created by niegaotao on 2019/2/15.
//  Copyright © 2019 niegaotao. All rights reserved.
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
                    __action.ctxs.size = CGSize(width: NX.Overlay.size.width*0.5, height: NX.Overlay.size.height)
                    __action.title.frame = CGRect(x: 0, y: 0, width: __action.ctxs.width, height: __action.ctxs.height)
                }
                else {
                    __action.ctxs.size = CGSize(width: NX.Overlay.size.width, height: NX.Overlay.size.height)
                    __action.title.frame = CGRect(x: 0, y: 0, width: __action.ctxs.width, height: __action.ctxs.height)
                }
                __action.title.color = NX.darkBlackColor
                __action.title.font = NX.font(16, true)
                __action.title.textAlignment = .center
                __action.subtitle.isHidden = true
            })
        }
        
        return NXActionView.alert(title: title, subtitle: subtitle, actions: __actions, completion: completion)
    }
    
    @discardableResult
    class public func alert(title: String, subtitle:String, actions:[NXAction], completion:NX.Completion<String, Int>?) -> NXActionView {
        for (_, action) in actions.enumerated() {
            if actions.count == 2 {
                action.ctxs.size = CGSize(width: NX.Overlay.size.width*0.5, height: NX.Overlay.size.height)
                action.title.frame = CGRect(x: 0, y: 0, width: action.ctxs.width, height: action.ctxs.height)
            }
            else {
                action.ctxs.size = CGSize(width: NX.Overlay.size.width, height: NX.Overlay.size.height)
                action.title.frame = CGRect(x: 0, y: 0, width: NX.Overlay.size.width, height: action.ctxs.height)
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
        var size = subtitle.stringSize(font: NX.font(15, false), size: CGSize(width: NX.Overlay.size.width-40, height: NXDevice.height*0.6))
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
        return NXActionView.action(actions: __actions, completion: completion)
    }
    
    @discardableResult
    class public func action(actions: [NXAction], completion:NX.Completion<String, Int>?) -> NXActionView {
        return NXActionView.action(actions: actions, header:(.none, ""), footer: (.components(false, true, false), "取消"), completion: completion)
    }
    
    @discardableResult
    class public func action(actions: [NXAction], header:NXActionView.HeaderView.Wrapped, footer: NXActionView.FooterView.Wrapped, completion:NX.Completion<String, Int>?) -> NXActionView {
        
        let actionView = NXActionView(frame: UIScreen.main.bounds)
        //header
        actionView.wrapped.header.frame.size = CGSize(width: NXDevice.width, height: 60)
        actionView.wrapped.header.separator.ats = NX.Ats.maxY
        if case .components(let lhs, let center, let rhs, let title) = header.style {
            if lhs == false && center == false && rhs == false && title == false {
                actionView.wrapped.header.isHidden = true
                actionView.wrapped.header.lhs.isHidden = true
                actionView.wrapped.header.center.isHidden = true
                actionView.wrapped.header.rhs.isHidden = true
                actionView.wrapped.header.title.isHidden = true
            }
            else {
                actionView.wrapped.header.isHidden = false
                
                actionView.wrapped.header.lhs.isHidden = !rhs
                actionView.wrapped.header.lhs.image = UIImage.image(image:NX.image(named:"uiapp_overlay_close_black.png"), color:NX.darkGrayColor)
                
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
        }
        else if case .whitespace = header.style{
            actionView.wrapped.header.isHidden = false
            actionView.wrapped.header.title.isHidden = true
            actionView.wrapped.header.lhs.isHidden = true
            actionView.wrapped.header.center.isHidden = true
            actionView.wrapped.header.rhs.isHidden = true
        }
        else if case .custom = header.style {
            actionView.wrapped.header.isHidden = false
            actionView.wrapped.header.title.isHidden = true
            actionView.wrapped.header.lhs.isHidden = true
            actionView.wrapped.header.center.isHidden = true
            actionView.wrapped.header.rhs.isHidden = true
        }
        else if case .none = header.style {
            actionView.wrapped.header.frame.size = CGSize(width: NXDevice.width, height: 0)
            actionView.wrapped.header.isHidden = true
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
        if case .components(let lhs, let center, let rhs) = footer.style {
            actionView.wrapped.footer.frame.size = CGSize(width: NXDevice.width, height: 60+NXDevice.bottomOffset)
            actionView.wrapped.footer.title.isHidden = true
            actionView.wrapped.footer.lhs.isHidden = !lhs
            actionView.wrapped.footer.center.isHidden = !center
            actionView.wrapped.footer.center.frame = CGRect(x: 0, y: 0, width: NXDevice.width, height: 60)
            actionView.wrapped.footer.center.font = NX.font(17)
            actionView.wrapped.footer.center.color = NX.mainColor
            actionView.wrapped.footer.rhs.isHidden = !rhs
        }
        else if case .whitespace = footer.style {
            actionView.wrapped.footer.frame.size = CGSize(width: NXDevice.width, height: 32.0+NXDevice.bottomOffset)
            actionView.wrapped.footer.title.isHidden = true
            actionView.wrapped.footer.lhs.isHidden = true
            actionView.wrapped.footer.center.isHidden = true
            actionView.wrapped.footer.rhs.isHidden = true
        }
        else if case .none = footer.style{
            actionView.wrapped.footer.frame.size = CGSize(width: NXDevice.width, height: NXDevice.bottomOffset)
            actionView.wrapped.footer.title.isHidden = true
            actionView.wrapped.footer.lhs.isHidden = true
            actionView.wrapped.footer.center.isHidden = true
            actionView.wrapped.footer.rhs.isHidden = true
        }
        
        //
        if case .whitespace = footer.style  {
            actionView.wrapped.devide = 0.0
        }
        else if case .none = footer.style {
            actionView.wrapped.devide = 0.0
        }
        
        actionView.updateSubviews(NXActionView.Key.Footer.action.rawValue, nil)
        actionView.completion = completion
        actionView.open(animation: actionView.animation, completion: nil)
        return actionView
    }
}

extension NXActionView {
    open class HeaderView : NXHeaderView {
        
        public typealias Wrapped = (style:NXActionView.HeaderView.Components, title:String)

        public enum Components  {
            case components(_ lhs:Bool, _ center:Bool, _ rhs:Bool, _ title:Bool)
            case whitespace      //视图存在，但是没有任何需要展示的信息
            case custom          //定制
            case none            //无头部
        }
        
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
            guard let appearance = value as? NXActionView.Appearance<NXActionView.HeaderView> else {
                return
            }
            
            self.backgroundColor = appearance.backgroundColor
            
            if let __customView = appearance.customView {
                self.addSubview(__customView)
            }
            
            if appearance.title.isHidden == false {
                self.titleView.isHidden = false
                self.titleView.frame = appearance.title.frame
                self.titleView.backgroundColor = appearance.title.backgroundColor
                self.titleView.text = appearance.title.value
                self.titleView.textColor = appearance.title.color
                self.titleView.font = appearance.title.font
                self.titleView.layer.cornerRadius = appearance.title.radius
                self.titleView.textAlignment = appearance.title.textAlignment
            }
            else {
                self.titleView.isHidden = true
            }
            
            if appearance.lhs.isHidden == false {
                self.lhsView.isHidden = false
                self.lhsView.frame = appearance.lhs.frame
                self.lhsView.backgroundColor = appearance.lhs.backgroundColor
                self.lhsView.setImage(appearance.lhs.image, for: .normal)
                self.lhsView.setTitle(appearance.lhs.value, for: .normal)
                self.lhsView.setTitleColor(appearance.lhs.color, for: .normal)
                self.lhsView.titleLabel?.font = appearance.lhs.font
                self.lhsView.layer.cornerRadius = appearance.lhs.radius
                self.lhsView.contentHorizontalAlignment = NX.Attribute.contentHorizontalAlignment(appearance.lhs.textAlignment)
            }
            else {
                self.lhsView.isHidden = true
            }
            
            if appearance.center.isHidden == false {
                self.centerView.isHidden = false
                self.centerView.frame = appearance.center.frame
                self.centerView.backgroundColor = appearance.center.backgroundColor
                if appearance.center.isAttributed {
                    let paragraph = NSMutableParagraphStyle()
                    paragraph.lineSpacing = appearance.center.lineSpacing
                    let attributedText = NSAttributedString(string: appearance.center.value,
                                                            attributes: [NSAttributedString.Key.font:appearance.center.font,
                                                                         NSAttributedString.Key.foregroundColor:appearance.center.color,
                                                                         NSAttributedString.Key.paragraphStyle:paragraph])
                    self.centerView.attributedText = attributedText
                }
                else {
                    self.centerView.text = appearance.center.value
                    self.centerView.textColor = appearance.center.color
                    self.centerView.font = appearance.center.font
                }
                self.centerView.textAlignment = appearance.center.textAlignment
                self.centerView.numberOfLines = appearance.center.numberOfLines
                self.centerView.layer.cornerRadius = appearance.center.radius
            }
            else {
                self.centerView.isHidden = true
            }
            
            if appearance.rhs.isHidden == false {
                self.rhsView.isHidden = false
                self.rhsView.frame = appearance.rhs.frame
                self.rhsView.backgroundColor = appearance.rhs.backgroundColor
                self.rhsView.setImage(appearance.rhs.image, for: .normal)
                self.rhsView.setTitle(appearance.rhs.value, for: .normal)
                self.rhsView.setTitleColor(appearance.rhs.color, for: .normal)
                self.rhsView.titleLabel?.font = appearance.rhs.font
                self.rhsView.layer.cornerRadius = appearance.rhs.radius
                self.rhsView.contentHorizontalAlignment = NX.Attribute.contentHorizontalAlignment(appearance.rhs.textAlignment)
            }
            else {
                self.rhsView.isHidden = true
            }
            
            if appearance.separator.ats == NX.Ats.maxY {
                self.setupSeparator(color: appearance.separator.backgroundColor, ats: .maxY)
                self.proxy?.separator?.isHidden = false
            }
            else{
                self.proxy?.separator?.isHidden = true
            }
        }
    }
}

extension NXActionView {
    open class CenterView : NXCView<NXCollectionView>, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        private(set) var appearance = NXActionView.Component()
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
            guard let appearance = value as? NXActionView.Appearance<NXActionView.CenterView> else {
                return
            }
            self.appearance = appearance
            
            appearance.actions.forEach { (option) in
                if let cls = option.ctxs.cls, cls != NXActionViewCell.self {
                    self.contentView.register(cls, forCellWithReuseIdentifier: option.ctxs.reuse)
                }
            }
            self.contentView.dataSource = self
            self.contentView.delegate = self
            
            if let __customView = appearance.customView {
                __customView.isHidden = false
                self.addSubview(__customView)
                self.contentView.isHidden = true
            }
            else{
                self.contentView.isHidden = false
                self.contentView.contentInset = appearance.insets
                self.contentView.frame = self.bounds
                self.contentView.reloadData()
            }
        }
        
        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.appearance.actions.count
        }
        
        public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
            let action = self.appearance.actions[indexPath.item]
            return action.ctxs.size
        }
        
        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let action = self.appearance.actions[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: action.ctxs.reuse, for: indexPath) as! NXActionViewCell
            cell.updateSubviews("update", action)
            return cell
        }
        
        public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if self.appearance.isAnimation == true {
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
                    self.appearance.isAnimation = false
                }
            }
        }
        
        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)
            
            let action = self.appearance.actions[indexPath.item]
            if action.appearance.isEnabled == true {
                self.completion?(action, indexPath.item)
            }
        }
    }
}

extension NXActionView {
    open class FooterView : NXFooterView {
        
        public typealias Wrapped = (style:NXActionView.FooterView.Components, title:String)

        public enum Components {
            case components(_ lhs:Bool, _ center:Bool, _ rhs:Bool)
            case whitespace         //视图存在，但是没有任何需要展示的信息
            case custom             //定制
            case none               //无底部
        }
        
        open override func updateSubviews(_ action:String, _ value: Any?){
            guard let appearance = value as? NXActionView.Appearance<NXActionView.FooterView> else {
                return
            }
            
            self.backgroundColor = appearance.backgroundColor
            self.frame.size.height = appearance.frame.height
            
            if let __customView = appearance.customView {
                self.addSubview(__customView)
            }
            
            if appearance.lhs.isHidden == false {
                self.lhsView.isHidden = false
                self.lhsView.frame = appearance.lhs.frame
                self.lhsView.backgroundColor = appearance.lhs.backgroundColor
                self.lhsView.setImage(appearance.lhs.image, for: .normal)
                self.lhsView.setTitle(appearance.lhs.value, for: .normal)
                self.lhsView.setTitleColor(appearance.lhs.color, for: .normal)
                self.lhsView.titleLabel?.font = appearance.lhs.font
                self.lhsView.layer.cornerRadius = appearance.lhs.radius
                self.lhsView.contentHorizontalAlignment = NX.Attribute.contentHorizontalAlignment(appearance.lhs.textAlignment)
            }
            else {
                self.lhsView.isHidden = true
            }
            
            if appearance.center.isHidden == false {
                self.centerView.isHidden = false
                self.centerView.frame = appearance.center.frame
                self.centerView.backgroundColor = appearance.center.backgroundColor
                self.centerView.setImage(appearance.center.image, for: .normal)
                self.centerView.backgroundColor = appearance.center.backgroundColor
                self.centerView.setTitle(appearance.center.value, for: .normal)
                self.centerView.setTitleColor(appearance.center.color, for: .normal)
                self.centerView.titleLabel?.font = appearance.center.font
                self.centerView.contentHorizontalAlignment = NX.Attribute.contentHorizontalAlignment(appearance.center.textAlignment)
            }
            else {
                self.centerView.isHidden = true
            }
            
            if appearance.rhs.isHidden == false {
                self.rhsView.isHidden = false
                self.rhsView.frame = appearance.rhs.frame
                self.rhsView.backgroundColor = appearance.rhs.backgroundColor
                self.rhsView.setImage(appearance.rhs.image, for: .normal)
                self.rhsView.setTitle(appearance.rhs.value, for: .normal)
                self.rhsView.setTitleColor(appearance.rhs.color, for: .normal)
                self.rhsView.titleLabel?.font = appearance.rhs.font
                self.rhsView.layer.cornerRadius = appearance.rhs.radius
                self.rhsView.contentHorizontalAlignment = NX.Attribute.contentHorizontalAlignment(appearance.rhs.textAlignment)
            }
            else {
                self.rhsView.isHidden = true
            }
            
            if appearance.separator.ats == NX.Ats.minY {
                self.setupSeparator(color: NX.separatorColor, ats: .minY)
                self.proxy?.separator?.isHidden = false
            }
            else{
                self.proxy?.separator?.isHidden = true
            }
        }
    }
}
