//
//  JMLogger.swift
//  ZJMKit
//
//  Created by jh on 2022/8/23.
//

import UIKit

public struct JMLogger {
    public enum Level: String {
        case debug = "🐝 "
        case info = "ℹ️ "
        case warning = "⚠️ "
        case error = "🆘 "
    }
    
    static public func debug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        JMLogger.eBookPrint(items, separator: separator, terminator: terminator, level: .debug)
    }
    
    static public func info(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        JMLogger.eBookPrint(items, separator: separator, terminator: terminator, level: .info)
    }
    
    static public func warning(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        JMLogger.eBookPrint(items, separator: separator, terminator: terminator, level: .warning)
    }
    
    static public func error(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        JMLogger.eBookPrint(items, separator: separator, terminator: terminator, level: .error)
    }
    
    private static func eBookPrint(_ items: Any..., separator: String = " ", terminator: String = "\n", level: Level){
        #if DEBUG
        print("\(level.rawValue)：\(items)", separator: separator, terminator: terminator)
        #endif
    }
    
    /// 写入本地错误logger
    public static func writeError(_ error: String) {
        guard let cachePath = JMTools.jmCachePath() else {
            return
        }
        
        let loggerPath = cachePath + "/logger.txt"
        if !FileManager.default.fileExists(atPath: loggerPath) {
            do {
                try "Start".write(toFile: loggerPath, atomically: true, encoding: .utf8)
            } catch  {
                JMLogger.debug("错误")
            }
        }
        
        let filehandle = FileHandle(forUpdatingAtPath: loggerPath)
        filehandle?.seekToEndOfFile()
    }
}
