//
//  JMExtension+Sequece.swift
//  Pods-ZJMKit_Example
//
//  Created by JunMing on 2020/7/2.
//

import UIKit

extension Array where Element:Equatable {
    /// 查找某个元素的位置，这个方法是下面index的特殊情况
    public func index(of element:Element) -> Int? {
        for idx in self.indices where self[idx] == element {
            return idx
        }
        return nil
    }
    
    /// 移除元素
    public mutating func jm_removeObject<T:Equatable>(_ model:T, inArray:inout [T]) {
        var findIndex:Int?
        for (index,item) in inArray.enumerated() {
            if item == model {
                findIndex = index
                break
            }
        }
        
        if let index = findIndex {
            inArray.remove(at: index)
        }
    }
    
    /// 删除元素
    public mutating func jm_deleteObject<T:Equatable>(_ model:T, inArray:inout [T]) {
        var findIndex:Int?
        for (index,item) in inArray.enumerated() {
            if item == model {
                findIndex = index
                break
            }
        }
        
        if let index = findIndex {
            inArray.remove(at: index)
        }
    }
}

extension Array {
    /// 查找首个符合条件元素的位置，返回索引位置
    public func index(_ transfrom:(Element) -> Bool) -> Int?  {
        var result:Int?
        for (index,x) in enumerated() where transfrom(x) {
            result = index
            break
        }
        return result
    }
    
    /// 查找序列中一组满足某个条件的元素个数，并未构建数组，比使用Filter高效
    public func count(where predicate:(Element) ->Bool) -> Int {
        var result = 0
        for element in self where predicate(element) {
            result += 1
        }
        return result
    }
    
    /// 类似reduce
    public func accumulate<Result>(_ initialResult:Result, _ nextPartialResult:(Result,Element) ->Result) -> [Result] {
        var running = initialResult
        return map { (next) -> Result in
            running = nextPartialResult(running,next)
            return running
        }
    }
}

extension Sequence where Element:Hashable {
    /// 去掉重复元素，并按照顺序返回。正常使用Set返回的元素是无序的
    public func unique() -> [Element] {
        var seen:Set<Element> = []
        return filter { (element) -> Bool in
            if seen.contains(element) {
                return false
            }else {
                seen.insert(element)
                return true
            }
        }
    }
    
    /// 将相同元素放到同一数组中，不保证顺序，只需要遍历一次
    public func subSequence() -> [[Element]] {
        var seen:Dictionary<Element,[Element]> = [:]
        for element in self {
            if var items = seen[element] {
                items.append(element)
                seen.updateValue(items, forKey: element)
            }else {
                var items = [Element]()
                items.append(element)
                seen[element] = items
            }
        }
        return seen.compactMap { $0.value }
    }
}
