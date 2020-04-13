//
//  JMExtension+Image.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/3/28.
//

import UIKit
// 渐变色类型
public enum GradientStyle {
    case leftToRight // 左 -> 渐变
    case leftToRadial // 发散 渐变
    case leftToBottom // 左 -> 下
}

extension UIImage {
    open var origin:UIImage { return withRenderingMode(.alwaysOriginal) }
    
    open var resizable:UIImage {
        let w = size.width * 0.5
        let h = size.height * 0.5
        let edge = UIEdgeInsets(top: h, left: w, bottom: h, right: w)
        return resizableImage(withCapInsets: edge,resizingMode: .stretch)
    }
    
    open class func jmGradientImage(_ gradientStyle:GradientStyle,_ colors:Array<UIColor>,_ frame:CGRect) -> UIImage? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        let cgColors = colors.map { return $0.cgColor }
        if gradientStyle == .leftToBottom {
            gradientLayer.colors = cgColors
            UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, false, UIScreen.main.scale)
            if let content = UIGraphicsGetCurrentContext() {
                gradientLayer.render(in: content)
                if let image = UIGraphicsGetImageFromCurrentImageContext() {
                    UIGraphicsEndImageContext()
                    return image
                }else {
                    UIGraphicsEndImageContext()
                    return nil
                }
            }
        }else if gradientStyle == .leftToRadial {
            UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, false, UIScreen.main.scale)
            let myColorspace = CGColorSpaceCreateDeviceRGB()
            let locations:[CGFloat] = [0.0, 1.0]
            
            let myCentrePoint = CGPoint(x: 0.5 * frame.size.width, y: 0.5 * frame.size.height)
            let myRadius = min(frame.size.width, frame.size.height) * 1.0
            if let context = UIGraphicsGetCurrentContext(),let myGradient = CGGradient(colorsSpace: myColorspace, colors: cgColors as CFArray, locations: locations) {
                context.drawRadialGradient(myGradient, startCenter: myCentrePoint, startRadius: 0, endCenter: myCentrePoint, endRadius: myRadius, options: .drawsAfterEndLocation)
                if let image = UIGraphicsGetImageFromCurrentImageContext() {
                    UIGraphicsEndImageContext()
                    return image
                }else {
                    UIGraphicsEndImageContext()
                    return nil
                }
            }
        }else if gradientStyle == .leftToRight {
            gradientLayer.colors = cgColors
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, false, UIScreen.main.scale)
            if let content = UIGraphicsGetCurrentContext() {
                gradientLayer.render(in: content)
                if let image = UIGraphicsGetImageFromCurrentImageContext() {
                    UIGraphicsEndImageContext()
                    return image
                }else {
                    UIGraphicsEndImageContext()
                    return nil
                }
            }
        }
        return nil
    }
}
