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
    
    /// 压缩图片
    open func jmCompressImage(maxLength: CGFloat = 153600) ->Data? {
        var compression:CGFloat = 1
        var data = UIImageJPEGRepresentation(self, compression)
        if let count = data?.count, CGFloat(count) < maxLength { return data }
        var max:CGFloat = 1
        var min:CGFloat = 0
        for _ in 0..<6 {
            compression = (max+min)/2
            data = UIImageJPEGRepresentation(self, compression)
            if let count = data?.count, CGFloat(count) < maxLength * 0.9 {
                min = compression
            }else if let count = data?.count, CGFloat(count) > maxLength {
                max = compression
            }else {
                break
            }
        }
        guard var newdata = data else { return nil }
        if CGFloat(newdata.count) < maxLength { return newdata }
        guard let resultImage = UIImage(data: newdata) else { return nil }
        
        var lastDataLength:Int = 0
        while newdata.count > Int(maxLength) && newdata.count != lastDataLength {
            lastDataLength = newdata.count
            let ratio = CGFloat(maxLength) / CGFloat(newdata.count)
            let size = CGSize(width: (resultImage.size.width * sqrt(ratio)), height: resultImage.size.height * sqrt(ratio))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect.Rect(0, 0, size.width, size.height))
            guard UIGraphicsGetImageFromCurrentImageContext() != nil else { return nil}
            UIGraphicsEndImageContext()
            guard let new1data = UIImageJPEGRepresentation(self, compression) else { return nil}
            newdata = new1data
        }
        return newdata
    }
    
    /// 生成渐变色图片
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
    
    /**
     生成二维码
     - parameter qrString:    字符串
     - parameter qrImageName: 图片
     */
    open class func jmCreateQRCode(_ qrString: String?, qrImageName: String?) -> UIImage?{
        if let sureQRString = qrString {
            let stringData = sureQRString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            // 创建一个二维码的滤镜
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")
            qrFilter!.setValue(stringData, forKey: "inputMessage")
            qrFilter!.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = qrFilter!.outputImage
            // 创建一个颜色滤镜,黑白色
            let colorFilter = CIFilter(name: "CIFalseColor")
            colorFilter!.setDefaults()
            colorFilter!.setValue(qrCIImage, forKey: "inputImage")
            colorFilter!.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter!.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            // 返回二维码image
            let codeImage = UIImage(ciImage: colorFilter!.outputImage!.transformed(by: CGAffineTransform(scaleX: 5, y: 5)))
            // 通常,二维码都是定制的,中间都会放想要表达意思的图片
            if let iconImage = UIImage(named: qrImageName!) {
                let rect = CGRect(x: 0, y: 0, width: codeImage.size.width, height: codeImage.size.height)
                UIGraphicsBeginImageContext(rect.size)
                codeImage.draw(in: rect)
                let avatarSize = CGSize(width: rect.size.width * 0.25, height: rect.size.height * 0.25)
                let x = (rect.width - avatarSize.width) * 0.5
                let y = (rect.height - avatarSize.height) * 0.5
                iconImage.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                return resultImage
            }
            return codeImage
        }
        return nil
    }
}
