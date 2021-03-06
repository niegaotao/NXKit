//
//  NXAttribute.swift
//  NXKit
//
//  Created by firelonely on 2020/2/20.
//

import UIKit
import AVFoundation

extension NXApp {
    
    open class View {
        open var isHidden = false
        open var frame = CGRect.zero
        open var backgroundColor = NXApp.backgroundColor
        public init() {}
    }
    
    open class Appearance : NXApp.View {
        open var selectedBackgroundColor = NXApp.selectedBackgroundColor
        open var isHighlighted = true
        open var isEnabled = true
        open var isCloseable = true
        open var insets = UIEdgeInsets.zero
        open var value : Any? = nil

        public override init(){
            super.init()
        }
        
        public init(completion:NXApp.Completion<String, NXApp.Appearance>?){
            super.init()
            completion?("", self)
        }
    }

    open class Attribute : NXApp.View {
        open var color  = NXApp.darkBlackColor
        open var textAlignment = NSTextAlignment.center
        open var numberOfLines: Int = 1
        open var lineSpacing : CGFloat = 2.5
        open var isAttributed : Bool = false
        open var value = ""
        open var font = NXApp.font(15)
        
        open var image : UIImage? = nil
        open var radius : CGFloat = 0
        
        public override init(){
            super.init()
        }
        
