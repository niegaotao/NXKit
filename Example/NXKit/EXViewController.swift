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
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        let button = UIButton(frame: CGRect(x: 5, y: 5, width: NXDevice.width-10, height: 100))
        button.backgroundColor = .red
        button.setupEvents([.touchUpInside]) { _, _ in
            let vc = EXViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.contentView.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

