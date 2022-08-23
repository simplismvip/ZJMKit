//
//  JMPublicProtocol.swift
//  Alamofire
//
//  Created by JunMing on 2020/4/14.
//  Copyright © 2022 JunMing. All rights reserved.
//

import Foundation

/// 常用位置枚举，
public enum JMPosition {
    case top          //图片在上，文字在下，垂直居中对齐
    case bottom       //图片在下，文字在上，垂直居中对齐
    case left         //图片在左，文字在右，水平居中对齐
    case right        //图片在右，文字在左，水平居中对齐
}

public protocol JMOpenEmailProtocol { }
extension JMOpenEmailProtocol {
    /// 打开系统邮箱协议
    public func jmOpenEmail(_ them:String, _ toEmail:String, _ ccEmail:String?, _ content:String) {
        let mailUrl = NSMutableString()
        // 添加收件人
        mailUrl.appendFormat("mailto:%@,", toEmail)
        if let ccmail = ccEmail {
            // 添加抄送
            mailUrl.appendFormat("?cc=%@,", ccmail)
        }
        // 添加主题
        mailUrl.appendFormat("&subject=%@", them)
        // 添加正文
        mailUrl.appendFormat("&body=<b>%@", content)
        let character = NSCharacterSet(charactersIn: "`#%^{}\"[]|\\<> ").inverted
        guard let em = mailUrl.addingPercentEncoding(withAllowedCharacters: character) else { return }
        if let emailUrl = URL(string: em) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(emailUrl, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
