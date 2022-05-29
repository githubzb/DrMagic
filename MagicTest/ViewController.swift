//
//  ViewController.swift
//  MagicTest
//
//  Created by dr.box on 2022/5/9.
//

import UIKit
import DrMagic

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            
            drLog("safeArea: \(UIApplication.mg.safeArea)")
        }
    }

    @IBAction func clickDeviceManagerBtn(_ sender: Any) {
        let vc = DeviceManagerTestViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}

