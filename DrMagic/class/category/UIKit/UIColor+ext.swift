//
//  UIColor+ext.swift
//  DrMagic
//
//  Created by dr.box on 2022/5/19.
//

import UIKit

extension UIColor: MagicBoxObjExt {}

extension MagicBox where T: UIColor {
    
    /**
     根据16进制字颜色字符串，生成UIColor
     
     - Parameter hex: 16进制颜色字符串
     
     - Returns UIColor
     */
    public static func hexColor(_ hex: String) -> UIColor? {
        var red: CGFloat   = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat  = 0.0
        var alpha: CGFloat = 1.0
        
        let hexStr: String
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hexStr = String(hex[index...])
        }else{
            hexStr = hex
        }
        let scanner = Scanner(string: hexStr)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hexStr.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                // Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8
                return nil
            }
        } else {
            // "Scan hex error
            return nil
        }
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     将颜色对象转成16进制字符串
     
     - Parameter hasPrefix: 是否包含前缀“#”（默认：包含）
     - Parameter hasAlpha: 是否包含透明度（默认：不包含）
     
     - Returns 该UIColor的16进制字符串，例如：#FF0000
     */
    public func hexString(hasPrefix: Bool = true, hasAlpha: Bool = false) -> String {
        let comps = value.cgColor.components!
        let compsCount = value.cgColor.numberOfComponents
        let r: Int
        let g: Int
        var b: Int
        let a = Int(comps[compsCount - 1] * 255)
        if compsCount == 4 { // RGBA
            r = Int(comps[0] * 255)
            g = Int(comps[1] * 255)
            b = Int(comps[2] * 255)
        } else { // Grayscale
            r = Int(comps[0] * 255)
            g = Int(comps[0] * 255)
            b = Int(comps[0] * 255)
        }
        var hexString: String = ""
        if hasPrefix {
            hexString = "#"
        }
        hexString += String(format: "%02X%02X%02X", r, g, b)
        
        if hasAlpha {
            hexString += String(format: "%02X", a)
        }
        return hexString
    }
}
