//
//  LEYAttribute.swift
//  NXFoundation
//
//  Created by firelonely on 2020/2/20.
//

import UIKit
import AVFoundation

extension LEYApp {
    
    open class View {
        open var isHidden = false
        open var frame = CGRect.zero
        open var backgroundColor = LEYApp.backgroundColor
        public init() {}
    }
    
    open class Appearance : LEYApp.View {
        open var selectedBackgroundColor = LEYApp.selectedBackgroundColor
        open var isHighlighted = true
        open var isEnabled = true
        open var isCloseable = true
        open var insets = UIEdgeInsets.zero
        open var value : Any? = nil

        public override init(){
            super.init()
        }
        
        public init(completion:LEYApp.Completion<String, LEYApp.Appearance>?){
            super.init()
            completion?("", self)
        }
    }

    open class Attribute : LEYApp.View {
        open var color  = LEYApp.darkBlackColor
        open var textAlignment = NSTextAlignment.center
        open var numberOfLines: Int = 1
        open var lineSpacing : CGFloat = 2.5
        open var isAttributed : Bool = false
        open var value = ""
        open var font = LEYApp.font(15)
        
        open var image : UIImage? = nil
        open var radius : CGFloat = 0
        
        public override init(){
            super.init()
        }
        
        public init(completion:LEYApp.Completion<String, LEYApp.Attribute>?){
            super.init()
            completion?("", self)
        }
        
        open class func contentHorizontalAlignment(_ textAlignment: NSTextAlignment) -> UIControl.ContentHorizontalAlignment {
            if textAlignment == .left {
                return UIControl.ContentHorizontalAlignment.left
            }
            else if textAlignment == .right {
                return UIControl.ContentHorizontalAlignment.right
            }
            return UIControl.ContentHorizontalAlignment.center
        }
    }
    
    open class Separator : LEYApp.View {
        open var insets = UIEdgeInsets.zero
        open var side : LEYApp.Side = []
        
        public override init(){
            super.init()
            self.isHidden = true
            self.backgroundColor = LEYApp.separatorColor
        }
        
        public init(completion:LEYApp.Completion<String, LEYApp.Separator>?){
            super.init()
            self.isHidden = true
            self.backgroundColor = LEYApp.separatorColor
            completion?("", self)
        }
    }
    
    open class Widget<T:UIView> : LEYApp.View  {
        open var widgetView = T()
        
        public override init(){
            super.init()
        }
        
        public init(completion:LEYApp.Completion<String, LEYApp.Widget<T>>?){
            super.init()
            completion?("", self)
        }
    }
    
    open class Border {
        open var color = UIColor.clear
        open var width : CGFloat = 0.0
        open var radius : CGFloat = 0.0
        
        public init(){}
        
        public init(completion:LEYApp.Completion<String, LEYApp.Border>?){
            completion?("", self)
        }
    }
    
    
    open class Shadow {
        open var isHidden = false
        open var radius : CGFloat = 0.0
        open var color =  LEYApp.shadowColor
        open var opacity : CGFloat = 0.0
        open var offset = CGSize.zero
        
        public init(){}
        
        public init(completion:LEYApp.Completion<String, LEYApp.Shadow>?){
            completion?("", self)
        }
    }
    
    open class Wrapped<Index: Any, Value:Any> where Index : LEYInitialValue, Value : LEYInitialValue {
        open var index = Index.initialValue
        open var initialValue = Value.initialValue
        open var value = Value.initialValue
        open var completion : ((_ action:String, _ value:Any?, _ completion:LEYApp.Completion<String, LEYApp.Wrapped<Index, Value>>?) -> ())? = nil
        
        public init(completion:LEYApp.Completion<String, LEYApp.Wrapped<Index, Value>>?) {
            completion?("", self)
        }
        
        open func dispose(_ action:String, _ value:Any?, _ completion:LEYApp.Completion<String, LEYApp.Wrapped<Index, Value>>? = nil){
            self.completion?(action, value, completion)
        }
    }
    
    open class Completed<Value:Any> where Value : LEYInitialValue {
        open var isCompleted = false
        open var value = Value.initialValue
        
        open var completion : ((_ action:String, _ value:Any?, _ completion:LEYApp.Completion<String, LEYApp.Completed<Value>>?) -> ())? = nil
        
        public init(completion:LEYApp.Completion<String, LEYApp.Completed<Value>>?) {
            completion?("", self)
        }
        
        open func dispose(_ action:String, _ value:Any?, _ completion:LEYApp.Completion<String, LEYApp.Completed<Value>>? = nil){
            self.completion?(action, value, completion)
        }
    }
    
    open class Compared<Value:Any> where Value : LEYInitialValue {
        open var minValue = Value.initialValue
        open var maxValue = Value.initialValue
        open var completion : ((_ action:String, _ value:Any?, _ completion:LEYApp.Completion<String, LEYApp.Compared<Value>>?) -> ())? = nil
        
        public init(completion:LEYApp.Completion<String, LEYApp.Compared<Value>>?) {
            completion?("", self)
        }
        
        open func dispose(_ action:String, _ value:Any?, _ completion:LEYApp.Completion<String, LEYApp.Compared<Value>>? = nil){
            self.completion?(action, value, completion)
        }
    }
    
