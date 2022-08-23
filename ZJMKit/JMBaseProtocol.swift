//
//  JMBaseProtocol.swift
//  ZJMKit
//
//  Created by JunMing on 2021/1/19.
//  Copyright © 2022 JunMing. All rights reserved.
//

import Foundation

extension NSObject {
    public var jmMapValue: [String: Any] {
        get {
            guard let dicInfo = objc_getAssociatedObject(self, jmIdentifier(self)) as? [String: Any] else {
                self.jmMapValue = [String: Any]()
                return self.jmMapValue
            }
            return dicInfo
        }
        set { objc_setAssociatedObject(self, jmIdentifier(self), newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
}
