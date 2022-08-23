//
//  DataParser.swift
//  ZJMKit
//
//  Created by JunMing on 2022/8/5.
//  Copyright © 2022 JunMing. All rights reserved.
//

import UIKit

public struct DataParser<T: Codable> {
    /// 解析数据模型，需要传入bundle
    public static func decode(name: String, bundle: Bundle, ext: String = "json") -> T? {
        if let url = bundle.url(forResource: name, withExtension: ext) {
            do {
                let data = try Data(contentsOf: url)
                return parser(data)
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    /// 解析数据模型 Data -> Model
    public static func parser(_ data: Data) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    /// Json -> Data
    public static func jsonData(_ param: Any) -> Data? {
        if !JSONSerialization.isValidJSONObject(param) {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            return nil
        }
        return data
    }
    
    /// Model -> Dictionary
    public static func encode(_ model: T) -> [String: Any]? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        guard let data = try? encoder.encode(model) else {
            return nil
        }
        
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] else {
            return nil
        }
        
        return dict
    }
    
    /// Model -> JsonString
    public static func encodeToString(_ model: T) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        guard let data = try? encoder.encode(model) else {
            return nil
        }
        
        guard let jsonStr = String(data: data, encoding: .utf8) else {
            return nil
        }
        return jsonStr
    }
}

extension DataParser {
    public static func request(path: String, callback: @escaping (T?) -> Void) {
        guard let url = URL(string: path) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            DispatchQueue.main.async {
                if let data = data, (response as? HTTPURLResponse)?.statusCode == 200 {
                    callback(parser(data))
                } else {
                    callback(nil)
                }
            }
        }
        .resume()
    }
}

extension Dictionary {
    public var data: Data? {
        if !JSONSerialization.isValidJSONObject(self) {
            return nil
        }
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        return data
    }
}
