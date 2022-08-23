//
//  JMTools.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/3/28.
//  Copyright © 2022 JunMing. All rights reserved.
//

import UIKit

open class JMTools {
    /// 获取document路径Url
    open class func jmDescpath() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    /// 获取document路径
    open class func jmDocuPath() -> String? {
        let documentDir = FileManager.SearchPathDirectory.documentDirectory
        let domainMask = FileManager.SearchPathDomainMask.allDomainsMask
        return NSSearchPathForDirectoriesInDomains(documentDir,domainMask, true).first
    }
    
    /// 获取home路径
    open class func jmHomePath() -> String? {
        return NSHomeDirectory()
    }
    
    /// 获取Cache路径
    open class func jmCachePath() -> String? {
        let documentDir = FileManager.SearchPathDirectory.cachesDirectory
        let domainMask = FileManager.SearchPathDomainMask.allDomainsMask
        return NSSearchPathForDirectoriesInDomains(documentDir,domainMask, true).first
    }
    
    /// 获取temp路径
    open class func jmTempPath() -> String? {
        return NSTemporaryDirectory()
    }
    
    /// 判断document文件是否存在
    open class func jmDocuFileExist(fileName name: String) -> Bool {
        if let docuPath = jmDocuPath() {
            let toPath = docuPath+"/"+name
            return FileManager.default.fileExists(atPath: toPath)
        }else {
            return false
        }
    }
    
    /// 字符串编码
    open class func jmEncodding(bookUrl url: String) -> String? {
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
    open class func jmEncodeObject<T: Encodable>(_ object: T, archPath: String) {
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
    open class func jmDecodeObject<T: Codable>(archPath: String, _ complate: @escaping (T?)->()) {
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
    
    /// 获取当前展示的Controller
    open class func jmShowTopVc() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow else { return nil }
        guard var topVC = window.rootViewController else { return nil }
        while true {
            if let newVc = topVC.presentedViewController {
                topVC = newVc
            }else if topVC.isKind(of: UINavigationController.self) {
                let navVC = topVC as? UINavigationController
                if let topNavVC = navVC?.topViewController {
                    topVC = topNavVC
                }
            }else if topVC.isKind(of: UITabBarController.self) {
                let tabVC = topVC as? UITabBarController
                if let selTabVC = tabVC?.selectedViewController {
                    topVC = selTabVC
                }
            }else{
                break
            }
        }
        return topVC
    }
    
    /// 取出某个对象的地址
    open class func jmGetAnyObjectMemoryAddress(object: AnyObject) -> String {
        let str = Unmanaged<AnyObject>.passUnretained(object).toOpaque()
        return String(describing: str)
    }
    
    /// 对比两个对象的地址是否相同
    open class func jmEquateable(object1: AnyObject, object2: AnyObject) -> Bool {
        let str1 = jmGetAnyObjectMemoryAddress(object: object1)
        let str2 = jmGetAnyObjectMemoryAddress(object: object2)
        
        if str1 == str2 {
            return true
        } else {
            return false
        }
    }
}

public class JMUtility {
    private let hightLabel = UILabel()
    private var contSize = Dictionary<String, CGSize>()
    private let width = UIScreen.main.bounds.size.width
    public static let share: JMUtility = {
        let util = JMUtility()
        util.hightLabel.numberOfLines = 0
        return util
    }()
    
    public func contentSize(textAttri: NSMutableAttributedString, textID: String, maxW: CGFloat, font: UIFont) -> CGSize {
        if let size = contSize[textID] {
            return size
        }else {
            hightLabel.font = font
            hightLabel.attributedText = textAttri
            let maxSize = CGSize(width: maxW, height: CGFloat.greatestFiniteMagnitude)
            let size = hightLabel.sizeThatFits(maxSize)
            contSize[textID] = size
            return size
        }
    }
    
    /// 获取Size，供外部使用
    public func getContentSize(textID: String) -> CGSize? {
        return contSize[textID]
    }
    
    /// 设置Size，供外部使用
    public func setContentSize(textID: String, size: CGSize) {
        contSize[textID] = size
    }
    
    /// 语音
    public func audioContentSize(duration: CGFloat, maxW: Double) -> CGSize {
        // 使用公式 长度 = (最长－最小)*(2/pi)*artan(时间/10)+最小，
        // 在10秒时变化逐渐变缓，随着时间增加 无限趋向于最大值
        let value = 2.0 * atan((Double(duration)/1000.0-1.0)/10.0)/Double.pi
        let minW = Double(64)
        return CGSize(width: (maxW - minW) * value + minW, height: 30.0)
    }
    
    /// 图片
    public func imageContentSize(size: CGSize, thumbPath: String?) -> CGSize {
        let minW = width / 4.0
        let minH = width / 4.0
        let maxW = width - 184
        let maxH = width - 184
        
        var imageSize = CGSize.zero
        if size != CGSize.zero {
            imageSize = size
        }else {
            if let path = thumbPath, let image = UIImage(contentsOfFile: path) {
                imageSize = image.size
            }
        }
        return sizeWithImageOriginSize(oriSize: imageSize, minSize: CGSize(width: minW, height: minH), maxSize: CGSize(width: maxW, height: maxH))
    }
    
    /// 计算照片比例
    public func sizeWithImageOriginSize(oriSize: CGSize, minSize: CGSize, maxSize: CGSize) -> CGSize{
        var size = CGSize.zero
        let oriWidth = oriSize.width
        let oriHeight = oriSize.height
        
        let minWidth = minSize.width
        let minHeight = minSize.height
        
        let maxWidth = maxSize.width
        let maxHeight = maxSize.height
        
        if oriWidth > oriHeight {//宽图
            size.height = minHeight;  //高度取最小高度
            size.width = oriWidth * minWidth / oriHeight;
            if size.width > maxWidth {
                size.width = maxWidth
            }
        }else if oriWidth < oriHeight {//高图
            size.width = minWidth;
            size.height = oriHeight * minWidth / oriWidth;
            if (size.height > maxHeight) {
                size.height = maxHeight;
            }
        }else {//方图
            if (oriWidth > maxWidth) {
                size.width = maxWidth;
                size.height = maxHeight;
            }else if(oriWidth > minWidth) {
                size.width = oriWidth;
                size.height = oriHeight;
            }else{
                size.width = minWidth;
                size.height = minHeight;
            }
        }
        return size
    }
}
