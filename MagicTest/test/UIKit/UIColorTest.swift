//
//  UIColorTest.swift
//  MagicTest
//
//  Created by dr.box on 2022/5/23.
//

import Foundation
import DrMagic
import UIKit

func uicolorTest() {
    
    let color1: UIColor? = .mg.hexColor("232323")
    assert(color1 != nil, "hexColor fail")
    
    let color2: UIColor? = .mg.hexColor("#232323")
    assert(color2 != nil, "hexColor fail")
    
    let color3: UIColor? = .mg.hexColor("323")
    assert(color3 != nil, "hexColor fail")
    
    let color4: UIColor? = .mg.hexColor("3232")
    assert(color4 != nil, "hexColor fail")
    
    let color5: UIColor? = .mg.hexColor("23099801")
    assert(color5 != nil, "hexColor fail")
    
    let color1Hex1 = color1!.mg.hexString()
    assert(color1Hex1 == "#232323", "hexString fail")
    let color1Hex2 = color1!.mg.hexString(hasPrefix: false)
    assert(color1Hex2 == "232323", "hexString fail")
//
//    let s = color3!.mg.hexString() // != 323
//    print("---s: \(s)")
    
    let color5Hex = color5!.mg.hexString(hasAlpha: true)
    assert(color5Hex == "#23099801", "hexString fail")
}
