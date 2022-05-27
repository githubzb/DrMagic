//
//  DeviceManagerTestViewController.swift
//  MagicTest
//
//  Created by dr.box on 2022/5/27.
//

import UIKit
import DrMagic
import DrFlexLayout_swift
import RxCocoa
import RxSwift
import CoreLocation

class DeviceManagerTestViewController: UIViewController {

    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.dr_flex.define { flex in
            flex.addItem()
                .direction(.row)
                .height(44)
                .alignItems(.center)
                .paddingTop(DrMagic.kStatusHeight)
                .paddingHorizontal(8)
                .define { flex in
                    flex.addItem(UIButton(type: .custom)).size(30).define { flex in
                        let btn = flex.view as! UIButton
                        btn.setTitle("关闭", for: .normal)
                        btn.setTitleColor(.blue, for: .normal)
                        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
                        btn.rx.tap.bind(to: clickCloseBtn).disposed(by: disposeBag)
                    }
                }
            flex.addItem(UIButton(type: .custom))
                .marginTop(10)
                .alignSelf(.center)
                .size(CGSize(width: 120, height: 34))
                .define { flex in
                    let btn = flex.view as! UIButton
                    btn.setTitle("需要授权定位", for: .normal)
                    btn.setTitleColor(.white, for: .normal)
                    btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
                    btn.backgroundColor = .blue
                    btn.rx.tap.bind(to: clickNeedAuthLocation).disposed(by: disposeBag)
                }
            flex.addItem(UIButton(type: .custom))
                .marginTop(20)
                .alignSelf(.center)
                .size(CGSize(width: 120, height: 34))
                .define { flex in
                    let btn = flex.view as! UIButton
                    btn.setTitle("不需要授权定位", for: .normal)
                    btn.setTitleColor(.white, for: .normal)
                    btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
                    btn.backgroundColor = .blue
                    btn.rx.tap.bind(to: clickNoAuthLocation).disposed(by: disposeBag)
                }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.dr_flex.layout()
    }
    
    var clickCloseBtn: Binder<Void> {
        Binder(self){ (vc, _) in
            vc.dismiss(animated: true)
        }
    }
    
    var clickNeedAuthLocation: Binder<Void> {
        Binder(self){ (vc, _) in
            if DrDeviceManager.share.locationAuthStatus == .denied {
                // 拒绝授权时
                let alert = UIAlertController(title: "定位授权失败", message: "请为该app开启定位授权", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "关闭", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "却设置", style: .default, handler: { _ in
                    UIApplication.mg.openSettingPage()
                }))
                vc.present(alert, animated: true)
                return
            }
            DrDeviceManager.share.updateLocation { location in
                guard let location = location else {
                    drLog("定位失败")
                    return
                }
                drLog("定位完成，longitude: \(location.coordinate.longitude), latitude: \(location.coordinate.latitude)")
            }
        }
    }
    
    var clickNoAuthLocation: Binder<Void> {
        Binder(self){ (vc, _) in
            DrDeviceManager.share.updateLocation(needRequestAuth: false) { location in
                guard let location = location else {
                    drLog("定位失败")
                    return
                }
                drLog("定位完成，longitude: \(location.coordinate.longitude), latitude: \(location.coordinate.latitude)")
            }
        }
    }

}
