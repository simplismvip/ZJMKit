//
//  JMPublicProtocol.swift
//  Alamofire
//
//  Created by JunMing on 2020/4/14.
//

import Foundation

public protocol JMOpenEmailProtocol { }
extension JMOpenEmailProtocol {
    public func jm_openEmail(_ them:String, _ toEmail:String, _ ccEmail:String?, _ content:String) {
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
