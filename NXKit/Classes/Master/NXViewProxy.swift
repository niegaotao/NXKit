//
//  UIView+Proxy.swift
//  NXKit
//
//  Created by niegaotao on 2020/7/11.
//

import UIKit

extension UIControl.Event {
    public static var tap = UIControl.Event(rawValue: 100)
    public static var longPress = UIControl.Event(rawValue: 101)
    public static var pan = UIControl.Event(rawValue: 102)
    public static var pinch = UIControl.Event(rawValue: 103)
    public static var rotation = UIControl.Event(rawValue: 104)
    public static var swipe = UIControl.Event(rawValue: 105)
}

open class NXViewProxy {
    static var proxy = "proxy"
    
    public init(){}
    
    open weak var separator : CALayer? = nil
    open weak var sender : UIView? = nil
    public fileprivate(set) var action : ((_ event:UIControl.Event, _ sender:UIView) -> ())? = nil

    public fileprivate(set) var tapRecognizer : UITapGestureRecognizer? = nil
    public fileprivate(set) var longPressRecognizer : UILongPressGestureRecognizer? = nil
    public fileprivate(set) var panRecognizer : UIPanGestureRecognizer? = nil
    public fileprivate(set) var pinchRecognizer : UIPinchGestureRecognizer? = nil
    public fileprivate(set) var rotationRecognizer : UIRotationGestureRecognizer? = nil
    public fileprivate(set) var swipeRecognizer : UISwipeGestureRecognizer? = nil
        
