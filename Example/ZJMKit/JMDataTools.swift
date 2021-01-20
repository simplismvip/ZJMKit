//
//  JMDataTools.swift
//  ZJMKit_Example
//
//  Created by JunMing on 2021/1/20.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import HandyJSON

public struct JMDataTools {
    /// 解析本地[model,model,model,]结构json
    static public func parseJson<T: HandyJSON>(name: String, ofType: String = "json") -> [T] {
        guard let path = bundle()?.path(forResource: name, ofType: ofType) else { return [T]() }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else { return [T]() }
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) else { return [T]() }
        return parseJson(obj: obj)
    }
    
    /// 解析本地[model,model,model,]结构json
    static public func pathJson<T: HandyJSON>(name: String, ofType: String = "json") -> [T] {
        guard let path = Bundle.main.path(forResource: name, ofType: ofType) else { return [T]() }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else { return [T]() }
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) else { return [T]() }
        return parseJson(obj: obj)
    }
    
    /// 解析本地[[model],[model],[model],]结构json
    static public func parseJsonItems<T: HandyJSON>(name: String, ofType: String = "json") -> [[T]] {
        guard let path = bundle()?.path(forResource: name, ofType: ofType) else { return [[T]]() }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else { return [[T]]() }
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) else { return [[T]]() }
        guard let bookInfoDic = obj as? [[Dictionary<String, Any>]] else { return [[T]]() }
        return bookInfoDic.map { parseJson(obj: $0) }
    }
    
    /// 解析整体。例如shelf.json可以整体解析
    static public func parseJson<T: HandyJSON>(obj: Any) -> [T] {
        guard let bookInfoDic = obj as? [Dictionary<String, Any>] else { return [T]() }
        return parse(items: bookInfoDic)
    }
    
    /// 解析拆分后的
    static public func parse<T: HandyJSON>(items: [Dictionary<String, Any>]) -> [T] {
        return items.map { T.deserialize(from: $0) }.compactMap { $0 }
    }
    
    static public func bundle() -> Bundle? {
        return Bundle.main
    }
}

struct JMStrToClass {
    static func jmClassFrom(_ className: String) -> AnyClass? {
        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            let fullClassName = appName + "." + className
            return NSClassFromString(fullClassName)
        } else {
            print("🈳️🈳️🈳️appName为空🈳️")
        }
        return nil
    }
}
