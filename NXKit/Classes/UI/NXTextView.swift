//
//  NXTextView.swift
//  NXKit
//
//  Created by niegaotao on 2019/6/17.
//


import UIKit

open class LEYTextView: UITextView {
    public let placeholderView = UILabel()
    
    
    override open var text: String! {
        didSet {
            textDidChangeNotification()
        }
    }
    
    override open  var font: UIFont? {
        didSet {
            if let __font = self.font {
                let __size = String.size(of: "应用", size: CGSize(width: 200, height: 200), font: __font)
                var __frame = self.placeholderView.frame
                __frame.size.height = ceil(__size.height)
                self.placeholderView.frame = __frame
            }
        }
    }
    
    override open var attributedText: NSAttributedString! {
        didSet {
            textDidChangeNotification()
        }
    }
    
    override open var textContainerInset: UIEdgeInsets {
        didSet {
            self.layoutSubviews()
        }
    }
    
    open var textDidChangeCallback : (() -> ())?
    open var accessoryCallback : (() -> ())?
    
    open var maximumOfBytes: Int = 0 //小于等于0表示无限制，大于0表示有显示
    public let accessoryView = NXKeyboardAccessoryView(frame: CGRect(x: 0, y: 0, width: NXDevice.width, height: 44))
    
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
                                               selector: #selector(textDidChangeNotification),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
    }
    
    //
    public convenience init(frame: CGRect, textContainer: NSTextContainer?, maximumOfBytes: Int) {
        self.init(frame: frame, textContainer: textContainer)
        self.update(placeholder:nil, placeholderColor:nil, maximumOfBytes:maximumOfBytes)
    }
    
    open func update(placeholder:String?, placeholderColor:UIColor?, maximumOfBytes:Int){
        if placeholder != nil {
            self.placeholderView.text = placeholder
        }
        
        if placeholderColor != nil {
            self.placeholderView.textColor = placeholderColor
        }
        self.maximumOfBytes = maximumOfBytes
        
        self.commitInputAccessoryView()

    }
    
    private func commitInputAccessoryView() {
        
        if maximumOfBytes > 0 {
            self.accessoryView.bytesView.isHidden = false
            self.accessoryView.bytesView.text = "0/\(Int(ceil(Double(maximumOfBytes/2))))"
        }
        else{
            self.accessoryView.bytesView.isHidden = true
        }
        
        self.accessoryView.actionView.setupEvents([.touchUpInside], action: {[weak self] _, bar in
            self?.endEditing(true)
            self?.accessoryCallback?()
        })

        self.inputAccessoryView = accessoryView
    }
    
    private func updateSubviews() {
        placeholderView.font = NX.font(16)
        placeholderView.textColor = NX.lightGrayColor
        placeholderView.textAlignment = self.textAlignment
        placeholderView.text = ""
        placeholderView.numberOfLines = 0
        placeholderView.backgroundColor = UIColor.clear
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(placeholderView)
        
        self.layoutSubviews()
    }
    
    @objc private func textDidChangeNotification() {
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
                    self.accessoryView.bytesView.textColor = NX.color(0xFF3B74, 1)
                }
                else {
                    self.accessoryView.bytesView.textColor = NX.color(0x92929B, 1)
                }
            }
        }
        else {
            self.accessoryView.bytesView.isHidden = true
        }
        
        textDidChangeCallback?()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        var __frame = self.placeholderView.frame
        __frame.origin.x = self.textContainerInset.left + self.textContainer.lineFragmentPadding
        __frame.origin.y = self.textContainerInset.top
        __frame.size.width = self.frame.size.width - self.textContainerInset.left - self.textContainerInset.right - self.textContainer.lineFragmentPadding * 2.0
        self.placeholderView.frame = __frame
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
}
