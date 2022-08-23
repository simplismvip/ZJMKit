//
//  JMReverseEvent+Responder.swift
//  FBSnapshotTestCase
//
//  Created by JunMing on 2020/7/17.
//  Copyright © 2022 JunMing. All rights reserved.
//

import UIKit

extension UIResponder {

    /// 向 子视图/子控制器 发送消息
    func jmRouterReverseEvent(eventName:String, info:AnyObject?) {
        
    }
    
    /// 向 自父视图/父控制器 注册消息
    func jmRegisterReverseEvent(eventName:String,block:@escaping EventBlock,next:Bool) {
        
    }
}

