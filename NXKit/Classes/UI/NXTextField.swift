//
//  NXTextField.swift
//  NXKit
//
//  Created by niegaotao on 2021/6/17.
//

import UIKit


open class NXTextField: UITextField {
    open var maximumOfBytes: Int = 0
    public let accessoryView = NXKeyboardAccessoryView(frame: CGRect(x: 0, y: 0, width: NXDevice.width, height: 44))
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    public convenience init(frame: CGRect, maximumOfBytes: Int) {
        self.init(frame: frame)
        self.maximumOfBytes = maximumOfBytes
        self.setupSubviews()
    }
    
    override open var text: String? {
        didSet {
            textDidChange()
        }
    }
        
    open func setup(){
        self.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        self.inputAccessoryView = self.accessoryView
        self.accessoryView.actionView.setupEvents([.touchUpInside], action: {[weak self] (_,_) in
            self?.endEditing(true)
        })
    }
    
    open func setupSubviews(){
        if maximumOfBytes > 0 {
            self.accessoryView.bytesView.isHidden = false
            self.accessoryView.bytesView.text = "0/\(Int(ceil(Double(maximumOfBytes/2))))"
        }
        else{
            self.accessoryView.bytesView.isHidden = true
        }
    }

    @objc private func textDidChange() {
        if maximumOfBytes > 0 {
            if accessoryView.isEnabled {
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
        }
        else{
            self.accessoryView.bytesView.isHidden = true
        }
    }
}
