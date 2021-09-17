//
//  JMExtension+Vc.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/3/28.
//

import Foundation

extension DispatchQueue {
    private static var _onceToken = [String]()
    open class func once(token: String = "\(#file):\(#function):\(#line)", block: ()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        if _onceToken.contains(token) { return }
        _onceToken.append(token)
        block()
    }
}

extension UIViewController {
    public typealias jmCallBlock = (AnyObject?)->Void
    private struct storeKeys {
        static var event_key = "storeKeys.left"
        static var right_event_key = "storeKeys.right"
    }
    
    // 添加计算属性，用来绑定 AssociatedKeys
    private var eventBlock:jmCallBlock? {
        get { return objc_getAssociatedObject(self, &storeKeys.event_key) as? jmCallBlock }
        set { objc_setAssociatedObject(self, &storeKeys.right_event_key, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    // 添加计算属性，用来绑定 AssociatedKeys
    private var rightEventBlock:jmCallBlock? {
        get { return objc_getAssociatedObject(self, &storeKeys.right_event_key) as? jmCallBlock }
        set { objc_setAssociatedObject(self, &storeKeys.event_key, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    open func jmBarButtonItem(left: Bool = true, title: String?, image: UIImage?, action: @escaping jmCallBlock) {
        if left {
            rightEventBlock = action
            if let image = image {
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(jmLeftAction))
            }else {
                navigationItem.leftBarButtonItem = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(jmLeftAction))
            }
        }else {
            eventBlock = action
            if let image = image {
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(jmRightAction))
            }else {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(jmRightAction))
            }
        }
    }
    
    @objc func jmRightAction(){
        rightEventBlock?("right" as AnyObject)
    }
    
    @objc func jmLeftAction(){
        eventBlock?("left" as AnyObject)
    }
    
    /// 弹窗，带输入
    open func jmShowAlert(_ title: String?, _ msg: String?, _ placeHolder: String, handler: ((_ toast: String?) -> ())? = nil) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let sureAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default) { (action) in
            if let text = alert.textFields?.first?.text {
                if let handle = handler { handle(text) }
            } else {
                self.jmShowAlert("请重新输入", "输入为空", false, nil)
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
    open func jmShowAlert(_ title: String? = nil, _ msg: String? = nil, _ showCancle: Bool, _ handler: ((_ toast: String?) -> ())? = nil) {
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
    open func jmShareImageToFriends(shareID: String? = nil, image: UIImage? = nil, handler: @escaping (_ activityType: UIActivity.ActivityType?, _ completed: Bool?) -> ()) {
        var items = [Any]()
        items.append("#爱阅读书#")
        if let share = shareID { items.append(share) }
        if let ima = image { items.append(ima) }
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        let excTypes: [UIActivity.ActivityType] = [.copyToPasteboard, .assignToContact, .print, .postToTencentWeibo, .saveToCameraRoll, .message]
        activityVC.excludedActivityTypes = excTypes
        activityVC.completionWithItemsHandler = { activity, completed, items, error in
            handler(activity, completed)
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
