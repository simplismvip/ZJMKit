//
//  JMExtension+View.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/3/28.
//

import UIKit

extension UIView {
    open var jm_x:CGFloat {
        get { return self.frame.origin.x }
        set (newX) {
            var frame = self.frame
            frame.origin.x = newX
            self.frame = frame
        }
    }
    
    open var jm_y:CGFloat {
        get { return self.frame.origin.y; }
        set (newY) {
            var frame = self.frame
            frame.origin.y = newY
            self.frame = frame;
        }
    };
    
    open var jm_width:CGFloat {
        get { return self.frame.size.width; }
        set (newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame;
        }
        
    };
    
    open var jm_height:CGFloat {
        get { return self.frame.size.height; }
        set (newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    };
    
    open var jm_size:CGSize {
        get { return self.frame.size; }
        set (newSize) {
            var frame = self.frame
            frame.size = newSize
            self.frame = frame
        }
    };
    
    open var jm_origin:CGPoint {
        get { return self.frame.origin; }
        set (newOrigin) {
            var frame = self.frame
            frame.origin = newOrigin
            self.frame = frame
        }
    };
    
    open var jm_centerX:CGFloat {
        get { return self.center.x; }
        set (newCenterX) {
            var center = self.center
            center.x = newCenterX
            self.center = center
        }
    };
    
    open var jm_centerY:CGFloat {
        get { return self.center.y; }
        set (newCenterY) {
            var center = self.center
            center.y = newCenterY
            self.center = center
        }
    };
    
    open var jm_maxX:CGFloat {
        get { return self.jm_x+self.jm_width; }
        set (newMaxX) {
            var temp = self.frame
            temp.origin.x = newMaxX-self.jm_width
            self.frame = temp
        }
    };
    
    open var maxY:CGFloat {
        get { return self.jm_y+self.jm_height; }
        set (newMaxY) {
            var temp = self.frame
            temp.origin.x = newMaxY-self.jm_height
            self.frame = temp
        }
    };
}

// MARK： -- 常用方法 -- 
extension UIView {
    /// View截图
    open func jmScreenCapture() -> UIImage? {
        let scale = UIScreen.main.scale
        let width = bounds.size.width*scale
        let height = bounds.size.height*scale
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        layer.render(in: ctx!)
        
        let inImageRef = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        guard let outImageRef = inImageRef?.cropping(to:CGRect(x: 0, y: 0, width: width, height: height)) else {
            return nil
        }
        
        let nImage = UIImage(cgImage:outImageRef)
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
