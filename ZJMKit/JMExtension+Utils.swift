//
//  JMExtension+Utils.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/3/28.
//

import Foundation

extension UIFont {
    open var medium:UIFont {
        return UIFont(name: "PingFangSC-Medium", size: 23)!
    }
    
    open class func regular(_ size:CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Regular", size: size)
    }
    
    open class func medium(_ size:CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Medium", size: size)
    }
    
    open class func Bold(_ size:CGFloat) -> UIFont? {
        return UIFont(name: "Helvetica-Bold", size: size)
    }
    
}

extension CGRect {
    public static func Rect(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

extension Array {
    public mutating func removeObject<T:Equatable>(_ model:T, inArray:inout [T]) {
        var findIndex:Int?
        for (index,item) in inArray.enumerated() {
            if item == model {
                findIndex = index
                break
            }
        }
        
        if let index = findIndex {
            inArray.remove(at: index)
        }
    }
    
    public mutating func deleteObject<T:Equatable>(_ model:T, inArray:inout [T]) {
        var findIndex:Int?
        for (index,item) in inArray.enumerated() {
            if item == model {
                findIndex = index
                break
            }
        }
        
        if let index = findIndex {
            inArray.remove(at: index)
        }
    }
}

extension Int {
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
    public var jm_date:Date {
        return Date(timeIntervalSince1970: self)
    }
}

extension Date {
    public static func jm_createTspString() -> String {
        let tmp = Date(timeIntervalSinceNow: 0).timeIntervalSince1970*1000
        return String(tmp).components(separatedBy: ".")[0]
    }
    
    public static var jm_currentTime:TimeInterval {
        return Date(timeIntervalSinceNow: 0).timeIntervalSince1970
    }
    
    public func jm_isSameDay() -> Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let nowComps = calendar.dateComponents(unit, from: Date())
        let selfCmps = calendar.dateComponents(unit, from: self)
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (selfCmps.day == nowComps.day)
    }
    
    public func jm_isYesterday() -> Bool {
        let calendar = Calendar.current
        let unit:Set<Calendar.Component> = [.day,.month,.year]
        let nowComps = calendar.dateComponents(unit, from: Date())
        let selfCmps = calendar.dateComponents(unit, from: self)
        let count = nowComps.day! - selfCmps.day!
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (count == 1)
    }
    
    public func jm_isSameYear() -> Bool {
        let calendar = Calendar.current
        let nowComps = calendar.component(.year, from: Date())
        let selfComps = calendar.component(.year, from: self)
        return (nowComps == selfComps)
    }
}

