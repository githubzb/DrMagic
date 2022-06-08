//
//  DrDeviceManager.swift
//  DrMagic
//
//  Created by dr.box on 2022/5/26.
//

import UIKit
import CoreLocation
import CoreTelephony

public class DrDeviceManager {
    
    public static let share = Static.manager
    private struct Static {
        static let manager = DrDeviceManager()
    }
    
    
    // MARK: - 定位功能
    
    // 用于定位
    private lazy var locationManager: DrLocationManager = DrLocationManager()
    
    /// 定位坐标
    public var location: CLLocation? { self.locationManager.location }
    // 获取定位状态
    public var locationAuthStatus: CLAuthorizationStatus { self.locationManager.locationAuthStatus }
    
    /**
     更新定位
     
     - Parameter needRequestAuth: 是否需要请求授权，请求方式为：requestWhenInUseAuthorization（默认：需要）
     - Parameter completed: 更新定位完成回调
     */
    public func updateLocation(needRequestAuth: Bool = true, completed: ((_ location: CLLocation?)->Void)? = nil) {
        locationManager.updateLocation(needRequestAuth: needRequestAuth, completed: completed)
    }
    
    
    // MARK: - 网络相关
    private var networkManager: DrNetworkManager?
    
    /**
     启动网络状态监听
     
     - Parameter host: 监听网络的URL.host（可访问的域名，默认：www.baidu.com）
     
     - Returns 是否启动监听成功（false：失败）
     */
    @discardableResult
    public func startNetworkListening(host: String = "www.baidu.com") -> Bool {
        guard self.networkManager == nil else {
            return true
        }
        guard let networkManager = DrNetworkManager(host: host) else {
            return false
        }
        self.networkManager = networkManager
        networkManager.startListening(onStateUpdate: { [weak self] (status) in
            guard let self = self else { return }
            self.networkStatus = status
        })
        return true
    }
    
    /// 停止网络状态监听
    public func stopNetworkListening() {
        networkManager?.stopListening()
        networkManager = nil
    }
    
    /// 判断当前网络是否可达（在未启动网络监听前，该属性一直为false）
    public var networkIsReachable: Bool {
        guard let isReachable = networkManager?.flags?.isActuallyReachable else {
            return false
        }
        return isReachable
    }
    
    /// 当前网络状态（在未启动网络监听前，该属性一直为nil）
    private(set) public var networkStatus: DrNetworkManager.NetworkReachabilityStatus? {
        set {
            guard let status = newValue else { return }
            NotificationCenter.default.post(name: DrDeviceManager.networkStatusNotifyName,
                                            object: nil,
                                            userInfo: ["status": status])
        }
        get {
            guard let flags = networkManager?.flags else {
                return nil
            }
            return DrNetworkManager.NetworkReachabilityStatus(flags)
        }
    }
    /// 监听网络状态通知（userInfo：[status: DrNetworkManager.NetworkReachabilityStatus]）
    public static let networkStatusNotifyName: NSNotification.Name = .init("com.drbox.notify.network.status")
    
    
    // MARK: - 电话通信运营商
    
    /// 手机通信运营商信息（目前仅返回中国三大运营商）
    public static var mno: MobileProvider? {
        let info = CTTelephonyNetworkInfo()
        var carrier: CTCarrier?
        if #available(iOS 13.0, *) {
            guard let identifier = info.dataServiceIdentifier else { return nil }
            guard let _carrier = info.serviceSubscriberCellularProviders?[identifier] else { return nil }
            carrier = _carrier
        } else {
            guard let _carrier = info.subscriberCellularProvider else { return nil }
            carrier = _carrier
        }
        
        guard let countryCode = carrier?.mobileCountryCode, let networkCode = carrier?.mobileNetworkCode else { return nil }
        guard countryCode == "460" else { return nil }
        switch networkCode {
        case "00", "02", "07": // 中国移动
            return .cmcc
        case "03", "05", "11": // 电信
            return .chinanet
        case "01", "06", "09": // 联通
            return .chinaUnicom
        default:
            return nil
        }
    }
    
    
    public enum MobileProvider {
        /// 中国移动
        case cmcc
        /// 中国电信
        case chinanet
        /// 中国联通
        case chinaUnicom
    }
}


extension DrDeviceManager.MobileProvider: CustomStringConvertible {
    public var description: String {
        switch self {
        case .cmcc:
            return "中国移动"
            
        case .chinanet:
            return "中国电信"
            
        case .chinaUnicom:
            return "中国联通"
        }
    }
}
