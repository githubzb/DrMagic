//
//  DrMutexLock.swift
//  DrMagic
//
//  Created by dr.box on 2022/5/29.
//

import Foundation

public final class DrMutexLock: DrLock {
    
    private var locker: pthread_mutex_t
    
    deinit {
        pthread_mutex_destroy(&locker)
    }
    
    public init() {
        self.locker = .init()
        var attr: pthread_mutexattr_t = .init()
        pthread_mutexattr_init(&attr)
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT)
        pthread_mutex_init(&locker, &attr)
    }
    
    public func lock() {
        pthread_mutex_lock(&locker)
    }
    
    public func unlock() {
        pthread_mutex_unlock(&locker)
    }
}
