//
//  NXLabel.swift
//  NXKit
//
//  Created by firelonely on 2018/8/28.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

open class NXLabel: UILabel {
    open var value : [String:Any]?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubviews()
    }
    
    open func setupSubviews(){
        
    }
    
    open func updateSubviews(_ action: String, _ value:Any?){
    
    }
}

open class NXCopyLabel: NXLabel {
    
    //让其有交互能力，并添加一个长按手势
    override open func setupSubviews() {
        super.setupSubviews()
        isUserInteractionEnabled = true
        self.setupEvents([.longPress]) {[weak self] (e, v) in
            if e == UIControl.Event.tap {
                if let longPress = self?.proxy?.longPressRecognizer {
                    self?.clickLabel(longPress: longPress)
                }
            }
        }
    }
    
    @objc func clickLabel(longPress: UILongPressGestureRecognizer) {
        if(longPress.state == .began) {
            // 让其成为响应者
            becomeFirstResponder()
            
            let menu = UIMenuController.shared
            let copy = UIMenuItem(title: "复制", action: #selector(copyText))
            
            menu.menuItems = [copy]
            
            //            menu.setTargetRect(bounds, in: self)
            menu.setTargetRect(CGRect.init(x: 0, y: 0, width: 65, height: 25), in: self)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
    @objc func copyText() {
        UIPasteboard.general.string = self.text
    }
    
    override open var canBecomeFirstResponder: Bool {
        return true
    }
    
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(copyText)
    }

}
