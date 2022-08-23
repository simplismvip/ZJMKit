//
//  InitClass.swift
//  ZJMKit
//
//  Created by JunMing on 2022/8/5.
//  Copyright © 2022 JunMing. All rights reserved.
//

import UIKit

public struct InitClass<T: NSObject> {
    public static func instance(className: String, bundle: Bundle) -> T? {
        guard let clazz = classFrom(className: className, bundle: bundle) as? T.Type else {
            return nil
        }
        return clazz.init()
    }
    
    static func classFrom(className: String, bundle: Bundle) -> AnyClass? {
        guard let appName = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String else {
            return nil
        }
        
        guard let newClass = NSClassFromString(appName + "." + className) else {
            return nil
        }
        
        return newClass
    }
}

extension Bundle {
    /// 当前项目bundle
    public static func bundle(_ source: AnyObject.Type) -> Bundle {
        return Bundle(for: source)
    }
    
    /// 获取bundle中文件路径
    public static func path(resource: String, ofType: String, source: AnyObject.Type) -> String? {
        return Bundle.bundle(source).path(forResource: resource, ofType: ofType)
    }
}
