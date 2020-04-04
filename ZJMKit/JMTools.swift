//
//  JMTools.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/3/28.
//

import UIKit

open class JMTools { 
    /// 获取document路径
    open class func jmDocuPath() ->String? {
        let documentDir = FileManager.SearchPathDirectory.documentDirectory
        let domainMask = FileManager.SearchPathDomainMask.allDomainsMask
        return NSSearchPathForDirectoriesInDomains(documentDir,domainMask, true).first
    }
    
    /// 获取home路径
    open class func jmHomePath() ->String? {
        return NSHomeDirectory()
    }
    
    /// 获取Cache路径
    open class func jmCachePath() ->String? {
        let documentDir = FileManager.SearchPathDirectory.cachesDirectory
        let domainMask = FileManager.SearchPathDomainMask.allDomainsMask
        return NSSearchPathForDirectoriesInDomains(documentDir,domainMask, true).first
    }
    
    /// 获取temp路径
    open class func jmTempPath() ->String? {
        return NSTemporaryDirectory()
    }
    
    /// 判断document文件是否存在
    open class func jmDocuFileExist(fileName name:String) ->Bool {
        if let docuPath = jmDocuPath() {
            let toPath = docuPath+"/"+name
            return FileManager.default.fileExists(atPath: toPath)
        }else {
            return false
        }
    }
    
    /// 字符串编码
    open class func jmEncodding(bookUrl url:String) ->String? {
        return url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    /// 屏幕宽度
    open class func jmWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    /// 屏幕高度
    open class func jmHeigh() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    /// 归档对象，需遵循Encodable协议
    open class func jmEncodeObject<T:Encodable>(_ object:T,archPath:String) {
        DispatchQueue.global().async {
            do {
                let data = try PropertyListEncoder().encode(object)
                NSKeyedArchiver.archiveRootObject(data, toFile: archPath)
            }catch let error {
                print("data cache \(error.localizedDescription)!!!⚽️⚽️⚽️")
            }
        }
    }
    
    /// 解档对象，需遵循Encodable协议
    open class func jmDecodeObject<T:Codable>(archPath:String,_ complate:@escaping (T?)->()) {
        DispatchQueue.global().async {
            guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: archPath) as? Data else {
                DispatchQueue.main.async { complate(nil) }
                return
            }
            
            do {
                let object = try PropertyListDecoder().decode(T.self, from: data)
                DispatchQueue.main.async { complate(object) }
            }catch let error {
                print("data cache \(error.localizedDescription)!!!⚽️⚽️⚽️")
            }
        }
    }
    
}
