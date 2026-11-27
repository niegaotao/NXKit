//
//  NXTextField.swift
//  NXKit
//
//  Created by niegaotao on 2020/6/17.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXTextField: UITextField {
    open var maximumOfBytes: Int = 0
    public let accessoryView = NXKeyboardAccessoryView(frame: CGRect(x: 0, y: 0, width: NXKit.width, height: 44))

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public convenience init(frame: CGRect, maximumOfBytes: Int) {
        self.init(frame: frame)
        self.maximumOfBytes = maximumOfBytes
        setupSubviews()
    }

    override open var text: String? {
        didSet {
            textDidChange()
        }
    }

    open func setup() {
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        inputAccessoryView = accessoryView
        accessoryView.actionView.setupEvent(.touchUpInside, action: { [weak self] _, _ in
            self?.endEditing(true)
        })
    }

    open func setupSubviews() {
        if maximumOfBytes > 0 {
            accessoryView.bytesView.isHidden = false
            accessoryView.bytesView.text = "0/\(Int(ceil(Double(maximumOfBytes / 2))))"
        } else {
            accessoryView.bytesView.isHidden = true
        }
    }

    @objc private func textDidChange() {
        if maximumOfBytes > 0 {
            if accessoryView.isEnabled {
                accessoryView.bytesView.isHidden = false
                if var textStr = text {
                    var byteLength = String.countOfBytes(textStr)

                    if byteLength > maximumOfBytes {
                        textStr = String.substringOfBytes(textStr, countOfBytes: maximumOfBytes)
                        text = textStr
                    }

                    byteLength = String.countOfBytes(textStr)
                    accessoryView.bytesView.text = "\(Int(ceil(Double(byteLength / 2))))/\(Int(ceil(Double(maximumOfBytes / 2))))"

                    if byteLength == maximumOfBytes {
                        accessoryView.bytesView.textColor = NXKit.color(0xFF3B74, 1)
                    } else {
                        accessoryView.bytesView.textColor = NXKit.lightGrayColor
                    }
                }
            } else {
                accessoryView.bytesView.isHidden = true
            }
        } else {
            accessoryView.bytesView.isHidden = true
        }
    }
}
