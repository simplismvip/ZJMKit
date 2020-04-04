//
//  JMFileTools.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/3/28.
//

import UIKit

open class JMFileTools {
    /// 根据后缀获取文件
    open class func jmGetFileFromDir(_ dir:String,_ subffix:String) -> Array<String> {
        var nameArr = [String]()
        let manager = FileManager.default
        if let array = try? manager.contentsOfDirectory(atPath: dir) {
            for name in array {
                if name.hasSuffix(subffix){
                    nameArr.append(name)
                }
            }
        }
        return nameArr
    }
    
    /// 删除文件
    open class func jmDeleteFile(_ fromPath:String) {
        do{
            let manager = FileManager.default
            if manager.fileExists(atPath: fromPath) && manager.isDeletableFile(atPath: fromPath) {
                try manager.removeItem(atPath: fromPath)
            }
        }catch{
            print(error)
        }
    }
    
    /// 移动文件
    open class func jmMoveFile(_ fromPath:String, _ toPath:String) {
        if !FileManager.default.fileExists(atPath: toPath) {
            do {
                try FileManager.default.copyItem(atPath: fromPath, toPath: toPath)
            }catch {
                print(error)
            }
        }
    }
    
    /// 创建文件夹
    open class func jmCreateFolder(_ folderPath:String) {
        let manager = FileManager.default
        if !manager.fileExists(atPath: folderPath) {
            do{
                try manager.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
                print("Succes to create folder")
            }
            catch{
                print("Error to create folder")
            }
        }
    }
    
    /// 计算缓存文件大小
    open class func jmFileSizeOfCache()-> String {
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        var sumSize:NSInteger = 0
        for file in fileArr! {
            if let path = cachePath?.appendingFormat("/\(file)") {
                sumSize += NSInteger(jmGetSize(path))
            }
        }
        return jmTransBytes(sumSize)
    }
    
    /// 获取文件大小，返回值没有转换，是字节数
    open class func jmGetSize(_ path: String)->UInt64 {
        var fileSize : UInt64 = 0
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: path)
            fileSize += attr[FileAttributeKey.size] as! UInt64
        } catch {
            print("Error: \(error)")
        }
        return fileSize
    }
    
    /// 清空缓存文件
    open class func jmClearCache() {
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        for file in fileArr! {
            if let path = cachePath?.appendingFormat("/\(file)") {
                if FileManager.default.fileExists(atPath: path) {
                    do {
                        try FileManager.default.removeItem(atPath: path)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    /// 返回值有转换，返回值是字符串
    open class func jmGetFilesBytesByPath(_ path:String) ->String {
        var sumSize:NSInteger = 0
        var isDirectory: UnsafeMutablePointer<ObjCBool>?
        if FileManager.default.fileExists(atPath: path, isDirectory: isDirectory) {
            sumSize = NSInteger(jmGetSize(path))
        }
        return jmTransBytes(sumSize)
    }
    
    /// bit字节数转字符串
    open class func jmTransBytes(_ sumSize:NSInteger = 0) ->String {
        var str:String = ""
        var tempSize = sumSize
        if sumSize < 1024 {
            str = str.appendingFormat("%d B", sumSize)
        }else if sumSize > 1024 && sumSize < 1024*1024 {
            tempSize = tempSize/1024
            str = str.appendingFormat("%d Kb", tempSize)
        }else if sumSize > 1024*1024 && sumSize < 1024*1024*1024 {
            tempSize = tempSize/1024/1024
            str = str.appendingFormat("%d Mb", tempSize)
        }
        return str
    }
}
