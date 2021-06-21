//
//  NXMasterViewController.swift
//  NXFoundation_Example
//
//  Created by niegaotao on 2019/12/6.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import NXKit

class NXMasterViewController: NXSwipeViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.swipeView.wrapped.isEqually = true
//        self.swipeView.wrapped.color.selected = UIColor.red
//        self.swipeView.wrapped.font.selected = NXApp.font(18, true)
//        self.swipeView.wrapped.maximumOfComponents = 4.0
        self.setupSubviews([NXMasterSubviewController(),NXMasterSubviewController(),NXMasterSubviewController(),NXMasterSubviewController(),NXMasterSubviewController(),NXMasterSubviewController(),NXMasterSubviewController()], elements: ["精华精华","动态","收藏","精华精华","动态","收藏","精华精华"])
    }
}

class NXMasterSubviewController : NXViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.ctxs.isWrapped {
            self.naviView.isHidden = true
            self.contentView.frame = self.view.bounds
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NXApp.log { return "viewWillAppear:\(self)"}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NXApp.log { return "viewWillDisappear:\(self)"}
    }
}



