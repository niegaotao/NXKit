//
//  NXSearchView.swift
//  NXKit
//
//  Created by niegaotao on 2022/3/18.
//  Copyright (c) 2022 niegaotao. All rights reserved.
//

import UIKit


open class NXSearchView: NXBackgroundView<UIImageView, UIView>, UITextFieldDelegate {
    public let mirrorView = UIImageView(frame: CGRect(x: 16, y: 0, width: 16, height: 16))
    public let fieldView = NXTextField(frame: CGRect(x: 35, y: 0, width: 0, height: 0), maximumOfBytes: 100)
    
    public private(set) var placeholder = "输入关键词"
    
    override open func setupSubviews() {
        super.setupSubviews()
        
        self.backgroundView.frame = self.bounds
        
        self.contentView.frame = self.bounds
        self.contentView.backgroundColor = NX.color(247, 247, 247)
        self.contentView.layer.borderColor = NX.separatorColor.cgColor
        self.contentView.layer.borderWidth = NX.pixel
        self.contentView.layer.cornerRadius = 16.0
        self.contentView.layer.masksToBounds = true
        
        //左侧的放大镜
        mirrorView.frame = CGRect(x: 16, y: (self.height-16)/2, width: 16, height: 16)
        mirrorView.image = UIImage(named: "navi_searchbar.png")
        self.contentView.addSubview(mirrorView)
        
        //文字输入框
        fieldView.font = NX.font(14)
        fieldView.textColor = NX.color(80, 80, 80)
        fieldView.frame = CGRect(x: 35, y: 0, width: self.width-35, height: self.height)
        fieldView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        fieldView.clearButtonMode = .whileEditing
        fieldView.font = NX.font(14)
        fieldView.minimumFontSize = 14
        fieldView.text = ""
        fieldView.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        fieldView.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        fieldView.delegate = self
        fieldView.setupEvent(.editingChanged) { [weak self] (v, e) in
            self?.realtimeSearch?("", NX.get(string:self?.fieldView.text, ""))
        }
        fieldView.returnKeyType = .search
        self.contentView.addSubview(fieldView)
        
        self.updateSubviews("placeholder", self.placeholder)
    }
    
    
    open var completion : NX.Completion<String, [String:Any]>? = nil
    
    //RETURN 按钮点击后回调 查询数据
    //clear, return
    open var search : NX.Completion<String, String>? = nil
    
    //在不断输入的过程中，下方不断更新展示推荐关键字
    open var realtimeSearch : NX.Completion<String, String>? = nil
    
    
    open var editable : Bool = true {
        didSet {
            fieldView.isEnabled = editable
        }
    }
    
    func addTarget(_ target: Any, action: Selector){
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
    
    @discardableResult
    override open func becomeFirstResponder() -> Bool {
        return fieldView.becomeFirstResponder()
    }
    
    @discardableResult
    override open func resignFirstResponder() -> Bool {
        return fieldView.resignFirstResponder()
    }
    
    @discardableResult
    open func isFirstResponder() -> Bool  {
        return fieldView.isFirstResponder
    }
    
    //MARK:UITextFieldDelegate
    //点击键盘"搜索"后的事件
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.search?("return", NX.get(string:textField.text, ""))
        return true
    }
    
    //点击清理
    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.fieldView.text = ""
        DispatchQueue.main.asyncAfter(delay: 0.1) {
            self.search?("clear", "")
        }
        return true
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView.frame = self.bounds
        self.contentView.frame = self.bounds
        
        self.fieldView.frame = CGRect(x: 35, y: 0, width: self.width-35, height: self.height)
    }
}
