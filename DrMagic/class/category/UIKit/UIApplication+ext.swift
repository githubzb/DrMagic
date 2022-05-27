//
//  UIApplication+ext.swift
//  DrMagic
//
//  Created by dr.box on 2022/5/27.
//

import UIKit

extension UIApplication: MagicBoxObjExt {}
extension MagicBox where T: UIApplication {
    
    /// 屏幕尺寸
    public static var screenSize: CGSize { UIScreen.main.bounds.size }
    /// 状态栏高度
    public static var statusHeight: CGFloat {
        if #available(iOS 13.0, *){
            guard let h = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height else{
                return 0
            }
            return h
        }else{
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    /// 获取程序主窗口
    public static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .first(where: { $0 is UIWindowScene })
                .flatMap({ $0 as? UIWindowScene })?.windows
                .first(where: \.isKeyWindow)
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    /// 打开系统设置页面
    public static func openSettingPage() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
