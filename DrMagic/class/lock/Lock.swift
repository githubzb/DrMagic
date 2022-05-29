//
//  Lock.swift
//  DrMagic
//
//  Created by dr.box on 2022/5/29.
//

import Foundation

public protocol DrLock {
    func lock()
    func unlock()
}

extension DrLock {
    
    /// 闭包操作采用当前锁保护（带返回值）
    public func around<T>(_ closure: () throws ->T) rethrows -> T {
        lock(); defer { unlock() }
        return try closure()
    }
    
    public func around(_ closure: () throws ->Void) rethrows {
        lock(); defer { unlock() }; try closure()
    }
}