        public init(completion:NXApp.Completion<String, NXApp.Attribute>?){
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
    
    open class Separator : NXApp.View {
        open var insets = UIEdgeInsets.zero
        open var side : NXApp.Side = []
        
        public override init(){
            super.init()
            self.isHidden = true
            self.backgroundColor = NXApp.separatorColor
        }
        
        public init(completion:NXApp.Completion<String, NXApp.Separator>?){
            super.init()
            self.isHidden = true
            self.backgroundColor = NXApp.separatorColor
            completion?("", self)
        }
    }
    
    open class Widget<T:UIView> : NXApp.View  {
        open var widgetView = T()
        
        public override init(){
            super.init()
        }
        
        public init(completion:NXApp.Completion<String, NXApp.Widget<T>>?){
            super.init()
            completion?("", self)
        }
    }
    
    open class Border {
        open var color = UIColor.clear
        open var width : CGFloat = 0.0
        open var radius : CGFloat = 0.0
        
        public init(){}
        
        public init(completion:NXApp.Completion<String, NXApp.Border>?){
            completion?("", self)
        }
    }
    
    
    open class Shadow {
        open var isHidden = false
        open var radius : CGFloat = 0.0
        open var color =  NXApp.shadowColor
        open var opacity : CGFloat = 0.0
        open var offset = CGSize.zero
        
        public init(){}
        
        public init(completion:NXApp.Completion<String, NXApp.Shadow>?){
            completion?("", self)
        }
    }
    
    open class Wrapped<Index: Any, Value:Any> where Index : NXInitialValue, Value : NXInitialValue {
        open var index = Index.initialValue
        open var initialValue = Value.initialValue
        open var value = Value.initialValue
        open var completion : ((_ action:String, _ value:Any?, _ completion:NXApp.Completion<String, NXApp.Wrapped<Index, Value>>?) -> ())? = nil
        
        public init(completion:NXApp.Completion<String, NXApp.Wrapped<Index, Value>>?) {
            completion?("", self)
        }
        
        open func dispose(_ action:String, _ value:Any?, _ completion:NXApp.Completion<String, NXApp.Wrapped<Index, Value>>? = nil){
            self.completion?(action, value, completion)
        }
    }
    
    open class Completed<Value:Any> where Value : NXInitialValue {
        open var isCompleted = false
        open var value = Value.initialValue
        
        open var completion : ((_ action:String, _ value:Any?, _ completion:NXApp.Completion<String, NXApp.Completed<Value>>?) -> ())? = nil
        
        public init(completion:NXApp.Completion<String, NXApp.Completed<Value>>?) {
            completion?("", self)
        }
        
        open func dispose(_ action:String, _ value:Any?, _ completion:NXApp.Completion<String, NXApp.Completed<Value>>? = nil){
            self.completion?(action, value, completion)
        }
    }
    
    open class Compared<Value:Any> where Value : NXInitialValue {
        open var minValue = Value.initialValue
        open var maxValue = Value.initialValue
        open var completion : ((_ action:String, _ value:Any?, _ completion:NXApp.Completion<String, NXApp.Compared<Value>>?) -> ())? = nil
        
        public init(completion:NXApp.Completion<String, NXApp.Compared<Value>>?) {
            completion?("", self)
        }
        
        open func dispose(_ action:String, _ value:Any?, _ completion:NXApp.Completion<String, NXApp.Compared<Value>>? = nil){
            self.completion?(action, value, completion)
        }
    }
    
    open class Specified<Value:Any> {
        open var value : Value? = nil
        open var completion : ((_ action:String, _ value:Any?, _ completion:NXApp.Completion<String, NXApp.Specified<Value>>?) -> ())? = nil
        
        public init(completion:NXApp.Completion<String, NXApp.Specified<Value>>?) {
            completion?("", self)
        }
        
        open func dispose(_ action:String, _ value:Any?, _ completion:NXApp.Completion<String, NXApp.Specified<Value>>? = nil){
            self.completion?(action, value, completion)
        }
    }
    
    open class Selectable<T:NXInitialValue> {
        open var selected = T.initialValue
        open var unselected = T.initialValue
                    
        public init(completion:NXApp.Completion<String, NXApp.Selectable<T>>?){
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
        
        public init(completion:NXApp.Completion<String, NXApp.SelectableAnyValue<T>>?){
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
                    
        public init(completion:NXApp.Completion<String, NXApp.SelectableObjectValue<T>>?){
            completion?("", self)
        }
        
        open func update(_ selected:T, unselected:T) {
            self.selected = selected
            self.unselected = unselected
        }
    }
}


public protocol NXInitialValue {
    static var initialValue : Self { get }
}

extension Dictionary : NXInitialValue {
    public static var initialValue: Dictionary<Key, Value> {
        return Dictionary<Key, Value>()
    }
}

extension Array : NXInitialValue {
    public static var initialValue: Array<Element> {
        return Array<Element>()
    }
}

extension Set : NXInitialValue {
    public static var initialValue: Set<Element> {
        return Set<Element>()
    }
}

extension String : NXInitialValue {
    public static var initialValue: String {
        return ""
    }
}

extension Bool : NXInitialValue {
    public static var initialValue: Bool {
        return false
    }
}

extension CGPoint : NXInitialValue {
    public static var initialValue : CGPoint {
        return CGPoint.zero
    }
}

extension CGSize : NXInitialValue {
    public static var initialValue: CGSize {
        return CGSize.zero
    }
}

extension CGRect : NXInitialValue {
    public static var initialValue: CGRect {
        return CGRect.zero
    }
}

extension CGVector : NXInitialValue {
    public static var initialValue: CGVector {
        return CGVector.zero
    }
}

extension UIOffset : NXInitialValue {
    public static var initialValue: UIOffset {
        return UIOffset.zero
    }
}

extension UIEdgeInsets : NXInitialValue {
    public static var initialValue: UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

extension CGAffineTransform : NXInitialValue {
    public static var initialValue: CGAffineTransform {
        return CGAffineTransform.identity
    }
}

extension CGFloat : NXInitialValue {
    public static var initialValue: CGFloat {
        return CGFloat.zero
    }
}

extension Int : NXInitialValue {
    public static var initialValue: Int {
        return 0
    }
}

extension Int8 : NXInitialValue {
    public static var initialValue: Int8 {
        return 0
    }
}

extension Int16 : NXInitialValue {
    public static var initialValue: Int16 {
        return 0
    }
}

extension Int32 : NXInitialValue {
    public static var initialValue: Int32 {
        return 0
    }
}

extension Int64 : NXInitialValue {
    public static var initialValue: Int64 {
        return 0
    }
}

extension Float : NXInitialValue {
    public static var initialValue: Float {
        return Float.zero
    }
}

@available(iOS 14.0, watchOS 7.0, tvOS 14.0, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
extension Float16 : NXInitialValue {
    public static var initialValue: Float16 {
        return Float16.zero
    }
}

extension Double : NXInitialValue {
    public static var initialValue: Double {
        return Double.zero
    }
}

extension NSTextAlignment : NXInitialValue {
    public static var initialValue: NSTextAlignment {
        return NSTextAlignment.center
    }
}

extension UIControl.ContentVerticalAlignment : NXInitialValue {
    public static var initialValue: UIControl.ContentVerticalAlignment {
        return UIControl.ContentVerticalAlignment.center
    }
}

extension UIControl.ContentHorizontalAlignment : NXInitialValue {
    public static var initialValue: UIControl.ContentHorizontalAlignment {
        return UIControl.ContentHorizontalAlignment.center
    }
}

extension UIGestureRecognizer.State : NXInitialValue {
    public static var initialValue: UIGestureRecognizer.State {
        return UIGestureRecognizer.State.possible
    }
}

extension CMTime : NXInitialValue {
    public static var initialValue: CMTime {
        return CMTime.zero
    }
}

extension CMTimeRange : NXInitialValue {
    public static var initialValue: CMTimeRange {
        return CMTimeRange(start: CMTime.initialValue, end: CMTime.initialValue)
    }
}



