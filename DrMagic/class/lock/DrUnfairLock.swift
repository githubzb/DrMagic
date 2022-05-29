//
//  DrUnfairLock.swift
//  DrMagic
//
//  Created by dr.box on 2022/5/29.
//

import Foundation

public final class DrUnfairLock: DrLock {
    
    private let locker: os_unfair_lock_t
    
    deinit {
        locker.deinitialize(count: 1)
        locker.deallocate()
    }
    
    public init() {
        locker = .allocate(capacity: 1)
        locker.initialize(to: os_unfair_lock())
    }
    
    public func lock() {
        os_unfair_lock_lock(locker)
    }
    
    public func unlock() {
        os_unfair_lock_unlock(locker)
    }
    
}
