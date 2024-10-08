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
    open var notification : NXKit.Event<NSNotification.Name, NXTextView>? = nil
    
    override open var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override open  var font: UIFont? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override open var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    override open var textContainerInset: UIEdgeInsets {
        didSet {
            self.layoutSubviews()
        }
    }
    
    open var maximumOfBytes: Int = 0 //小于等于0表示无限制，大于0表示有显示
    public let accessoryView = NXKeyboardAccessoryView(frame: CGRect(x: 0, y: 0, width: NXKit.width, height: 44))
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.setup()
        self.updateSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
        self.updateSubviews()
    }
    
    private func setup(){
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        self.textContainer.lineFragmentPadding = 0.01
        self.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
    }
    
    
    public convenience init(frame: CGRect, textContainer: NSTextContainer?, maximumOfBytes: Int) {
        self.init(frame: frame, textContainer: textContainer)
        self.update(placeholder:nil, placeholderColor:nil, maximumOfBytes:maximumOfBytes)
    }
    
    open func update(placeholder: String?, placeholderColor: UIColor?, maximumOfBytes: Int){
        if placeholder != nil {
            self.placeholderView.text = placeholder
        }
        
        if placeholderColor != nil {
            self.placeholderView.textColor = placeholderColor
        }
        self.maximumOfBytes = maximumOfBytes
        
        self.commitInputAccessoryView()
        self.setNeedsLayout()
    }
    
    private func commitInputAccessoryView() {
        
        if maximumOfBytes > 0 {
            self.accessoryView.bytesView.isHidden = false
            self.accessoryView.bytesView.text = "0/\(Int(ceil(Double(maximumOfBytes/2))))"
        }
        else{
            self.accessoryView.bytesView.isHidden = true
        }
        
        self.accessoryView.actionView.setupEvent(.touchUpInside, action: {[weak self] _, bar in
            self?.endEditing(true)
        })

        self.inputAccessoryView = accessoryView
    }
    
    private func updateSubviews() {
        placeholderView.textColor = NXKit.lightGrayColor
       
        placeholderView.backgroundColor = UIColor.clear
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(placeholderView)
        
        self.setNeedsLayout()
    }
    
    @objc private func textDidChange() {
        self.notification?(UITextView.textDidChangeNotification, self)
        placeholderView.isHidden = !text.isEmpty
        
        //只有对长度有限制才需要处理
        if maximumOfBytes > 0 {
            self.accessoryView.bytesView.isHidden = false
            if var textStr = text {
                
                var byteLength = String.countOfBytes(textStr)
                
                if byteLength > maximumOfBytes {
                    textStr = String.substringOfBytes(textStr, countOfBytes:maximumOfBytes)
                    text = textStr
                }
                
                byteLength = String.countOfBytes(textStr)
                self.accessoryView.bytesView.text = "\(Int(ceil(Double(byteLength/2))))/\(Int(ceil(Double(maximumOfBytes/2))))"
                
                if byteLength == maximumOfBytes {
                    self.accessoryView.bytesView.textColor = NXKit.color(0xFF3B74, 1)
                }
                else {
                    self.accessoryView.bytesView.textColor = NXKit.lightGrayColor
                }
            }
        }
        else {
            self.accessoryView.bytesView.isHidden = true
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let __font = self.font ?? NXKit.font(16)

        var __frame = self.placeholderView.frame
        __frame.origin.x = self.textContainerInset.left + self.textContainer.lineFragmentPadding
        __frame.origin.y = self.textContainerInset.top
        __frame.size.width = self.frame.size.width - self.textContainerInset.left - self.textContainerInset.right - self.textContainer.lineFragmentPadding * 2.0
        let __size = String.size(of: self.placeholderView.text, size: CGSize(width: __frame.size.width, height: 100), font: __font) { __style in
            __style.lineSpacing = 2.0
        }
        __frame.size.height = __size.height
        
        self.placeholderView.textAlignment = self.textAlignment
        self.placeholderView.numberOfLines = 0
        self.placeholderView.font = __font
        self.placeholderView.frame = __frame
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
}