    open class Specified<Value:Any> {
        open var value : Value? = nil
        open var completion : ((_ action:String, _ value:Any?, _ completion:LEYApp.Completion<String, LEYApp.Specified<Value>>?) -> ())? = nil
        
        public init(completion:LEYApp.Completion<String, LEYApp.Specified<Value>>?) {
            completion?("", self)
        }
        
        open func dispose(_ action:String, _ value:Any?, _ completion:LEYApp.Completion<String, LEYApp.Specified<Value>>? = nil){
            self.completion?(action, value, completion)
        }
    }
    
    open class Selectable<T:LEYInitialValue> {
        open var selected = T.initialValue
        open var unselected = T.initialValue
                    
        public init(completion:LEYApp.Completion<String, LEYApp.Selectable<T>>?){
            completion?("", self)
        }
        
        open func update(_ selected:T, unselected:T) {
            self.selected = selected
            self.unselected = unselected
        }
    }
    
    open class SelectableAnyValue<T:Any> {
        open var selected : T? = nil
        open var unselected : T? = nil
        
        public init(completion:LEYApp.Completion<String, LEYApp.SelectableAnyValue<T>>?){
            completion?("", self)
        }
        
        open func update(_ selected:T?, unselected:T?) {
            self.selected = selected
            self.unselected = unselected
        }
    }
    
    open class SelectableObjectValue<T:NSObject> {
        open var selected = T()
        open var unselected = T()
                    
        public init(completion:LEYApp.Completion<String, LEYApp.SelectableObjectValue<T>>?){
            completion?("", self)
        }
        
        open func update(_ selected:T, unselected:T) {
            self.selected = selected
            self.unselected = unselected
        }
    }
}


public protocol LEYInitialValue {
    static var initialValue : Self { get }
}

extension Dictionary : LEYInitialValue {
    public static var initialValue: Dictionary<Key, Value> {
        return Dictionary<Key, Value>()
    }
}

extension Array : LEYInitialValue {
    public static var initialValue: Array<Element> {
        return Array<Element>()
    }
}

extension Set : LEYInitialValue {
    public static var initialValue: Set<Element> {
        return Set<Element>()
    }
}

extension String : LEYInitialValue {
    public static var initialValue: String {
        return ""
    }
}

extension Bool : LEYInitialValue {
    public static var initialValue: Bool {
        return false
    }
}

extension CGPoint : LEYInitialValue {
    public static var initialValue : CGPoint {
        return CGPoint.zero
    }
}

extension CGSize : LEYInitialValue {
    public static var initialValue: CGSize {
        return CGSize.zero
    }
}

extension CGRect : LEYInitialValue {
    public static var initialValue: CGRect {
        return CGRect.zero
    }
}

extension CGVector : LEYInitialValue {
    public static var initialValue: CGVector {
        return CGVector.zero
    }
}

extension UIOffset : LEYInitialValue {
    public static var initialValue: UIOffset {
        return UIOffset.zero
    }
}

extension UIEdgeInsets : LEYInitialValue {
    public static var initialValue: UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

extension CGAffineTransform : LEYInitialValue {
    public static var initialValue: CGAffineTransform {
        return CGAffineTransform.identity
    }
}

extension CGFloat : LEYInitialValue {
    public static var initialValue: CGFloat {
        return CGFloat.zero
    }
}

extension Int : LEYInitialValue {
    public static var initialValue: Int {
        return 0
    }
}

extension Int8 : LEYInitialValue {
    public static var initialValue: Int8 {
        return 0
    }
}

extension Int16 : LEYInitialValue {
    public static var initialValue: Int16 {
        return 0
    }
}

extension Int32 : LEYInitialValue {
    public static var initialValue: Int32 {
        return 0
    }
}

extension Int64 : LEYInitialValue {
    public static var initialValue: Int64 {
        return 0
    }
}

extension Float : LEYInitialValue {
    public static var initialValue: Float {
        return Float.zero
    }
}

@available(iOS 14.0, watchOS 7.0, tvOS 14.0, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
extension Float16 : LEYInitialValue {
    public static var initialValue: Float16 {
        return Float16.zero
    }
}

extension Double : LEYInitialValue {
    public static var initialValue: Double {
        return Double.zero
    }
}

extension NSTextAlignment : LEYInitialValue {
    public static var initialValue: NSTextAlignment {
        return NSTextAlignment.center
    }
}

extension UIControl.ContentVerticalAlignment : LEYInitialValue {
    public static var initialValue: UIControl.ContentVerticalAlignment {
        return UIControl.ContentVerticalAlignment.center
    }
}

extension UIControl.ContentHorizontalAlignment : LEYInitialValue {
    public static var initialValue: UIControl.ContentHorizontalAlignment {
        return UIControl.ContentHorizontalAlignment.center
    }
}

extension UIGestureRecognizer.State : LEYInitialValue {
    public static var initialValue: UIGestureRecognizer.State {
        return UIGestureRecognizer.State.possible
    }
}

extension CMTime : LEYInitialValue {
    public static var initialValue: CMTime {
        return CMTime.zero
    }
}

extension CMTimeRange : LEYInitialValue {
    public static var initialValue: CMTimeRange {
        return CMTimeRange(start: CMTime.initialValue, end: CMTime.initialValue)
    }
}



