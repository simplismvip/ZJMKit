//
//  JMNotify.swift
//  ZFBaseModule
//
//  Created by JunMing on 2020/12/7.
//

import UIKit

public typealias jmNotigyBlock = (_ info: MsgObjc?) -> Void

private final class JMWeakBox<T: NSObject> {
    weak var weakObjc: T?
    init(_ objc: T) {
        weakObjc = objc
    }
}

open class JMNotify: NSObject {
    private let lock = NSRecursiveLock()
    private var notifyDic = [String: [JMWeakBox]]()
    private static let share = JMNotify()
    /// 执行全局通知消息
    /// - Parameters:
    ///   - eventName: 消息名称
    ///   - info: 参数
    @objc public static func jmNotify(eventName: String, info: MsgObjc?) {
        JMNotify.share.lock.lock()
        if let instanseArr = JMNotify.share.notifyDic[eventName] {
            for weakObj in instanseArr {
                weakObj.weakObjc?.notifyEvents[eventName]?(info)
            }
        }
        JMNotify.share.lock.unlock()
    }
    
    /// 注册全局通知消息
    /// - Parameters:
    ///   - eventName: 消息名称
    ///   - instanse: 注册实例
    ///   - block: 回调
    @objc public static func jmRegisterNotify(eventName: String, instanse: NSObject, block: @escaping jmNotigyBlock) {
        JMNotify.share.lock.lock()
        if JMNotify.share.notifyDic[eventName] == nil {
            JMNotify.share.notifyDic[eventName] = [JMWeakBox]()
        }
        
        instanse.notifyEvents[eventName] = block
        JMNotify.share.notifyDic[eventName]?.append(JMWeakBox(instanse))
        JMNotify.share.lock.unlock()
    }
}

fileprivate extension NSObject {
    var notifyEvents:[String: jmNotigyBlock] {
        get {
            guard let dicInfo = objc_getAssociatedObject(self, &JMEventStore.event_notify_action) as? [String: jmNotigyBlock] else {
                self.notifyEvents = [String: jmNotigyBlock]()
                return self.notifyEvents
            }
            return dicInfo
        }
        set { objc_setAssociatedObject(self, &JMEventStore.event_notify_action, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}
