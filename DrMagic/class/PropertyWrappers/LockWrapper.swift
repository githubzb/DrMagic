//
//  LockWrapper.swift
//  DrMagic
//
//  Created by dr.box on 2022/5/29.
//

import Foundation

@dynamicMemberLookup
@propertyWrapper
public final class Locked<T> {
    
    private var value: T
    private let locker = DrUnfairLock()
    
    public var wrappedValue: T {
        set { locker.around { value = newValue } }
        get { locker.around { value } }
    }
    
    public init(wrappedValue: T) {
        self.value = wrappedValue
    }
    
    /// 属性包装器的投影值
    public var projectedValue: Locked<T> { self }
    
    /// 加锁读取包装属性的值
    public func read<V>(_ closure: (T) throws ->V) rethrows -> V {
        try locker.around { try closure(self.value) }
    }
    
    /// 加锁修改包装属性的值
    @discardableResult
    public func write<V>(_ closure: (inout T) throws ->V) rethrows -> V {
        try locker.around { try closure(&self.value) }
    }
    
    /// 动态成员查找，以及修改包装属性的属性值
    public subscript<Property>(dynamicMember keyPath: WritableKeyPath<T, Property>) -> Property {
        get { locker.around { value[keyPath: keyPath] } }
        set { locker.around { value[keyPath: keyPath] = newValue } }
    }
    
    /// 动态成员查找包装属性的属性值
    public subscript<Property>(dynamicMember keyPath: KeyPath<T, Property>) -> Property {
        locker.around { value[keyPath: keyPath] }
    }
}
