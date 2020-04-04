//
//  JMUserDefault.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/3/28.
//

import UIKit

open class JMUserDefault {
    open class func readUrlByKey(_ key:String) -> URL? {
        if let url = UserDefaults.standard.url(forKey: key) {
            return url;
        }else {
            return nil;
        }
    }
    @discardableResult
    open class func setDefaultUrl(_ url:URL, key:String) ->Bool {
        UserDefaults.standard.set(url, forKey: key)
        return UserDefaults.standard.synchronize()
    }
    
    open class func readStringByKey(_ key:String) ->String? {
        if let str = UserDefaults.standard.object(forKey: key) {
            return str as? String
        }else {
            return nil
        }
    }
    
    @discardableResult
    open class func setString(_ str:String,_ key:String) ->Bool {
        UserDefaults.standard.set(str, forKey: key)
        return UserDefaults.standard.synchronize()
    }
    
    open class func readBoolByKey(_ key:String) ->Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    @discardableResult
    open class func setBool(_ bool:Bool, _ key:String) ->Bool {
        UserDefaults.standard.set(bool, forKey: key)
        return UserDefaults.standard.synchronize()
    }
    
    open class func readIntegerByKey(_ key:String) ->Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    @discardableResult
    open class func setInteger(_ int:Int, _ key:String) ->Bool {
        UserDefaults.standard.set(int, forKey: key)
        return UserDefaults.standard.synchronize()
    }
    
    open class func readDoubleByKey(_ key:String) ->Double {
        return UserDefaults.standard.double(forKey: key)
    }
    @discardableResult
    open class func setDouble(_ double:Double, _ key:String) ->Bool {
        UserDefaults.standard.set(double, forKey: key)
        return UserDefaults.standard.synchronize()
    }
    
    open class func readFloatKey(_ key:String) ->Float {
        return UserDefaults.standard.float(forKey: key)
    }
    @discardableResult
    open class func setFloat(_ float:Float, _ key:String) ->Bool {
        UserDefaults.standard.set(float, forKey: key)
        return UserDefaults.standard.synchronize()
    }
}
