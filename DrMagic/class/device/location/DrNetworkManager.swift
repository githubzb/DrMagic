//
//  DrNetworkManager.swift
//  DrMagic
//
//  Created by dr.box on 2022/5/29.
//

import Foundation
import SystemConfiguration


public class DrNetworkManager {
    
    public typealias Listener = (NetworkReachabilityStatus) -> Void
    
    /// 网络可达状态
    public enum NetworkReachabilityStatus {
        /// 网络是否可达尚不清楚。
        case unknown
        /// 网络不可达。
        case notReachable
        /// 网络可达。
        case reachable(ConnectionType)

        init(_ flags: SCNetworkReachabilityFlags) {
            guard flags.isActuallyReachable else { self = .notReachable; return }

            var networkStatus: NetworkReachabilityStatus = .reachable(.ethernetOrWiFi)

            if flags.isCellular { networkStatus = .reachable(.cellular) }
            
            self = networkStatus
        }

        /// 网络类型
        public enum ConnectionType {
            /// 网络类型：以太网或wifi
            case ethernetOrWiFi
            /// 网络类型：蜂窝网络
            case cellular
        }
    }
    
    struct MutableState {
        /// 用于监听网络状态的回调闭包
        var listener: Listener?
        /// 回调闭包执行的所在队列
        var listenerQueue: DispatchQueue?
        /// 上次的网络状态
        var previousStatus: NetworkReachabilityStatus?
    }
    
    
    private let reachability: SCNetworkReachability
    
    /// 获取网络可达状态
    public var flags: SCNetworkReachabilityFlags? {
        var flags = SCNetworkReachabilityFlags()
        return (SCNetworkReachabilityGetFlags(reachability, &flags)) ? flags : nil
    }
    
    /// 网络监听回调队列
    public let reachabilityQueue = DispatchQueue(label: "com.drbox.reachabilityQueue")
    
    @Locked
    private var state = MutableState()
    
    
    deinit {
        stopListening()
    }
    /**
     初始化
     
     - Parameter host: 监听网络的URL.host（可访问的域名）
     
     - Returns DrNetworkManager
     */
    public convenience init?(host: String) {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, host) else {
            return nil
        }
        self.init(reachability: reachability)
    }
    
    /// 初始化（监听地址0.0.0.0）支持IPv4和IPv6
    public convenience init?(){
        var address = sockaddr()
        address.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        address.sa_family = sa_family_t(AF_INET)
        guard let reachability = SCNetworkReachabilityCreateWithAddress(nil, &address) else {
            return nil
        }
        self.init(reachability: reachability)
    }
    
    private init(reachability: SCNetworkReachability) {
        self.reachability = reachability
    }
    
    
    @discardableResult
    public func startListening(onQueue queue: DispatchQueue = .main, onStateUpdate: Listener?) -> Bool {
        stopListening()
        $state.write { state in
            state.listenerQueue = queue
            state.listener = onStateUpdate
        }
        var context = SCNetworkReachabilityContext(version: 0,
                                                   info: Unmanaged.passUnretained(self).toOpaque(),
                                                   retain: nil,
                                                   release: nil,
                                                   copyDescription: nil)
        let callback: SCNetworkReachabilityCallBack = { (_, flags, info) in
            guard let info = info else { return }
            let manager = Unmanaged<DrNetworkManager>.fromOpaque(info).takeUnretainedValue()
            manager.notifyListener(flags)
        }
        let dispatchQueue = SCNetworkReachabilitySetDispatchQueue(reachability, reachabilityQueue)
        let didSetCallback = SCNetworkReachabilitySetCallback(reachability, callback, &context)
        
        // 首次回调
        if let currentFlags = self.flags {
            reachabilityQueue.async {
                self.notifyListener(currentFlags)
            }
        }
        return dispatchQueue && didSetCallback
    }
    
    /// 停止网络可达监听
    public func stopListening() {
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
        $state.write { state in
            state.listener = nil
            state.listenerQueue = nil
            state.previousStatus = nil
        }
    }
    
    func notifyListener(_ flags: SCNetworkReachabilityFlags) {
        let newStatus = NetworkReachabilityStatus(flags)
        $state.write { state in
            guard state.previousStatus != newStatus else { return }
            state.previousStatus = newStatus
            let listener = state.listener
            state.listenerQueue?.async { listener?(newStatus) }
        }
    }
}

extension DrNetworkManager.NetworkReachabilityStatus: Equatable {}

extension SCNetworkReachabilityFlags {
    var isReachable: Bool { contains(.reachable) }
    var isConnectionRequired: Bool { contains(.connectionRequired) }
    var canConnectAutomatically: Bool { contains(.connectionOnDemand) || contains(.connectionOnTraffic) }
    var canConnectWithoutUserInteraction: Bool { canConnectAutomatically && !contains(.interventionRequired) }
    var isActuallyReachable: Bool { isReachable && (!isConnectionRequired || canConnectWithoutUserInteraction) }
    var isCellular: Bool {
        #if os(iOS) || os(tvOS)
        return contains(.isWWAN)
        #else
        return false
        #endif
    }
}
