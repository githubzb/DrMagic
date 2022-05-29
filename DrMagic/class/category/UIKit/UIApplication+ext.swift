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
    
    /// 界面的安全区（注意：在applicationState为非活跃状态时，获取到的值是zero）
    public static var safeArea: UIEdgeInsets { keyWindow?.safeAreaInsets ?? .zero }
    
    /// 获取最上层的控制器
    public static var topViewController: UIViewController? {
        guard let rootVc = keyWindow?.rootViewController else {
            return nil
        }
        func getTopVc(_ vc: UIViewController) -> UIViewController {
            if let tabbarVc = vc as? UITabBarController {
                if tabbarVc.presentedViewController != nil {
                    return getTopVc(tabbarVc.presentedViewController!)
                }else if let viewController = tabbarVc.selectedViewController {
                    return getTopVc(viewController)
                }else {
                    return tabbarVc
                }
            }
            if let nav = vc as? UINavigationController {
                if nav.presentedViewController != nil {
                    return getTopVc(nav.presentedViewController!)
                }else if let viewController = nav.topViewController {
                    return getTopVc(viewController)
                }else {
                    return nav
                }
            }
            if let viewController = vc.presentedViewController {
                return getTopVc(viewController)
            }
            return vc
        }
        return getTopVc(rootVc)
    }
    
    /// 打开系统设置页面
    public static func openSettingPage() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
}

