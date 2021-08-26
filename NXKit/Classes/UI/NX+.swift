//
//  NX.swift
//  NXKit
//
//  Created by niegaotao on 2020/2/20.
//

import UIKit
import AVFoundation

extension NX {
    
    open class View : NX.Rect {
        open var isHidden = false
        open var backgroundColor = NX.backgroundColor
        public override init() {
            super.init()
        }
    }
    
    open class Appearance : NX.View {
        open var selectedBackgroundColor = NX.selectedBackgroundColor
        open var isHighlighted = true
        open var isEnabled = true
        open var isCloseable = true
        
        open var value : Any? = nil
        
        public let separator = NX.Separator{(_,_) in}
        
        open var cornerRadius : CGFloat = 0
        open var layer : NX.Layer? = nil

        public override init(){
            super.init()
        }
        
        public init(completion:NX.Completion<String, NX.Appearance>?){
            super.init()
            completion?("", self)
        }
    }

    open class Attribute : NX.View {
        open var color  = NX.darkBlackColor
        open var textAlignment = NSTextAlignment.center
        open var numberOfLines: Int = 1
        open var lineSpacing : CGFloat = 2.5
        open var isAttributed : Bool = false
        open var value = ""
        open var font = NX.font(15)
        
        open var image : UIImage? = nil
        
        open var cornerRadius : CGFloat = 0
        open var layer : NX.Layer? = nil
        
        public override init(){
            super.init()
        }
        
        public init(completion:NX.Completion<String, NX.Attribute>?){
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
    
    open class Layer : NX.View {
        open var opacity : CGFloat = 0.0
        open var masksToBounds : Bool = false
        open var cornerRadius : CGFloat = 0.0
        
        open var borderWidth : CGFloat = 0.0
        open var borderColor = NX.separatorColor
        
        open var shadowOpacity : CGFloat = 0.0
        open var shadowRadius : CGFloat = 0.0
        open var shadowOffset = CGSize.zero
        open var shadowColor = NX.shadowColor
        
        public override init(){
            super.init()
        }
        
        public init(completion:NX.Completion<String, NX.Layer>?){
            super.init()
            completion?("", self)
        }
    }
    
    open class Separator : NX.View {
        open var insets = UIEdgeInsets.zero
        open var ats : NX.Ats = []
        
        public override init(){
            super.init()
            self.isHidden = true
            self.backgroundColor = NX.separatorColor
        }
        
        public init(completion:NX.Completion<String, NX.Separator>?){
            super.init()
            self.isHidden = true
            self.backgroundColor = NX.separatorColor
            completion?("", self)
        }
    }
    
    
    
    open class Widget<T:UIView> : NX.View  {
        open var view = T()
        
        public override init(){
            super.init()
        }
        
        public init(completion:NX.Completion<String, NX.Widget<T>>?){
            super.init()
            completion?("", self)
        }
    }
}

extension NX.View {
    
    open class func update(_ metadata:NX.Appearance, _ view:UIView){
        view.backgroundColor = metadata.backgroundColor
        if let __layer = metadata.layer {
            view.layer.cornerRadius = __layer.cornerRadius
            view.layer.borderWidth = __layer.borderWidth
            view.layer.borderColor = __layer.borderColor.cgColor
        }
        else {
            view.layer.cornerRadius = metadata.cornerRadius
        }
    }

