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

        backgroundView.frame = bounds

        contentView.frame = bounds
        contentView.backgroundColor = NXKit.color(247, 247, 247)
        contentView.layer.borderColor = NXKit.separatorColor.cgColor
        contentView.layer.borderWidth = NXKit.pixel
        contentView.layer.cornerRadius = 16.0
        contentView.layer.masksToBounds = true

        // 左侧的放大镜
        mirrorView.frame = CGRect(x: 16, y: (height - 16) / 2, width: 16, height: 16)
        mirrorView.image = UIImage(named: "navi_searchbar.png")
        contentView.addSubview(mirrorView)

        // 文字输入框
        fieldView.font = NXKit.font(14)
        fieldView.textColor = NXKit.color(80, 80, 80)
        fieldView.frame = CGRect(x: 35, y: 0, width: width - 35, height: height)
        fieldView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        fieldView.clearButtonMode = .whileEditing
        fieldView.font = NXKit.font(14)
        fieldView.minimumFontSize = 14
        fieldView.text = ""
        fieldView.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        fieldView.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        fieldView.delegate = self
        fieldView.setupEvent(.editingChanged) { [weak self] _, _ in
            self?.realtimeSearch?("", NXKit.get(string: self?.fieldView.text, ""))
        }
        fieldView.accessoryView.actionView.setupEvent(.touchUpInside) { [weak self] _, _ in
            guard let self = self else { return }
            let keyboard = self.fieldView.text ?? ""
            self.search?("return", keyboard)
            self.fieldView.resignFirstResponder()
        }
        fieldView.returnKeyType = .search
        contentView.addSubview(fieldView)

        updateSubviews(placeholder)
    }

    // RETURN 按钮点击后回调 查询数据
    // clear, return
    open var search: NXKit.Event<String, String>? = nil

    // 在不断输入的过程中，下方不断更新展示推荐关键字
    open var realtimeSearch: NXKit.Event<String, String>? = nil

    open var editable: Bool = true {
        didSet {
            fieldView.isEnabled = editable
        }
    }

    func addTarget(_ target: Any, action: Selector) {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
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
    open func isFirstResponder() -> Bool {
        return fieldView.isFirstResponder
    }

    // MARK: UITextFieldDelegate

    // 点击键盘"搜索"后的事件
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search?("return", NXKit.get(string: textField.text, ""))
        return true
    }

    // 点击清理
    open func textFieldShouldClear(_: UITextField) -> Bool {
        fieldView.text = ""
        DispatchQueue.main.asyncAfter(delay: 0.1) {
            self.search?("clear", "")
        }
        return true
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = bounds
        contentView.frame = bounds

        fieldView.frame = CGRect(x: 35, y: 0, width: width - 35, height: height)
    }
}
