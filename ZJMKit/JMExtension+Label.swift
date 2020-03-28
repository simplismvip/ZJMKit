//
//  JMExtension+Label.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/3/28.
//

import UIKit
extension UILabel {
    open func configLabel(alig:NSTextAlignment = .left,font:UIFont?,color:UIColor = UIColor.gray) {
        self.numberOfLines = 0
        self.textColor = color
        self.font = font
        self.textAlignment = alig
    }
}
