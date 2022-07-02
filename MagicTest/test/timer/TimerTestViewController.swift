//
//  TimerTestViewController.swift
//  MagicTest
//
//  Created by dr.box on 2022/6/27.
//

import UIKit
import DrFlexLayout_swift
import DrMagic
import RxSwift
import RxCocoa

class TimerTestViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    var timer: DrTimer?
    
    
    var doEveryTimer: Binder<Void> {
        Binder(self) { (vc, _) in
            vc.timer = DrTimer.every(.seconds(1), name: "every", {
                print("every event");
            })
        }
    }
    
    var doSuspendTimer: Binder<Void> {
        Binder(self) { (vc, _) in
            vc.timer?.suspend()
        }
    }
    
    var doResumeTimer: Binder<Void> {
        Binder(self) { (vc, _) in
            vc.timer?.resume()
        }
    }
    
    var doAfterTimer: Binder<Void> {
        Binder(self) { (_, _) in
            DrTimer.after(.seconds(3), name: "after") {
                print("after event")
            }
        }
    }
    
    var close: Binder<Void> {
        Binder(self) { (vc, _) in
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    override func loadView() {
        let v = UIView()
        v.backgroundColor = .white
        v.dr_flex.justifyContent(.center).alignItems(.center).define { flex in
            flex.addItem(UIButton(type: .custom)).size(CGSize(width: 120, height: 30)).define { flex in
                let btn = flex.view as! UIButton
                btn.setTitle("定时循环", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
                btn.backgroundColor = .blue
                btn.rx.tap.bind(to: doEveryTimer).disposed(by: disposeBag)
            }
            
            flex.addItem(UIButton(type: .custom)).marginTop(20).size(CGSize(width: 120, height: 30)).define { flex in
                let btn = flex.view as! UIButton
                btn.setTitle("暂停", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
                btn.backgroundColor = .blue
                btn.rx.tap.bind(to: doSuspendTimer).disposed(by: disposeBag)
            }
            
            flex.addItem(UIButton(type: .custom)).marginTop(20).size(CGSize(width: 120, height: 30)).define { flex in
                let btn = flex.view as! UIButton
                btn.setTitle("开始", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
                btn.backgroundColor = .blue
                btn.rx.tap.bind(to: doResumeTimer).disposed(by: disposeBag)
            }
            
            flex.addItem(UIButton(type: .custom)).marginTop(20).size(CGSize(width: 120, height: 30)).define { flex in
                let btn = flex.view as! UIButton
                btn.setTitle("定时不循环", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
                btn.backgroundColor = .blue
                btn.rx.tap.bind(to: doAfterTimer).disposed(by: disposeBag)
            }
            
            flex.addItem(UIButton(type: .custom)).marginTop(20).size(CGSize(width: 120, height: 30)).define { flex in
                let btn = flex.view as! UIButton
                btn.setTitle("关闭", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
                btn.backgroundColor = .blue
                btn.rx.tap.bind(to: close).disposed(by: disposeBag)
            }
        }
        view = v
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.dr_flex.layout()
    }

}