    open class func update(_ metadata:NX.Attribute, _ view:UIView){
        if metadata.isHidden {
            view.isHidden = true
            return
        }
        if let view = view as? UILabel {
            view.isHidden = false
            view.frame = metadata.frame
            view.backgroundColor = metadata.backgroundColor
            view.numberOfLines = metadata.numberOfLines
            if metadata.isAttributed {
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineSpacing = metadata.lineSpacing
                let attributedText = NSAttributedString(string: metadata.value,
                                                        attributes: [NSAttributedString.Key.font:metadata.font,
                                                                     NSAttributedString.Key.foregroundColor:metadata.color,
                                                                     NSAttributedString.Key.paragraphStyle:paragraph])
                view.attributedText = attributedText
            }
            else {
                view.text = metadata.value
                view.textColor = metadata.color
                view.font = metadata.font
            }
            view.textAlignment = metadata.textAlignment
            
            if let __layer = metadata.layer {
                view.layer.cornerRadius = __layer.cornerRadius
                view.layer.borderWidth = __layer.borderWidth
                view.layer.borderColor = __layer.borderColor.cgColor
            }
            else {
                view.layer.cornerRadius = metadata.cornerRadius
            }
        }
        else if let view = view as? UIButton {
            view.isHidden = false
            view.frame = metadata.frame
            view.backgroundColor = metadata.backgroundColor
            view.setImage(metadata.image, for: .normal)
            view.setTitle(metadata.value, for: .normal)
            view.setTitleColor(metadata.color, for: .normal)
            view.titleLabel?.font = metadata.font
            if let __layer = metadata.layer {
                view.layer.cornerRadius = __layer.cornerRadius
                view.layer.borderWidth = __layer.borderWidth
                view.layer.borderColor = __layer.borderColor.cgColor
            }
            else {
                view.layer.cornerRadius = metadata.cornerRadius
            }
            view.contentHorizontalAlignment = NX.Attribute.contentHorizontalAlignment(metadata.textAlignment)
        }
        else if let view = view as? UIImageView {
            view.isHidden = false
            view.frame = metadata.frame
            view.backgroundColor = metadata.backgroundColor
            if let image = metadata.image {
                view.image = image
            }
            else if metadata.value.count > 0 {
                if NX.Placeholder.t.value.hasPrefix("http") {
                    NX.image(view, metadata.value)
                }
                else {
                    view.image = UIImage(named: metadata.value)
                }
            }
            else {
                view.image = nil
            }
            if let __layer = metadata.layer {
                view.layer.cornerRadius = __layer.cornerRadius
                view.layer.borderWidth = __layer.borderWidth
                view.layer.borderColor = __layer.borderColor.cgColor
            }
            else {
                view.layer.cornerRadius = metadata.cornerRadius
            }
        }
        else {
            view.isHidden = false
            view.frame = metadata.frame
            view.backgroundColor = metadata.backgroundColor
            if let __layer = metadata.layer {
                view.layer.cornerRadius = __layer.cornerRadius
                view.layer.borderWidth = __layer.borderWidth
                view.layer.borderColor = __layer.borderColor.cgColor
            }
            else {
                view.layer.cornerRadius = metadata.cornerRadius
            }
        }
    }
}

extension NX {
    
    open class Wrapped<Index: Any, Value:Any> where Index : NXInitialValue, Value : NXInitialValue {
        open var index = Index.initialValue
        open var initialValue = Value.initialValue
        open var value = Value.initialValue
        open var completion : ((_ action:String, _ value:Any?, _ completion:NX.Completion<String, NX.Wrapped<Index, Value>>?) -> ())? = nil
        
        public init(completion: NX.Completion<String, NX.Wrapped<Index, Value>>?) {
            completion?("", self)
        }
        
        open func dispose(_ action:String, _ value:Any?, _ completion:NX.Completion<String, NX.Wrapped<Index, Value>>? = nil){
            self.completion?(action, value, completion)
        }
    }
    
    open class Completed<Value:Any> where Value : NXInitialValue {
        open var isCompleted = false
        open var value = Value.initialValue
        
        open var completion : ((_ action:String, _ value:Any?, _ completion:NX.Completion<String, NX.Completed<Value>>?) -> ())? = nil
        
        public init(completion: NX.Completion<String, NX.Completed<Value>>?) {
            completion?("", self)
        }
        
        open func dispose(_ action:String, _ value:Any?, _ completion:NX.Completion<String, NX.Completed<Value>>? = nil){
            self.completion?(action, value, completion)
        }
    }
    
    open class Compared<Value:Any> where Value : NXInitialValue {
        open var minValue = Value.initialValue
        open var maxValue = Value.initialValue
        open var completion : ((_ action:String, _ value:Any?, _ completion:NX.Completion<String, NX.Compared<Value>>?) -> ())? = nil
        
        public init(completion: NX.Completion<String, NX.Compared<Value>>?) {
            completion?("", self)
        }
        
        open func dispose(_ action:String, _ value:Any?, _ completion:NX.Completion<String, NX.Compared<Value>>? = nil){
            self.completion?(action, value, completion)
        }
    }
    
    open class Specified<Value:Any> {
        open var value : Value? = nil
        open var completion : ((_ action:String, _ value:Any?, _ completion:NX.Completion<String, NX.Specified<Value>>?) -> ())? = nil
        
        public init(completion: NX.Completion<String, NX.Specified<Value>>?) {
            completion?("", self)
        }
        
        open func dispose(_ action:String, _ value:Any?, _ completion:NX.Completion<String, NX.Specified<Value>>? = nil){
            self.completion?(action, value, completion)
        }
    }
    
    open class Selectable<T:NXInitialValue> {
        open var selected = T.initialValue
        open var unselected = T.initialValue
                    
        public init(completion: NX.Completion<String, NX.Selectable<T>>?){
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
        
        public init(completion:NX.Completion<String, NX.SelectableAnyValue<T>>?){
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
                    
        public init(completion:NX.Completion<String, NX.SelectableObjectValue<T>>?){
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


extension Data : NXInitialValue {
    public static var initialValue: Data {
        return Data()
    }
}



