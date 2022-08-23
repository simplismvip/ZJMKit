//
//  JMFileTools.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/3/28.
//  Copyright © 2022 JunMing. All rights reserved.
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
    open class func jmGetFilesBytesByPath(_ path: String) -> String {
        var sumSize: NSInteger = 0
        let isDirectory = unsafeBitCast(false, to: UnsafeMutablePointer<ObjCBool>.self)
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
    
    // MARK:Plist用例
    ///创建plist 用法  let myDic=NSMutableDictionary() myDic.setValue("value", forKey: "key1")  CommonFunction.CreatePlistFile("test").SetPlistFileValue("test", Key: "key", Dictionary: myDic )
    class func jmCreatePlistFile(_ plistname:String ) {
        let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + (plistname+".plist") //获取到plist文件路径
        //不存在plist文件就创建
        if FileManager.default.fileExists(atPath: path) == false {
            let fileManager: FileManager = FileManager.default
            //创建plist
            fileManager.createFile(atPath: path, contents: nil, attributes: nil)
            let Dictionary = NSMutableDictionary()
            Dictionary.write(toFile: path, atomically: true)  //写入
        }
    }
    ///写入plist值 ：注：Key不可重复 重复不添加
    func jmSetPlistFileValue(_ plistname:String,Key:String,Dictionary:NSMutableDictionary) {
        let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + (plistname+".plist")
        let  dataDictionary = NSMutableDictionary(contentsOfFile: path)
        if(dataDictionary?.object(forKey: Key) != nil){
            return
        }else{
            //添加数据
            dataDictionary?.setValue(Dictionary, forKey: Key)
        }
        //重新写入到plist
        dataDictionary?.write(toFile: path, atomically: true)
    }
    ///获取plist所有对象 返回 NSMutableDictionary
    func jmGetAllPlistFileValue(_ plistname:String)->NSMutableDictionary {
        let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + (plistname+".plist")
        //读取plist文件的内容
        let  dataDictionary = NSMutableDictionary(contentsOfFile: path)
        
        return dataDictionary!
    }
    ///获取plist的Key对象 返回 NSDictionary
    func jmGetKeyPlistFileValue(_ plistname:String,Key:String)->NSDictionary {
        let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + (plistname+".plist")
        
        //获取到plist文件路径
        var dic:NSDictionary?
        
        //读取plist文件的内容
        let  dataDictionary = NSMutableDictionary(contentsOfFile: path)
        if((dataDictionary?.allKeys.count)!>0){
            dic=(dataDictionary?.object(forKey: Key))! as? NSDictionary
        }
        return dic!
    }
    ///删除plist的所有对象
    func jmDelAllPlistValue(_ plistname:String)->NSMutableDictionary{
        let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + (plistname+".plist") 
        let  dataDictionary = NSMutableDictionary(contentsOfFile: path)
        if((dataDictionary?.allKeys.count)!>0){
            dataDictionary?.removeAllObjects()  //全部删除
            //重新写入到plist
            dataDictionary?.write(toFile: path, atomically: true)
        }
        return dataDictionary!
    }
    ///删除plist的Key对象
    func jmDelKeyPlistValue(_ plistname:String,Key:String)->NSMutableDictionary{
        let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + (plistname+".plist")
        let  dataDictionary = NSMutableDictionary(contentsOfFile: path)
        if((dataDictionary?.allKeys.count)!>0){
            dataDictionary?.removeObject(forKey: Key) //删除
            //重新写入到plist
            dataDictionary?.write(toFile: path, atomically: true)
        }
        return dataDictionary!
        
    }
    
    /// 获取文本字符串
    static func jmFile(jsName:String, type:String) -> String? {
        guard let path = Bundle.main.path(forResource: jsName, ofType: type) else { return nil }
        return try? String(contentsOfFile: path, encoding: .utf8)
    }
    
    /// 获取bundle文件路径
    static func jmPathBundle(jsName:String, type:String) -> String? {
        guard let path = Bundle.main.path(forResource: jsName, ofType: type) else { return nil }
        return path
    }
}
