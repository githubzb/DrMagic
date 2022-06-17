//
//  MyModalViewController.swift
//  MagicTest
//
//  Created by dr.box on 2022/6/17.
//

import UIKit
import RxCocoa
import RxSwift
import DrFlexLayout_swift
import DrMagic

class MyModalViewController: UIViewController {
    
    
    var close: Binder<Void> {
        Binder(self) { (vc, _) in
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    let didClose = PublishRelay<Void>()
    
    var disposeBag = DisposeBag()
    
    let text: String
    
    
    init(text: String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let v = UIView()
        v.backgroundColor = .white
        v.dr_flex.justifyContent(.center).alignItems(.center).define { flex in
            flex.addItem(UILabel()).define { flex in
                let lb = flex.view as! UILabel
                lb.text = text
                lb.font = .systemFont(ofSize: 28, weight: .bold)
                lb.textColor = .orange
            }
            flex.addItem(UIButton(type: .custom)).size(CGSize(width: 200, height: 30)).marginTop(50).cornerRadius(radius: 15).define { flex in
                let btn = flex.view as! UIButton
                btn.setTitle("关闭", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.backgroundColor = .blue
                btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
                btn.rx.tap.bind(to: close).disposed(by: disposeBag)
                btn.rx.tap.bind(to: didClose).disposed(by: disposeBag)
            }
        }
        view = v
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.dr_flex.layout()
    }
}
