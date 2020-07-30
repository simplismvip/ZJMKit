//
//  JMExtension+Utils.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/3/28.
//

import Foundation

extension UIFont {
    open var medium:UIFont {
        if let font = UIFont(name: "PingFangSC-Medium", size: 23) {
            return font
        }
        return UIFont.systemFont(ofSize: 23)
    }
    
    open class func jmRegular(_ size:CGFloat) -> UIFont {
        if let font = UIFont(name: "PingFangSC-Regular", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
    
    open class func jmAvenir(_ size:CGFloat) -> UIFont {
        if let font = UIFont(name: "Avenir-Light", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
    
    open class func jmMedium(_ size:CGFloat) -> UIFont {
        if let font = UIFont(name: "PingFangSC-Medium", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
    
    open class func jmBold(_ size:CGFloat) -> UIFont {
        if let font = UIFont(name: "Helvetica-Bold", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
}

extension Int {
    /// 获取随机数
    public static func jmRandom(from: Int, to: Int) -> Int {
        guard from < to else { fatalError("`from` MUST be less than `to`") }
        let delta = UInt32(to + 1 - from)
        return from + Int(arc4random_uniform(delta))
    }
}

extension CGRect {
    public static func Rect(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

extension Int {
    /// 数字转时间
    public var jmCurrentTime:String {
        if self > 3600 {
            return "\(self/3600)时\(self/60%60)分\(self%60)秒"
        }
        
        if self > 60 && self < 3600 {
            return "\(self/60)分\(self%60)秒"
        }
        
        if self < 60 {
            return "\(self)秒"
        }
        return ""
    }
}

extension Double {
    /// date
    public var jmDate:Date {
        return Date(timeIntervalSince1970: self)
    }
}

extension Date {
    /// 时间戳字符串
    public static func jmCreateTspString() -> String {
        let tmp = Date(timeIntervalSinceNow: 0).timeIntervalSince1970*1000
        return String(tmp).components(separatedBy: ".")[0]
    }
    /// 当前时间戳
    public static var jmCurrentTime:TimeInterval {
        return Date(timeIntervalSinceNow: 0).timeIntervalSince1970
    }
    /// 是否是同一天
    public func jmIsSameDay() -> Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let nowComps = calendar.dateComponents(unit, from: Date())
        let selfCmps = calendar.dateComponents(unit, from: self)
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (selfCmps.day == nowComps.day)
    }
    /// 是否是昨天
    public func jmIsYesterday() -> Bool {
        let calendar = Calendar.current
        let unit:Set<Calendar.Component> = [.day,.month,.year]
        let nowComps = calendar.dateComponents(unit, from: Date())
        let selfCmps = calendar.dateComponents(unit, from: self)
        let count = nowComps.day! - selfCmps.day!
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (count == 1)
    }
    /// 是否是同一年
    public func jmIsSameYear() -> Bool {
        let calendar = Calendar.current
        let nowComps = calendar.component(.year, from: Date())
        let selfComps = calendar.component(.year, from: self)
        return (nowComps == selfComps)
    }
}

extension NotificationCenter {
    /// 添加通知
    open class func jmObserver(_ observer: Any, selector: Selector, name: String, object: Any? = nil) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: name), object: object)
    }
    /// 发送通知
    open class func jmPost(name: String, object: Any? = nil) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: object)
    }
    
    public typealias jmNotiBlock = (AnyObject?)->Void
    private struct storeKeys {
        static var notify = "storeKeys.notify"
    }
}

