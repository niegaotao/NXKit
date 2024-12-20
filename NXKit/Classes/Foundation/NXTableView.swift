//
//  NXTableView.swift
//  NXKit
//
//  Created by niegaotao on 2020/6/20.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

public struct NXTableDescriptor {
    public var placeholder = true
    public var calc = true
    
    public init(){}
    
    public init(placeholder: Bool, calc: Bool) {
        self.placeholder = placeholder
        self.calc = calc
    }
}

open class NXTableView: UITableView, NXViewProtocol {
    open var backdropView : UIImageView? = nil
    weak open var data : NXCollection<NXTableView>?
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubviews()
    }
    
    open func setupSubviews(){
        self.estimatedRowHeight = 0
        self.estimatedSectionFooterHeight = 0
        self.estimatedSectionHeaderHeight = 0
        self.backgroundColor = NXKit.viewBackgroundColor
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.separatorColor = NXKit.separatorColor
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        if style == .plain {
            self.sectionHeaderHeight = 0
            self.sectionFooterHeight = 0
        }
        else {
            self.sectionHeaderHeight = 10
            self.sectionFooterHeight = 0
        }
        self.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: NXKit.width, height: 0.01))
        self.tableHeaderView?.backgroundColor = UIColor.clear
        
        self.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: NXKit.width, height: 0.01))
        self.tableFooterView?.backgroundColor = UIColor.clear
    }
    
    override open var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    
    //设置下拉刷新时候跟导航栏保持一致颜色
    open func updateBackdropView(colors: [UIColor], start: CGPoint, end: CGPoint) {
        if self.backdropView == nil {
            self.backdropView = UIImageView(frame: self.bounds)
            self.backdropView?.frame = self.bounds.offsetBy(dx: 0, dy: -self.bounds.size.height)
            self.backdropView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        if let __backdropView = self.backdropView {
            self.addSubview(__backdropView)
            self.sendSubviewToBack(__backdropView)
            __backdropView.image = UIImage.image(colors: colors, size: __backdropView.frame.size, start: start, end: end)
        }
    }
    
    //是否显示默认图
    open func updateSubviews(_ value: Any?) {
        if let __value = value as? NXTableDescriptor {
            self.data?.placeholderView.ctxs.isHidden = !__value.placeholder
            self.data?.calcAt = __value.calc
        }
        else {
            self.data?.placeholderView.ctxs.isHidden = false
            self.data?.calcAt = true
        }
        
        self.reloadData()
    }
    
    //加载的时候看是否需要显示默认图
    override open func reloadData() {
        
        if let __tableWrapper = self.data {
            if __tableWrapper.elements.isEmpty {
                
                if __tableWrapper.placeholderView.ctxs.isHidden == false {

                    var size  = CGSize(width: NXKit.width, height: 0)
                    if __tableWrapper.placeholderView.ctxs.frame.width > 0 && __tableWrapper.placeholderView.ctxs.frame.height > 0 {
                        size.height = __tableWrapper.placeholderView.ctxs.frame.height
                    }
                    else {
                        var ___remainder = self.height - (self.tableHeaderView?.height ?? 0) - (self.tableFooterView?.height ?? 0)
                        ___remainder = ___remainder - self.contentInset.top - self.contentInset.bottom
                        size.height = max(___remainder, 250)
                    }
                    __tableWrapper.addPlaceholderView(CGRect(origin: CGPoint.zero, size: size))
                }
            }
            
            if __tableWrapper.calcAt {
                __tableWrapper.elements.forEach { (__section) in
                    __section.elements.forEach { (__element) in
                        var __element = __element
                        __element.at.first = false
                        __element.at.last = false
                    }
                    var first = __section.elements.first
                    var last = __section.elements.last
                    first?.at.first = true
                    last?.at.last = true
                }
            }
        }
        
        super.reloadData()
    }
}
