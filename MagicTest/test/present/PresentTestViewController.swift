//
//  PresentTestViewController.swift
//  MagicTest
//
//  Created by dr.box on 2022/6/17.
//

import UIKit
import DrFlexLayout_swift
import RxCocoa
import RxSwift
import DrMagic

class PresentTestViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    var close: Binder<Void> {
        Binder(self) { (vc, _) in
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    // 同一个模态视图，多次显示
    var showMoreForOne: Binder<Void> {
        Binder(self) { (vc, _) in
            let modalVc = MyModalViewController(text: "A")
            vc.mg.showModal(modalVc)
            vc.mg.showModal(modalVc)
            vc.mg.showModal(modalVc)
            // 最会显示一次
        }
    }
    
    // 多个不同模态框，同时显示
    var showMoreModal: Binder<Void> {
        Binder(self) { (vc, _) in
            let modalVc1 = MyModalViewController(text: "A")
            vc.mg.showModal(modalVc1)
            let modalVc2 = MyModalViewController(text: "B")
            vc.mg.showModal(modalVc2)
            let modalVc3 = MyModalViewController(text: "C")
            vc.mg.showModal(modalVc3)
            let modalVc4 = MyModalViewController(text: "D")
            vc.mg.showModal(modalVc4)
        }
    }
    
    // 使用系统自带的方法显示模态视图，同时采用MG提供的show方法显示下一个模态视图
    var showTwoModal: Binder<Void> {
        Binder(self) { (vc, _) in
            let modal1 = MyModalViewController(text: "采用系统方法显示")
            modal1.modalPresentationStyle = .fullScreen
            vc.present(modal1, animated: true, completion: nil)
            
            let modal2 = MyModalViewController(text: "采用MG方法显示")
            vc.mg.showModal(modal2)
        }
    }
    
    // 关闭一个模态视图，立刻显示下一个
    var closeModalShowNext: Binder<Void> {
        Binder(self) { (vc, _) in
            let modal = MyModalViewController(text: "这是一个模态视图A")
            modal.didClose.bind(to: vc.showModal).disposed(by: modal.disposeBag)
            vc.mg.showModal(modal)
        }
    }
    
    // 非动画显示多个
    var showMoreNoAnimal: Binder<Void> {
        Binder(self) { (vc, _) in
            let modal1 = MyModalViewController(text: "A")
            vc.mg.showModal(modal1, animated: false)
            let modal2 = MyModalViewController(text: "B")
            vc.mg.showModal(modal2, animated: false)
            let modal3 = MyModalViewController(text: "C")
            vc.mg.showModal(modal3, animated: false)
            let modal4 = MyModalViewController(text: "D")
            vc.mg.showModal(modal4, animated: false)
        }
    }
    
    // 动画与非动画混合显示
    var showMoreAnimalMixture: Binder<Void> {
        Binder(self) { (vc, _) in
            let modal1 = MyModalViewController(text: "A")
            vc.mg.showModal(modal1, animated: true)
            let modal2 = MyModalViewController(text: "B")
            vc.mg.showModal(modal2, animated: false)
            let modal3 = MyModalViewController(text: "C")
            vc.mg.showModal(modal3, animated: false)
            let modal4 = MyModalViewController(text: "D")
            vc.mg.showModal(modal4, animated: true)
        }
    }

    
    // 显示模态视图
    var showModal: Binder<Void> {
        Binder(self) { (vc, _) in
            let modal = MyModalViewController(text: "这是一个模态视图B")
            vc.mg.showModal(modal)
        }
    }
    
    override func loadView() {
        let v = UIView()
        v.backgroundColor = .white
        let top = UIApplication.mg.safeArea.top
        v.dr_flex.alignItems(.center).paddingTop(top).define { flex in
            flex.addItem(UIButton(type: .custom)).size(CGSize(width: 200, height: 30)).marginTop(20).cornerRadius(radius: 15).define { flex in
                let btn = flex.view as! UIButton
                btn.setTitle("关闭", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = .blue
                btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
                btn.rx.tap.bind(to: close).disposed(by: disposeBag)
            }
            
            flex.addItem(UIButton(type: .custom)).size(CGSize(width: 200, height: 30)).marginTop(20).cornerRadius(radius: 15).define { flex in
                let btn = flex.view as! UIButton
                btn.setTitle("同一个显示多次", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = .blue
                btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
                btn.rx.tap.bind(to: showMoreForOne).disposed(by: disposeBag)
            }
            flex.addItem(UIButton(type: .custom)).size(CGSize(width: 200, height: 30)).marginTop(20).cornerRadius(radius: 15).define { flex in
                let btn = flex.view as! UIButton
                btn.setTitle("同时显示多个", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = .blue
                btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
                btn.rx.tap.bind(to: showMoreModal).disposed(by: disposeBag)
            }
            
            flex.addItem(UIButton(type: .custom)).size(CGSize(width: 200, height: 30)).marginTop(20).cornerRadius(radius: 15).define { flex in
                let btn = flex.view as! UIButton
                btn.setTitle("关闭立刻显示下一个", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = .blue
                btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
                btn.rx.tap.bind(to: closeModalShowNext).disposed(by: disposeBag)
            }
            
            flex.addItem(UIButton(type: .custom)).size(CGSize(width: 200, height: 30)).marginTop(20).cornerRadius(radius: 15).define { flex in
                let btn = flex.view as! UIButton
                btn.setTitle("系统和MG同时显示", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = .blue
                btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
                btn.rx.tap.bind(to: showTwoModal).disposed(by: disposeBag)
            }
            
            flex.addItem(UIButton(type: .custom)).size(CGSize(width: 200, height: 30)).marginTop(20).cornerRadius(radius: 15).define { flex in
                let btn = flex.view as! UIButton
                btn.setTitle("非动画显示多个", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = .blue
                btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
                btn.rx.tap.bind(to: showMoreNoAnimal).disposed(by: disposeBag)
            }
            
            flex.addItem(UIButton(type: .custom)).size(CGSize(width: 200, height: 30)).marginTop(20).cornerRadius(radius: 15).define { flex in
                let btn = flex.view as! UIButton
                btn.setTitle("动画与非动画混合", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = .blue
                btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
                btn.rx.tap.bind(to: showMoreAnimalMixture).disposed(by: disposeBag)
            }
        }
        view = v
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.dr_flex.layout()
    }
}
