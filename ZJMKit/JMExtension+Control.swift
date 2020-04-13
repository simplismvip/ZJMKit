//
//  JMExtension+Control.swift
//  AEXML
//
//  Created by JunMing on 2020/4/13.
//

import UIKit

open class UIControlBlockTarget:NSObject {
    typealias jm_block = (AnyObject?)->Void
    var block:jm_block
    open var events:UIControl.Event
    
    init(block:@escaping jm_block,events:UIControl.Event) {
        self.block = block
        self.events = events
    }
    
    @objc open func invoke(_ sender:AnyObject) {
        block(sender)
    }
}

extension UIControl {
    var controlBlockTargets:Array<UIControlBlockTarget> {
        get {
            if let targets = objc_getAssociatedObject(self, &jm_eventStore.event_target_key) as? Array<UIControlBlockTarget> {
                return targets
            }else {
                self.controlBlockTargets = Array<UIControlBlockTarget>()
                return self.controlBlockTargets
            }
        }
        set(newValue){
            objc_setAssociatedObject(self, &jm_eventStore.event_target_key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func removeAllTargets() {
        allTargets.forEach { (object) in
            removeTarget(object, action: nil, for: .allEvents)
        }
        controlBlockTargets.removeAll()
    }
    
    func setTarget(target:AnyObject,action:Selector,events:UIControl.Event) {
        allTargets.forEach { currentTarget in
            let actions = self.actions(forTarget: currentTarget, forControlEvent: events)
            actions?.forEach({ currentAction in
                removeTarget(currentTarget, action: NSSelectorFromString(currentAction), for: events)
            })
        }
        addTarget(target, action: action, for: events)
    }
    
    func addBlockForEvents(evnts:UIControl.Event,block:@escaping (AnyObject?)->Void) {
        let target = UIControlBlockTarget(block:block , events: evnts)
        addTarget(target, action: #selector(UIControlBlockTarget.invoke(_:)), for: evnts)
        controlBlockTargets.append(target)
    }
    
    func setBlockForEvents(evnts:UIControl.Event,block:@escaping (AnyObject?)->Void) {
        removeAllBlocksControlEvents(evnts: evnts, block: block)
        addBlockForEvents(evnts: evnts, block: block)
    }
    
    func removeAllBlocksControlEvents(evnts:UIControl.Event,block:@escaping (AnyObject?)->Void) {
        var removes = Array<UIControlBlockTarget>()
        controlBlockTargets.forEach { target in
            if target.events.contains(evnts) {
                
                let newEvent = Event(rawValue: (target.events.rawValue & (~target.events.rawValue)))
                
                removeTarget(target, action: #selector(UIControlBlockTarget.invoke(_:)), for: newEvent)
                target.events = newEvent
                addTarget(target, action: #selector(UIControlBlockTarget.invoke(_:)), for: newEvent)
                
                removeTarget(target, action: #selector(UIControlBlockTarget.invoke(_:)), for: newEvent)
                removes.append(target)
            }
        }
    }
}

