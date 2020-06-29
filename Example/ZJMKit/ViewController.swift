//
//  ViewController.swift
//  ZJMKit
//
//  Created by simplismvip on 03/28/2020.
//  Copyright (c) 2020 simplismvip. All rights reserved.
//

import UIKit
import ZJMKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.jmRandColor
        
    }

    @IBAction func show(_ sender: Any) {
        JMTextToast.share.jmShowString(text: "哈哈，我是一个☝️弹窗", seconds: 5)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

