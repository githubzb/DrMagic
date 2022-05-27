//
//  ViewController.swift
//  MagicTest
//
//  Created by dr.box on 2022/5/9.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func clickDeviceManagerBtn(_ sender: Any) {
        let vc = DeviceManagerTestViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}

