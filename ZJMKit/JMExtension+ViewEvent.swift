//
//  JMExtension+ViewEvent.swift
//  AEXML
//
//  Created by JunMing on 2020/4/13.
//

import UIKit

// MARK: -- 为UIButton添加便利方法 ---
extension UIButton {
    /// 移除block
    open func jmRemoveAction() {
        objc_setAssociatedObject(self, &JMEventStore.event_button_action, nil, .OBJC_ASSOCIATION_RETAIN)
    }
    
    /// 按钮添加block响应
    open func jmAddAction(event:UIControl.Event = .touchUpInside,action:@escaping (UIButton)->Void) {
        objc_setAssociatedObject(self, &JMEventStore.event_button_action, action, .OBJC_ASSOCIATION_RETAIN)
        addTarget(self, action: #selector(targetAction(_:)), for: event)
    }
    
    @objc private func targetAction(_ sender:UIButton) {
        if let block = objc_getAssociatedObject(self, &JMEventStore.event_button_action) as? (UIButton)->Void {
            block(sender)
        }
    }
}

// MARK: -- 为View、Label、Imageview 等添加便利方法 ---
extension UIView {
    typealias block = ()->Void
    private func setBlock(block:@escaping block,Key:UnsafeRawPointer) {
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, Key, block, .OBJC_ASSOCIATION_RETAIN)
    }
    
    private func removeBlock(Key:UnsafeRawPointer) {
        isUserInteractionEnabled = false
        objc_setAssociatedObject(self, Key, nil, .OBJC_ASSOCIATION_RETAIN)
    }
    
    private func runBlock(Key:UnsafeRawPointer) {
        (objc_getAssociatedObject(self, Key) as? block)?()
    }
    
    /// 1、添加block, ⚠️⚠️⚠️暂不支持UIButton
    open func jmAddblock(block:@escaping ()->Void) {
        if isKind(of: UIButton.self) { return }
        setBlock(block: block, Key: &JMEventStore.event_click)
    }
    /// 移除block
    open func jmRemoveblock() {
        removeBlock(Key: &JMEventStore.event_click)
    }
    
