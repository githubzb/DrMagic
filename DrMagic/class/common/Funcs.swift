//
//  Funcs.swift
//  DrMagic
//
//  Created by dr.box on 2022/5/27.
//

import UIKit

/// 屏幕尺寸常量
public let kScreenSize = UIApplication.mg.screenSize
/// 状态栏高度常量
public let kStatusHeight = UIApplication.mg.statusHeight

/// 在主线程中异步调用
public func asyncCallInMain(_ call: @escaping ()->Void) {
    guard Thread.isMainThread else {
        call()
        return
    }
    DispatchQueue.main.async {
        call()
    }
}
/// 在主线程中同步调用
public func syncCallInMain(_ call: ()->Void) {
    guard Thread.isMainThread else {
        call()
        return
    }
    DispatchQueue.main.sync {
        call()
    }
}
