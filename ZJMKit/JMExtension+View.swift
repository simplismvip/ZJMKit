//
//  JMExtension+View.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/3/28.
//

import UIKit

extension UIView {
    open var jm_x:CGFloat {
        get {
            return self.frame.origin.x
        }
        set (newX) {
            var frame = self.frame
            frame.origin.x = newX
            self.frame = frame
        }
    }
    
    open var jm_y:CGFloat {
        get {
            return self.frame.origin.y;
        }
        set (newY) {
            var frame = self.frame
            frame.origin.y = newY
            self.frame = frame;
        }
    };
    
    open var jm_width:CGFloat {
        get {
            return self.frame.size.width;
        }
        set (newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame;
        }
        
    };
    
    open var jm_height:CGFloat {
        get {
            return self.frame.size.height;
        }
        set (newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    };
    
    open var jm_size:CGSize {
        get {
            return self.frame.size;
        }
        set (newSize) {
            var frame = self.frame
            frame.size = newSize
            self.frame = frame
        }
    };
    
    open var jm_origin:CGPoint {
        get {
            return self.frame.origin;
        }
        set (newOrigin) {
            var frame = self.frame
            frame.origin = newOrigin
            self.frame = frame
        }
    };
    
    open var jm_centerX:CGFloat {
        get {
            return self.center.x;
        }
        set (newCenterX) {
            var center = self.center
            center.x = newCenterX
            self.center = center
        }
    };
    
    open var jm_centerY:CGFloat {
        get {
            return self.center.y;
        }
        set (newCenterY) {
            var center = self.center
            center.y = newCenterY
            self.center = center
        }
    };
    
    open var jm_maxX:CGFloat {
        get {
            return self.jm_x+self.jm_width;
        }
        set (newMaxX) {
            var temp = self.frame
            temp.origin.x = newMaxX-self.jm_width
            self.frame = temp
        }
    };
    
    open var maxY:CGFloat {
        get {
            return self.jm_y+self.jm_height;
        }
        set (newMaxY) {
            var temp = self.frame
            temp.origin.x = newMaxY-self.jm_height
            self.frame = temp
        }
    };
}

extension UIView {
    open func jmCcreenCapture() -> UIImage? {
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
    
    /// 获取当前展示的Controller
    open func jmFristShowView() -> UIView? {
        guard let window = UIApplication.shared.delegate?.window else { return nil }
        guard var topVC = window?.rootViewController else { return nil }
        while true {
            if let newVc = topVC.presentedViewController {
                topVC = newVc
            }else if topVC.isKind(of: UINavigationController.self) {
                let navVC = topVC as! UINavigationController
                if let topNavVC = navVC.topViewController {
                    topVC = topNavVC
                }
            }else if topVC.isKind(of: UITabBarController.self) {
                let tabVC = topVC as! UITabBarController
                if let selTabVC = tabVC.selectedViewController {
                    topVC = selTabVC
                }
            }else{
                break
            }
        }
        return topVC.view
    }
}