    open func update(_ sender:UIView, _ events:[UIControl.Event], action:((_ event:UIControl.Event, _ sender:UIView) -> ())?) {
        self.sender = sender
        self.action = action
        
        for event in events {
            if event == .touchUpInside, let control = sender as? UIControl {
                control.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
            }
            else if event == .touchDown, let control = sender as? UIControl  {
                control.addTarget(self, action: #selector(touchDown), for: .touchDown)
            }
            else if event == .touchDownRepeat, let control = sender as? UIControl  {
                control.addTarget(self, action: #selector(touchDownRepeat), for: .touchDownRepeat)
            }
            else if event == .touchDragInside, let control = sender as? UIControl  {
                control.addTarget(self, action: #selector(touchDragInside), for: .touchDragInside)
            }
            else if event == .touchDragOutside, let control = sender as? UIControl  {
                control.addTarget(self, action: #selector(touchDragOutside), for: .touchDragOutside)
            }
            else if event == .touchDragEnter, let control = sender as? UIControl  {
                control.addTarget(self, action: #selector(touchDragEnter), for: .touchDragEnter)
            }
            else if event == .touchDragExit, let control = sender as? UIControl  {
                control.addTarget(self, action: #selector(touchDragExit), for: .touchDragExit)
            }
            else if event == .touchUpOutside, let control = sender as? UIControl  {
                control.addTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside)
            }
            else if event == .touchCancel, let control = sender as? UIControl  {
                control.addTarget(self, action: #selector(touchCancel), for: .touchCancel)
            }
            else if event == .valueChanged, let control = sender as? UIControl  {
                control.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
            }
            else if event == .editingDidBegin, let control = sender as? UIControl  {
                control.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
            }
            else if event == .editingChanged, let control = sender as? UIControl  {
                control.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
            }
            else if event == .editingDidEnd, let control = sender as? UIControl  {
                control.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
            }
            else if event == .editingDidEndOnExit, let control = sender as? UIControl  {
                control.addTarget(self, action: #selector(editingDidEndOnExit), for: .editingDidEndOnExit)
            }
            else if event == .allTouchEvents, let control = sender as? UIControl  {
                control.addTarget(self, action: #selector(allTouchEvents), for: .allTouchEvents)
            }
            else if event == .allEditingEvents, let control = sender as? UIControl  {
                control.addTarget(self, action: #selector(allEditingEvents), for: .allEditingEvents)
            }
            else if event == .applicationReserved, let control = sender as? UIControl  {
                control.addTarget(self, action: #selector(applicationReserved), for: .applicationReserved)
            }
            else if event == .systemReserved, let control = sender as? UIControl  {
                control.addTarget(self, action: #selector(systemReserved), for: .systemReserved)
            }
            else if event == .allEvents, let control = sender as? UIControl  {
                control.addTarget(self, action: #selector(allEvents), for: .allEvents)
            }
            else if event == .tap {
                sender.isUserInteractionEnabled = true
                if let __recognizer = self.tapRecognizer {
                    __recognizer.addTarget(self, action: #selector(tapAction))
                    sender.addGestureRecognizer(__recognizer)
                }
                else {
                    let __recognizer = UITapGestureRecognizer()
                    __recognizer.addTarget(self, action: #selector(tapAction))
                    sender.addGestureRecognizer(__recognizer)
                    self.tapRecognizer = __recognizer
                }
                sender.isUserInteractionEnabled = true
            }
            else if event == .longPress {
                if let __recognizer = self.longPressRecognizer {
                    __recognizer.addTarget(self, action: #selector(longPressAction))
                    sender.addGestureRecognizer(__recognizer)
                }
                else {
                    let __recognizer = UILongPressGestureRecognizer()
                    __recognizer.addTarget(self, action: #selector(longPressAction))
                    sender.addGestureRecognizer(__recognizer)
                    self.longPressRecognizer = __recognizer
                }
                sender.isUserInteractionEnabled = true
            }
            else if event == .pan {
                if let __recognizer = self.panRecognizer {
                    __recognizer.addTarget(self, action: #selector(panAction))
                    sender.addGestureRecognizer(__recognizer)
                }
                else {
                    let __recognizer = UIPanGestureRecognizer()
                    __recognizer.addTarget(self, action: #selector(panAction))
                    sender.addGestureRecognizer(__recognizer)
                    self.panRecognizer = __recognizer
                }
                sender.isUserInteractionEnabled = true
            }
            else if event == .pinch {
                if let __recognizer = self.pinchRecognizer {
                    __recognizer.addTarget(self, action: #selector(pinchAction))
                    sender.addGestureRecognizer(__recognizer)
                }
                else {
                    let __recognizer = UIPinchGestureRecognizer()
                    __recognizer.addTarget(self, action: #selector(pinchAction))
                    sender.addGestureRecognizer(__recognizer)
                    self.pinchRecognizer = __recognizer
                }
                sender.isUserInteractionEnabled = true
            }
            else if event == .rotation {
                if let __recognizer = self.rotationRecognizer {
                    __recognizer.addTarget(self, action: #selector(rotationAction))
                    sender.addGestureRecognizer(__recognizer)
                }
                else {
                    let __recognizer = UIRotationGestureRecognizer()
                    __recognizer.addTarget(self, action: #selector(rotationAction))
                    sender.addGestureRecognizer(__recognizer)
                    self.rotationRecognizer = __recognizer
                }
                sender.isUserInteractionEnabled = true
            }
            else if event == .swipe {
                if let __recognizer = self.swipeRecognizer {
                    __recognizer.addTarget(self, action: #selector(swipeAction))
                    sender.addGestureRecognizer(__recognizer)
                }
                else {
                    let __recognizer = UISwipeGestureRecognizer()
                    __recognizer.addTarget(self, action: #selector(swipeAction))
                    sender.addGestureRecognizer(__recognizer)
                    self.swipeRecognizer = __recognizer
                }
                sender.isUserInteractionEnabled = true
            }
            else if #available(iOS 9.0, *) {
                if event == .primaryActionTriggered, let control = sender as? UIControl  {
                    control.addTarget(self, action: #selector(primaryActionTriggered), for: .primaryActionTriggered)
                }
            }
        }
    }
    
    @objc func touchDown(){
        if let __control = self.sender as? UIControl {
            self.action?(.touchDown, __control)
        }
    }
    
    @objc func touchDownRepeat(){
        if let __control = self.sender as? UIControl{
            self.action?(.touchDownRepeat, __control)
        }
    }
    
    @objc func touchDragInside(){
        if let __control = self.sender as? UIControl{
            self.action?(.touchDragInside, __control)
        }
    }
    
    @objc func touchDragOutside(){
        if let __control = self.sender as? UIControl{
            self.action?(.touchDragOutside, __control)
        }
    }
    
    @objc func touchDragEnter(){
        if let __control = self.sender as? UIControl{
            self.action?(.touchDragEnter, __control)
        }
    }
    
    @objc func touchDragExit(){
        if let __control = self.sender as? UIControl{
            self.action?(.touchDragExit, __control)
        }
    }
    
    @objc func touchUpInside(){
        if let __control = self.sender as? UIControl{
            self.action?(.touchUpInside, __control)
        }
    }
    
    @objc func touchUpOutside(){
        if let __control = self.sender as? UIControl{
            self.action?(.touchUpOutside, __control)
        }
    }
    
    @objc func touchCancel(){
        if let __control = self.sender as? UIControl{
            self.action?(.touchCancel, __control)
        }
    }
    
    @objc func valueChanged() {
        if let __control = self.sender as? UIControl{
            self.action?(.valueChanged, __control)
        }
    }
    
    @available(iOS 9.0, *)
    @objc func primaryActionTriggered() {
        if let __control = self.sender as? UIControl {
            self.action?(.primaryActionTriggered, __control)
        }
    }
    
    @objc func editingDidBegin() {
        if let __control = self.sender as? UIControl{
            self.action?(.editingDidBegin, __control)
        }
    }
    
    @objc func editingChanged() {
        if let __control = self.sender as? UIControl{
            self.action?(.editingChanged, __control)
        }
    }
    
    @objc func editingDidEnd() {
        if let __control = self.sender as? UIControl{
            self.action?(.editingDidEnd, __control)
        }
    }
    
    
    @objc func editingDidEndOnExit() {
        if let __control = self.sender as? UIControl{
            self.action?(.editingDidEndOnExit, __control)
        }
    }
    
    @objc func allTouchEvents() {
        if let __control = self.sender as? UIControl{
            self.action?(.allTouchEvents, __control)
        }
    }
    
    @objc func allEditingEvents() {
        if let __control = self.sender as? UIControl{
            self.action?(.allEditingEvents, __control)
        }
    }
    
    @objc func applicationReserved() {
        if let __control = self.sender as? UIControl{
            self.action?(.applicationReserved, __control)
        }
    }
    @objc func systemReserved() {
        if let __control = self.sender as? UIControl {
            self.action?(.systemReserved, __control)
        }
    }
    @objc func allEvents() {
        if let __control = self.sender as? UIControl {
            self.action?(.allEvents, __control)
        }
    }
    
    @objc func tapAction(){
        //轻点
        if let __sender = self.sender {
            self.action?(.tap, __sender)
        }
    }
    
    @objc func longPressAction(){
        //防止一次长按出发多次
        if let __sender = self.sender, let __longPressRecognizer = self.longPressRecognizer, __longPressRecognizer.state == .began {
            self.action?(.longPress, __sender)
        }
    }
    
    @objc func panAction(){
        if let __sender = self.sender {
            self.action?(.pan, __sender)
        }
    }
    
    @objc func pinchAction(){
        if let __sender = self.sender {
            self.action?(.pinch, __sender)
        }
    }
    
    @objc func rotationAction(){
        if let __sender = self.sender {
            self.action?(.rotation, __sender)
        }
    }
    
    @objc func swipeAction(){
        if let __sender = self.sender {
            self.action?(.swipe, __sender)
        }
    }
}
