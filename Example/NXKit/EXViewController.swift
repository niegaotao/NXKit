//
//  EXViewController.swift
//  NXKit
//
//  Created by niegaotao on 09/18/2021.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit
import NXKit

class EXViewController: NXViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.naviView.title = "NXViewController"
        
        let button = UIButton(frame: CGRect(x: 5, y: 5, width: NXUI.width-10, height: 100))
        button.backgroundColor = .red
        button.setupEvents([.touchUpInside]) { _, _ in
            let vc = EXViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.contentView.addSubview(button)
                        
    }
}

