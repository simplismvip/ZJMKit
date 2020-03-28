//
//  JMExtension+String.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/3/28.
//

import Foundation
extension String {
    /// 中文转英文
    public func jm_transformChinese() -> String {
        let mutabString = self.mutableCopy() as! CFMutableString
        CFStringTransform(mutabString, nil, kCFStringTransformMandarinLatin, false)
        CFStringTransform(mutabString, nil, kCFStringTransformStripCombiningMarks, false)
        return mutabString as String
    }
    
    /// 获取字符串size
    public func jm_sizeWithFont(_ font:UIFont,_ maxW:CGFloat) -> CGSize {
        let attrsDic:[NSAttributedString.Key:Any] = [NSAttributedString.Key.font:font]
        let maxSize = CGSize(width: maxW, height: CGFloat(MAXFLOAT))
        return self.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrsDic, context: nil).size
    }
    
    /// 获取字符串size
    public func jm_sizeWithFont(_ font:UIFont) -> CGSize {
        return jm_sizeWithFont(font, CGFloat(MAXFLOAT))
    }
    
    /// 时间戳字符串格式化
    public func jm_formatTspString(_ format:String = "yyyy-MM-dd HH:mm:ss") -> String? {
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
    public func jm_classFromString() -> UIViewController? {
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
    public func jm_attribute(_ font:UIFont, alignment:NSTextAlignment = .left, space:CGFloat = 4) -> NSMutableAttributedString {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = .byCharWrapping;
        paraStyle.alignment = alignment;
        paraStyle.lineSpacing = space; //设置行间距
        paraStyle.hyphenationFactor = 1.0;
        paraStyle.firstLineHeadIndent = 0.0;
        paraStyle.paragraphSpacingBefore = 0.0; //段落缩进
        paraStyle.headIndent = 0;
        paraStyle.tailIndent = 0;
        let dicInfo = [.font:font, .paragraphStyle:paraStyle, .kern:1.5,] as [NSAttributedString.Key : Any]
        return NSMutableAttributedString(string: self, attributes: dicInfo)
    }
    
    public func jm_attrStrAddTarget(_ targetStr:String, action:@escaping (_ str:String) -> Void) -> NSMutableAttributedString {
        let attrStr = jm_attribute(UIFont.regular(11)!,alignment:.center,space:1)
        let nsRange = NSString(string: self).range(of: targetStr)
        attrStr.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
        let dicInfo = [.foregroundColor:UIColor.gray] as [NSAttributedString.Key : Any]
        attrStr.addAttributes(dicInfo, range: NSRange(location: 0, length: self.count))
//        attrStr.setTextHighlight(nsRange, color: UIColor.orange, backgroundColor: UIColor.white) { (containerView, text, range, rect) in
//           action(targetStr)
//        }
        return attrStr
    }
}
