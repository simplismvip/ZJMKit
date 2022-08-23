//
//  JMExtension+View.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/3/28.
//  Copyright © 2022 JunMing. All rights reserved.
//

import UIKit

extension UIView {
    open var jmX: CGFloat {
        get { return self.frame.origin.x }
        set (newX) {
            var frame = self.frame
            frame.origin.x = newX
            self.frame = frame
        }
    }
    
    open var jmY: CGFloat {
        get { return self.frame.origin.y; }
        set (newY) {
            var frame = self.frame
            frame.origin.y = newY
            self.frame = frame;
        }
    };
    
    open var jmWidth: CGFloat {
        get { return self.frame.size.width; }
        set (newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame;
        }
        
    };
    
    open var jmHeight: CGFloat {
        get { return self.frame.size.height; }
        set (newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    };
    
    open var jmSize: CGSize {
        get { return self.frame.size; }
        set (newSize) {
            var frame = self.frame
            frame.size = newSize
            self.frame = frame
        }
    };
    
    open var jmOrigin: CGPoint {
        get { return self.frame.origin; }
        set (newOrigin) {
            var frame = self.frame
            frame.origin = newOrigin
            self.frame = frame
        }
    };
    
    open var jmCenterX: CGFloat {
        get { return self.center.x; }
        set (newCenterX) {
            var center = self.center
            center.x = newCenterX
            self.center = center
        }
    };
    
    open var jmCenterY: CGFloat {
        get { return self.center.y; }
        set (newCenterY) {
            var center = self.center
            center.y = newCenterY
            self.center = center
        }
    };
    
    open var jmMaxX: CGFloat {
        get { return self.jmX+self.jmWidth; }
        set (newMaxX) {
            var temp = self.frame
            temp.origin.x = newMaxX-self.jmWidth
            self.frame = temp
        }
    };
    
    open var jmMaxY: CGFloat {
        get { return self.jmY+self.jmHeight; }
        set (newMaxY) {
            var temp = self.frame
            temp.origin.x = newMaxY-self.jmHeight
            self.frame = temp
        }
    };
}

// MARK： -- 常用方法 -- 
extension UIView {
    /// View截图
    open func jmScreenCapture() -> UIImage? {
        let scale = UIScreen.main.scale
        let width = bounds.size.width * scale
        let height = bounds.size.height * scale
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        if let ctx = UIGraphicsGetCurrentContext() {
            layer.render(in: ctx)
        }
        
        guard let inImageRef = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            return nil
        }
        
        guard let outImageRef = inImageRef.cropping(to: CGRect.Rect(width, height)) else {
            return nil
        }
        
        let nImage = UIImage(cgImage: outImageRef)
        UIGraphicsEndImageContext()
        return nImage
    }
    
    // [.topLeft, .topRight]
    /// 切圆角，可自定义切哪个角
    open func jmRectCorner(by corners:UIRectCorner = [.topLeft, .topRight]) {
        let shaper = CAShapeLayer()
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 20, height: 20))
        shaper.path = path.cgPath
        layer.mask = shaper
    }
    
    /// 添加阴影，暂时支撑top和bottom
    open func jmAddShadow(_ color: UIColor, posion:JMPosition = .top, radius:CGFloat = 5, opacity:Float = 0.3) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        
        let width = bounds.size.width
        let height = bounds.size.height

        var shadowRect:CGRect
        switch posion {
        case .top:
            shadowRect = CGRect(x: 0, y: 0, width: width, height: 2)
        case .bottom:
            shadowRect = CGRect(x: 0, y: height-radius/2, width: width, height: 1)
        case .left:
            shadowRect = CGRect(x: 0, y: height, width: 1, height: height)
        case .right:
            shadowRect = CGRect(x: width-radius, y: height, width: 1, height: height)
        }
        let path = UIBezierPath(rect: shadowRect)
        layer.shadowPath = path.cgPath
    }
}
