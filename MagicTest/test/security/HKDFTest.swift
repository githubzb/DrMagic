//
//  HKDFTest.swift
//  MagicTest
//
//  Created by dr.box on 2022/5/16.
//

import Foundation
import DrMagic

func hkdfTest() {
    
    if #available(iOS 14.0, *) {
        let input128Key = DrHKDF.inputKeyMaterial(size: .bits128)
        assert(input128Key.count == 16, "input128Key位数不对")
        let input192Key = DrHKDF.inputKeyMaterial(size: .bits192)
        assert(input192Key.count == 24, "input192Key位数不对")
        let input256Key = DrHKDF.inputKeyMaterial(size: .bits256)
        assert(input256Key.count == 32, "input256Key位数不对")
        
    }
}