    /// 2、添加双击手势 block
    open func jmAddDoubleleTapGesture(block:@escaping ()->Void) {
        setBlock(block: block, Key: &JMEventStore.event_double_tap)
        removeTapGestureRecognizerWithTaps(taps: 2, touches: 1)
        let gesture = addTapGestureRecognizerWithTaps(taps: 2, touches: 1, select: #selector(viewWasDoubleTapped))
        addRequiredToDoubleTapsRecognizer(recognizer: gesture)
    }
    
    /// 移除双击手势block
    open func jmRemoveDoubleTapGesture() {
        removeBlock(Key: &JMEventStore.event_double_tap)
        removeTapGestureRecognizerWithTaps(taps: 2, touches: 1)
    }
    
    @objc private func viewWasDoubleTapped() {
        runBlock(Key: &JMEventStore.event_double_tap)
    }
    
    /// 3、添加单击手势 block
    open func jmAddSingleTapGesture(block:@escaping ()->Void) {
        setBlock(block: block, Key: &JMEventStore.event_single_tap)
        removeTapGestureRecognizerWithTaps(taps: 1, touches: 1)
        let gesture = addTapGestureRecognizerWithTaps(taps: 1, touches: 1, select: #selector(viewWasSingleTapped))
        addRequirementToSingleTapsRecognizer(recognizer: gesture)
    }
    
    /// 移除单击手势block
    open func jmRemoveSingleTapGesture() {
        removeBlock(Key: &JMEventStore.event_single_tap)
        removeTapGestureRecognizerWithTaps(taps: 2, touches: 1)
    }
    
    @objc private func viewWasSingleTapped() {
        runBlock(Key: &JMEventStore.event_single_tap)
    }
    
    private func addTapGestureRecognizerWithTaps(taps:Int,touches:Int,select:Selector?)->UITapGestureRecognizer {
        let tapgesture = UITapGestureRecognizer(target: self, action: select)
        tapgesture.delegate = (self as! UIGestureRecognizerDelegate)
        tapgesture.numberOfTouchesRequired = taps
        tapgesture.numberOfTapsRequired = touches
        addGestureRecognizer(tapgesture)
        return tapgesture
    }
    
    private func removeTapGestureRecognizerWithTaps(taps:Int,touches:Int) {
        gestureRecognizers?.forEach({ gesture in
            if gesture .isKind(of: UITapGestureRecognizer.self) {
                if let tapGesture = gesture as? UITapGestureRecognizer {
                    if tapGesture.numberOfTapsRequired == taps && tapGesture.numberOfTouchesRequired == touches {
                        removeGestureRecognizer(tapGesture)
                    }
                }
            }
        })
    }
    
    /// 3、添加长按手势 block
    open func jmAddLongPressGesture(block:@escaping ()->Void) {
        setBlock(block: block, Key: &JMEventStore.event_long_press)
        removeLongPressGestureRecognizer()
        addLongPressGestureRecognizerSelector(select: #selector(viewWasLongPressed(_:)))
    }
    /// 移除长按手势 block
    open func jmRemoveLongPressGesture() {
        removeBlock(Key: &JMEventStore.event_long_press)
        removeLongPressGestureRecognizer()
    }
    
    @objc private func viewWasLongPressed(_ longpress:UILongPressGestureRecognizer) {
        if longpress.state == .began {
            runBlock(Key: &JMEventStore.event_long_press)
        }
    }
    
    @discardableResult
    private func addLongPressGestureRecognizerSelector(select:Selector?)->UILongPressGestureRecognizer {
        let tapgesture = UILongPressGestureRecognizer(target: self, action: select)
        tapgesture.delegate = (self as! UIGestureRecognizerDelegate)
        addGestureRecognizer(tapgesture)
        return tapgesture
    }
    
    private func removeLongPressGestureRecognizer() {
        gestureRecognizers?.forEach({ gesture in
            if gesture .isKind(of: UILongPressGestureRecognizer.self) {
                removeGestureRecognizer(gesture)
            }
        })
    }
    
    /// 解决手势冲突问题，比如单击和双击手势同时添加时响应不了双击手势问题
    private func addRequirementToSingleTapsRecognizer(recognizer:UIGestureRecognizer) {
        gestureRecognizers?.forEach({ gesture in
            if gesture .isKind(of: UITapGestureRecognizer.self) {
                if let tapGesture = gesture as? UITapGestureRecognizer {
                    if tapGesture.numberOfTapsRequired == 1 && tapGesture.numberOfTouchesRequired == 1 {
                        // https://www.jianshu.com/p/10f6c8b1844c
                        tapGesture.require(toFail: recognizer)
                    }
                }
            }
        })
    }
    
    private func addRequiredToDoubleTapsRecognizer(recognizer:UIGestureRecognizer) {
        gestureRecognizers?.forEach({ gesture in
            if gesture .isKind(of: UITapGestureRecognizer.self) {
                if let tapGesture = gesture as? UITapGestureRecognizer {
                    if tapGesture.numberOfTapsRequired == 2 && tapGesture.numberOfTouchesRequired == 1 {
                        // https://www.jianshu.com/p/10f6c8b1844c
                        tapGesture.require(toFail: recognizer)
                    }
                }
            }
        })
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if objc_getAssociatedObject(self, &JMEventStore.event_click) != nil {
            if !isKind(of: UIControl.self) {
                let touch = touches.randomElement()
                if let point = touch?.location(in: self), bounds.contains(point) {
                    if let inView = touch?.view?.isEqual(self), inView {
                        runBlock(Key: &JMEventStore.event_click)
                    }
                }
            }
        }
        super.touchesEnded(touches, with: event)
    }
}
