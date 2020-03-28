//
//  JMResponder+ReverseEvent.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/3/28.
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
