//
//  NumberTest.swift
//  MagicTest
//
//  Created by dr.box on 2022/5/24.
//

import Foundation
import DrMagic

func numberTest() {
    
    let d1: Double = 100.144
    let d1Str = d1.mg.toString()
    assert(d1Str == "100.14", "toString fail")
    
    let d1Str2 = d1.mg.toString(digits: 2, mode: .up)
    assert(d1Str2 == "100.15", "toString fail")
    
    let rmb1 = d1.mg.currencyRMB
    assert(rmb1 == "壹佰元壹角肆分", "currencyRMB fail")
    let d2: Float = 12.0
    let rmb2 = d2.mg.currencyRMB
    assert(rmb2 == "拾贰元整", "currencyRMB fail")
    
    let d3: Double = 0.22
    let rmb3 = d3.mg.currencyRMB
    assert(rmb3 == "零元贰角贰分", "currencyRMB fail")
    
//    let d4: Float = 0.22 // 由于Float精度问题，它的取值会是0.21999，因此人民币建议用Double存储
//    let rmb4 = d4.mg.currencyRMB
//    drLog("rmb4: \(rmb4)")
}
