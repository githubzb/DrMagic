//
//  DrSemaphoreLock.swift
//  DrMagic
//
//  Created by dr.box on 2022/5/29.
//

import Foundation

public final class DrSemaphoreLock: DrLock {
    
    private let locker: DispatchSemaphore
    
    /// 并发数
    public let concurrency: Int
    
    public init(concurrency: Int) {
        self.concurrency = concurrency
        self.locker = DispatchSemaphore(value: concurrency)
    }
    
    public func lock() {
        _ = locker.wait(timeout: .distantFuture)
    }
    
    public func unlock() {
        _ = locker.signal()
    }
    
}
