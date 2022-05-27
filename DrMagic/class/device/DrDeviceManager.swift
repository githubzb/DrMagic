//
//  DrDeviceManager.swift
//  DrMagic
//
//  Created by dr.box on 2022/5/26.
//

import UIKit
import CoreLocation

public class DrDeviceManager: NSObject {
    
    public static let share = Static.manager
    private struct Static {
        static let manager = DrDeviceManager()
    }
    
    
    
    // MARK: - 定位功能
    
    // 用于定位
    fileprivate lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.desiredAccuracy = kCLLocationAccuracyBest
        return lm
    }()
    fileprivate lazy var locationHander: DrLocationHandler = {
        DrLocationHandler(self)
    }()
    
    /// 定位坐标
    fileprivate(set) public var location: CLLocation?
    // 获取定位状态
    public var locationAuthStatus: CLAuthorizationStatus {
        if #available(iOS 14, *) {
            return locationManager.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    /**
     更新定位
     
     - Parameter needRequestAuth: 是否需要请求授权，请求方式为：requestWhenInUseAuthorization（默认：需要）
     - Parameter completed: 更新定位完成回调
     */
    public func updateLocation(needRequestAuth: Bool = true, completed: ((_ location: CLLocation?)->Void)? = nil) {
        guard CLLocationManager.locationServicesEnabled() else {
            completed?(nil)
            drLog("定位服务不可用")
            return
        }
        switch locationAuthStatus {
        case .notDetermined:
            if needRequestAuth {
                locationHander.locationCompleted = completed
                locationManager.delegate = locationHander
                locationManager.requestWhenInUseAuthorization()
            }else {
                completed?(nil)
                drLog("未申请定位权限")
            }
        case .restricted, .denied:
            completed?(nil)
            drLog("定位权限不允许")
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            startLocation(completed: completed)
        @unknown default:
            completed?(nil)
            drLog("未知的定位权限")
        }
    }
    
    // 开始定位
    func startLocation(completed: ((CLLocation?)->Void)? = nil) {
        guard CLLocationManager.locationServicesEnabled() else {
            completed?(nil)
            drLog("定位服务不可用")
            return
        }
        switch locationAuthStatus {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            self.locationHander.locationCompleted = completed
            self.locationManager.delegate = self.locationHander
            self.locationManager.startUpdatingLocation()
        default:
            completed?(nil)
            drLog("定位权限不允许")
            break
        }
    }
}

fileprivate class DrLocationHandler: NSObject, CLLocationManagerDelegate {
    
    private weak var deviceManager: DrDeviceManager?
    var locationCompleted: ((CLLocation?)->Void)?
    
    init(_ deviceManager: DrDeviceManager) {
        self.deviceManager = deviceManager
        super.init()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        manager.stopUpdatingLocation()
        deviceManager?.location = location
        asyncCallInMain {
            self.locationCompleted?(location)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        asyncCallInMain {
            self.deviceManager?.startLocation(completed: self.locationCompleted)
        }
    }
}
