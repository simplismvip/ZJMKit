//
//  JMResponder+Event.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/3/28.
//

import UIKit

private let kEventBlockKey = "kEventBlockKey"
private let kNeedNextResponderKey = "kNeedNextResponderKey"
extension UIResponder {
    public typealias EventBlock = (_ info:AnyObject?)->Void
    private struct storeKeys {
        static var eventStrategy = [String:AnyObject]()
    }
    // 添加计算属性，用来绑定 AssociatedKeys
    private var eventStrategy:Dictionary<String,AnyObject> {
        get {
            if let strategy = objc_getAssociatedObject(self, &storeKeys.eventStrategy) as? Dictionary<String, AnyObject> {
                return strategy
            }else {
                self.eventStrategy = Dictionary<String,AnyObject>()
                return self.eventStrategy
            }
        }
        set(newValue){
            objc_setAssociatedObject(self, &storeKeys.eventStrategy, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 向 父视图/父控制器 发送消息
    open func jmRouterEvent(eventName:String, info:AnyObject?) {
        if let blockDic = eventStrategy[eventName] {
            if let block = blockDic[kEventBlockKey] as? EventBlock {
                block(info)
            }
            
            if let next = blockDic[kNeedNextResponderKey] {
                if let nextStatus = next as? Bool {
                    if nextStatus == false { return }
                }
            }
        }
        next?.jmRouterEvent(eventName: eventName, info: info)
    }
    
    /// 向 父视图/父控制器 注册消息
    open func jmRegisterEvent(eventName:String,block:@escaping EventBlock,next:Bool) {
        eventStrategy[eventName] = [kEventBlockKey:block,kNeedNextResponderKey:next] as AnyObject
    }
}
