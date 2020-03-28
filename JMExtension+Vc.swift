//
//  JMExtension+Vc.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/3/28.
//

import Foundation
extension UIViewController {
    /// 弹窗，带输入
    public func jm_showAlert(_ title:String?, _ msg:String?, _ placeHolder:String, handler:((_ toast:String?)->())?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let sureAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default) { (action) in
            if let text = alert.textFields?.first?.text {
                if let handle = handler { handle(text) }
            }else{
                self.jm_showAlert("请重新输入", "输入为空", false, nil)
            }
        }
        alert.addTextField { textField in
            textField.text = placeHolder
            textField.textColor = UIColor.gray
            textField.clearButtonMode = UITextField.ViewMode.whileEditing
            textField.borderStyle = UITextField.BorderStyle.roundedRect
        }
        
        let cancleAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(sureAction)
        alert.addAction(cancleAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    /// 弹窗，不带输入
    public func jm_showAlert(_ title:String?, _ msg:String?, _ showCancle:Bool, _ handler:((_ toast:String?)->())?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let sureAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default) { (action) in
            if let handle = handler { handle(nil) }
        }
        if showCancle {
            let cancleAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(cancleAction)
        }
        alert.addAction(sureAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    /// 分享弹窗
    public func jm_shareImageToFriends(shareID:String?,image:UIImage?,completionHandler:@escaping (_ activityType:UIActivity.ActivityType?, _ completed:Bool?)->()) {
        var items = [Any]()
        if let appname = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            items.append("#\(appname)#")
        }
        if let share = shareID { items.append(share) }
        if let ima = image { items.append(ima) }
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        let excludedActivityTypes = [UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.print, UIActivity.ActivityType.postToTencentWeibo, UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.message]
        activityVC.excludedActivityTypes = excludedActivityTypes
        activityVC.completionWithItemsHandler = { activity, completed, items, error in
            completionHandler(activity,completed)
        }
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = self.navigationController?.navigationBar
                popover.sourceRect = (self.navigationController?.navigationBar.bounds)!
                popover.permittedArrowDirections = .up
            }
        }
        self.present(activityVC, animated: true, completion: nil)
    }
}
