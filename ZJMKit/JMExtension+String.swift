//
//  JMExtension+String.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/3/28.
//  Copyright © 2022 JunMing. All rights reserved.
//

import Foundation
extension String {
    /// 中文转英文
    public func jmTransformChinese() -> String {
        let mutabString = self.mutableCopy() as! CFMutableString
        CFStringTransform(mutabString, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(mutabString, nil, kCFStringTransformStripCombiningMarks, false)
        return mutabString as String
    }
    
    /// 获取字符串size
    public func jmSizeWithFont(_ font:UIFont,_ maxW:CGFloat,_ space:CGFloat = 4, wordSpace:CGFloat = 4) -> CGSize {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = .byCharWrapping;
        paraStyle.lineSpacing = space; //设置行间距
        
        let attrsDic = [.font:font, .paragraphStyle:paraStyle,.kern:wordSpace] as [NSAttributedString.Key : Any]
        let maxSize = CGSize(width: maxW, height: CGFloat(MAXFLOAT))
        return self.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrsDic, context: nil).size
    }
    
//    private func jmSizecache() -> NSCache<String, String>? {
//        var sizeCache:NSCache<String, String>?
//        DispatchQueue.once(token: "") {
//            sizeCache = NSCache()
//        }
//        return sizeCache
//    }
    
    /// 获取字符串size
    public func jmSizeWithFont(_ font: UIFont) -> CGSize {
        return jmSizeWithFont(font, CGFloat(MAXFLOAT))
    }
    
    /// 时间戳字符串格式化
    public func jmFormatTspString(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String? {
        // 1578039791.520024
        if let time = Double(self) {
            let date = Date(timeIntervalSince1970: time)
            let dfmatter = DateFormatter()
            dfmatter.dateFormat = format
            return dfmatter.string(from: date)
        }
        return nil
    }
    
    /// 字符串转swift类
    public func jmClassFromString() -> UIViewController? {
        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
            let className = appName + "." + self
            if let newClass = NSClassFromString(className) as? UIViewController.Type {
                return newClass.init() as UIViewController
            }
            // OC类需要用这个方式
            if let newClass = NSClassFromString(self) as? UIViewController.Type {
                return newClass.init() as UIViewController
            }
            return nil
        }
        return nil
    }
    
    /// 调整字符串间距
    public func jmAttribute(_ font: UIFont, alignment:NSTextAlignment = .left, space:CGFloat = 4) -> NSMutableAttributedString {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = .byCharWrapping;
        paraStyle.alignment = alignment;
        paraStyle.lineSpacing = space; //设置行间距
        paraStyle.hyphenationFactor = 1.0;
        paraStyle.firstLineHeadIndent = 0.0;
        paraStyle.paragraphSpacingBefore = 0.0; //段落缩进
        paraStyle.headIndent = 0;
        paraStyle.tailIndent = 0;
        let dicInfo = [.font:font, .paragraphStyle:paraStyle, .kern:5,] as [NSAttributedString.Key : Any]
        return NSMutableAttributedString(string: self, attributes: dicInfo)
    }
    
    /// 调整字符串间距
    public func jmAttriSpaces(_ font:UIFont, alignment:NSTextAlignment = .left, space:CGFloat = 4,wordSpace:CGFloat = 4) -> NSMutableAttributedString {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = .byCharWrapping;
        paraStyle.alignment = alignment;
        paraStyle.lineSpacing = space; //设置行间距
        let dicInfo = [.font:font, .paragraphStyle:paraStyle,.kern:wordSpace] as [NSAttributedString.Key : Any]
        return NSMutableAttributedString(string: self, attributes: dicInfo)
    }
}
