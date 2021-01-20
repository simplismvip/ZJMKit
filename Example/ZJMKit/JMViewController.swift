//
//  JMViewController.swift
//  ZJMKit_Example
//
//  Created by JunMing on 2021/1/20.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import ZJMKit
import SnapKit

class JMViewController: JMBaseController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
    }
}

class SECONDController: JMBaseController {
    let btn = UIButton(type: .system)
    let btn1 = UIButton(type: .system)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(btn)
        btn.setTitle("发送通知", for: .normal)
        
        view.addSubview(btn1)
        btn1.setTitle("移除通知", for: .normal)
        
        NotificationCenter.default.jm.addObserver(target: self, name: "NotifyViewController") { (notify) in
            print(notify)
        }
        
        NotificationCenter.default.jm.addObserver(target: self, name: "SecNotifyViewController") { (notify) in
            print(notify)
        }
        
        btn.jmAddAction { [weak self](_) in
            // self?.navigationController?.pushViewController(ViewController(), animated: true)
            print("1111111111")
            NotificationCenter.default.jm.post(name: "NotifyViewController", object: "第一个")
        }
        
        btn.jm.addAction { (sender) in
            print("222222222222")
            NotificationCenter.default.jm.post(name: "SecNotifyViewController", object: "第二个")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btn.frame = CGRect.Rect(100, 100, 100, 100)
    }
}
