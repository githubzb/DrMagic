//
//  DrTimer.swift
//  DrMagic
//
//  Created by dr.box on 2022/6/27.
//

import Foundation

public class DrTimer {
    
    public let timeInterval: DispatchTimeInterval
    public let startDelay: DispatchTimeInterval
    public let name: String
    
    public var eventHandler: (() -> Void)?
    
    public required init(name: String, delay startDelay: DispatchTimeInterval? = nil, timeInterval: DispatchTimeInterval) {
        self.name = name
        self.timeInterval = timeInterval
        if let startDelay = startDelay {
            self.startDelay = startDelay
        }else {
            self.startDelay = timeInterval
        }
    }
    
    
    private static let target_queue = DispatchQueue(label: "com.drmagic.timerQueue",
                                                    qos: .default,
                                                    attributes: .concurrent)
    private lazy var timer: DispatchSourceTimer = {
        let queue = DispatchQueue(label: "com.drmagic.timerQueue" + name, target: DrTimer.target_queue)
        let t = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
        t.schedule(deadline: .now() + startDelay,
                   repeating: (timeInterval.seconds ?? 0) > 0 ? timeInterval.seconds! : .infinity)
        t.setEventHandler { [weak self] in
            self?.eventHandler?()
        }
        return t
    }()
    
    private var state: State = .suspended
    
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
         */
        resume()
        eventHandler = nil
    }
    
}

// MARK: - public api

extension DrTimer {
    
    /**
     定时循环（执行）
     
     - Parameter interval: 循环间隔时间
     - Parameter name: 计时器名字
     - Parameter block: 计时器执行回调
     
     - Returns DrTimer
     */
    public class func every(_ interval: DispatchTimeInterval, name: String, _ block: @escaping () -> Void) -> DrTimer {
        let timer = DrTimer(name: name, timeInterval: interval)
        timer.eventHandler = block
        timer.resume()
        return timer
    }
    
    @discardableResult
    public class func after(_ interval: DispatchTimeInterval, name: String, _ block: @escaping () -> Void) -> DrTimer {
        var timer : DrTimer? = DrTimer(name: name, delay: interval, timeInterval: .never)
        timer?.eventHandler = {
            block()
            timer?.suspend()
            timer = nil
        }
        timer?.resume()
        return timer!
    }
    
    /// 恢复计时
    public func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    /// 暂停计时
    public func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
    
    /// 取消计时
    public func cancel() {
        if state == .canceled {
            return
        }
        state = .canceled
        timer.cancel()
    }
}


// MARK: - state
extension DrTimer {
    
    private enum State {
        /// 暂停
        case suspended
        /// 恢复
        case resumed
        /// 取消
        case canceled
    }
}


fileprivate extension DispatchTimeInterval {
    
    /// 秒数
    var seconds: TimeInterval? {
        switch self {
        case .seconds(let value):
            return Double(value)
        case .milliseconds(let value):
            return Double(value) / 1_000
        case .microseconds(let value):
            return Double(value) / 1_000_000
        case .nanoseconds(let value):
            return Double(value) / 1_000_000_000
        case .never:
            return nil
        @unknown default:
            return nil
        }
    }
}
