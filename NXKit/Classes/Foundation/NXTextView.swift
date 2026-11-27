//
//  NXTextView.swift
//  NXKit
//
//  Created by niegaotao on 2020/6/17.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXTextView: UITextView {
    public let placeholderView = UILabel(frame: CGRect.zero)
    open var notification: NXKit.Event<NSNotification.Name, NXTextView>? = nil

    override open var text: String! {
        didSet {
            textDidChange()
        }
    }

    override open var font: UIFont? {
        didSet {
            setNeedsLayout()
        }
    }

    override open var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }

    override open var textContainerInset: UIEdgeInsets {
        didSet {
            layoutSubviews()
        }
    }

    open var maximumOfBytes: Int = 0 // 小于等于0表示无限制，大于0表示有显示
    public let accessoryView = NXKeyboardAccessoryView(frame: CGRect(x: 0, y: 0, width: NXKit.width, height: 44))

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
        updateSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        updateSubviews()
    }

    private func setup() {
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        textContainer.lineFragmentPadding = 0.01
        textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
    }

    public convenience init(frame: CGRect, textContainer: NSTextContainer?, maximumOfBytes: Int) {
        self.init(frame: frame, textContainer: textContainer)
        update(placeholder: nil, placeholderColor: nil, maximumOfBytes: maximumOfBytes)
    }

    open func update(placeholder: String?, placeholderColor: UIColor?, maximumOfBytes: Int) {
        if placeholder != nil {
            placeholderView.text = placeholder
        }

        if placeholderColor != nil {
            placeholderView.textColor = placeholderColor
        }
        self.maximumOfBytes = maximumOfBytes

        commitInputAccessoryView()
        setNeedsLayout()
    }

    private func commitInputAccessoryView() {
        if maximumOfBytes > 0 {
            accessoryView.bytesView.isHidden = false
            accessoryView.bytesView.text = "0/\(Int(ceil(Double(maximumOfBytes / 2))))"
        } else {
            accessoryView.bytesView.isHidden = true
        }

        accessoryView.actionView.setupEvent(.touchUpInside, action: { [weak self] _, _ in
            self?.endEditing(true)
        })

        inputAccessoryView = accessoryView
    }

    private func updateSubviews() {
        placeholderView.textColor = NXKit.lightGrayColor

        placeholderView.backgroundColor = UIColor.clear
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderView)

        setNeedsLayout()
    }

    @objc private func textDidChange() {
        notification?(UITextView.textDidChangeNotification, self)
        placeholderView.isHidden = !text.isEmpty

        // 只有对长度有限制才需要处理
        if maximumOfBytes > 0 {
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
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        let __font = font ?? NXKit.font(16)

        var __frame = placeholderView.frame
        __frame.origin.x = textContainerInset.left + textContainer.lineFragmentPadding
        __frame.origin.y = textContainerInset.top
        __frame.size.width = frame.size.width - textContainerInset.left - textContainerInset.right - textContainer.lineFragmentPadding * 2.0
        let __size = String.size(of: placeholderView.text, size: CGSize(width: __frame.size.width, height: 100), font: __font) { __style in
            __style.lineSpacing = 2.0
        }
        __frame.size.height = __size.height

        placeholderView.textAlignment = textAlignment
        placeholderView.numberOfLines = 0
        placeholderView.font = __font
        placeholderView.frame = __frame
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
}
