//
//  NXScrollView.swift
//  NXKit
//
//  Created by 聂高涛 on 2024/11/8.
//

import UIKit

open class NXScrollView: UIScrollView, UIGestureRecognizerDelegate {
    open var isSupportedMultirecognizers = false

    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        if isSupportedMultirecognizers {
            if let panRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
                return enableBackRecognizer(panRecognizer)
            }
            return false
        }
        return false
    }

    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if isSupportedMultirecognizers {
            if let panRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
                return !enableBackRecognizer(panRecognizer)
            }
            return true
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }

    private func enableBackRecognizer(_ panRecognizer: UIPanGestureRecognizer) -> Bool {
        if panRecognizer == panGestureRecognizer {
            let state = panRecognizer.state
            let p = panRecognizer.translation(in: self)
            if (state == .began || state == .possible) && contentOffset.x <= 0.0 && p.x > 0 {
                return true
            }
        }
        return false
    }
}
