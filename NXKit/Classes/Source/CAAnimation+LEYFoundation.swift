//
//  CAAnimation+LEYFoundation.swift
//  NXFoundation
//
//  Created by firelonely on 2019/6/17.
//

import UIKit

extension CAAnimation {
    private struct AssociatedKey {
        static var ctxs = "ctxsKey"
    }
    
    public private(set) var ctxs : CAAnimation.Contexts? {
        set{
            objc_setAssociatedObject(self, &CAAnimation.AssociatedKey.ctxs, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &CAAnimation.AssociatedKey.ctxs) as? CAAnimation.Contexts
        }
    }
    
    open var completion : ((_ animation: CAAnimation, _ isCompleted:Bool) -> ())? {
        set{
            if self.ctxs == nil {
                self.ctxs = CAAnimation.Contexts()
            }
            self.ctxs?.completion = newValue
            self.delegate = self.ctxs
        }
        get{
            return self.ctxs?.completion
        }
    }
    
    
    open class Contexts : NSObject, CAAnimationDelegate {
        open var completion : ((_ animation:CAAnimation, _ isCompleted:Bool) -> ())? = nil
        
        open func animationDidStart(_ anim: CAAnimation) {
            
        }
        
        open func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
            self.completion?(anim, flag)
        }
    }
}
