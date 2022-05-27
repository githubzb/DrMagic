//
//  Number+ext.swift
//  DrMagic
//
//  Created by dr.box on 2022/5/24.
//

import Foundation

extension Double: MagicBoxExt {}
extension Float: MagicBoxExt {}
extension MagicBox where T == Double {
    
    
    /**
     将Double转成字符串
     
     - Parameter digits: 小数点后保留的位数（默认：2）
     - Parameter mode: 小数舍取模式（默认：四舍五入）
     
     - Returns 浮点数的字符串表示
     */
    public func toString(digits: Int = 2, mode: NumberFormatter.RoundingMode = .halfUp) -> String {
        let format = NumberFormatter()
        format.formatterBehavior = .default
        format.locale = Locale(identifier: "zh_CN")
        format.numberStyle = .decimal
        format.minimumFractionDigits = digits
        format.maximumFractionDigits = digits
        format.roundingMode = mode
        return format.string(for: value) ?? ""
    }
    
    /// 转成货币人民币大写
    public var currencyRMB: String {
        let format = NumberFormatter()
        format.formatterBehavior = .default
        format.locale = Locale(identifier: "zh_CN")
        format.numberStyle = .spellOut
        let str = format.string(for: value) ?? ""
        return str.RMBString
    }
}

extension MagicBox where T == Float {
    
    /**
     将Double转成字符串
     
     - Parameter digits: 小数点后保留的位数（默认：2）
     - Parameter mode: 小数舍取模式（默认：四舍五入）
     
     - Returns 浮点数的字符串表示
     */
    public func toString(digits: Int = 2, mode: NumberFormatter.RoundingMode = .halfUp) -> String {
        let format = NumberFormatter()
        format.formatterBehavior = .default
        format.locale = Locale(identifier: "zh_CN")
        format.numberStyle = .decimal
        format.minimumFractionDigits = digits
        format.maximumFractionDigits = digits
        format.roundingMode = mode
        return format.string(for: value) ?? ""
    }
    
    /// 转成货币人民币大写（注意：Float可能会因为精度问题，分会有所不一样）
    public var currencyRMB: String {
        let format = NumberFormatter()
        format.formatterBehavior = .default
        format.locale = Locale(identifier: "zh_CN")
        format.numberStyle = .spellOut
        let str = format.string(for: value) ?? ""
        return str.RMBString
    }
}

fileprivate extension String {
    
    var RMBString: String {
        let str = replacingOccurrences(of: "一", with: "壹")
            .replacingOccurrences(of: "二", with: "贰")
            .replacingOccurrences(of: "三", with: "叁")
            .replacingOccurrences(of: "四", with: "肆")
            .replacingOccurrences(of: "五", with: "伍")
            .replacingOccurrences(of: "六", with: "陆")
            .replacingOccurrences(of: "七", with: "柒")
            .replacingOccurrences(of: "八", with: "捌")
            .replacingOccurrences(of: "九", with: "玖")
            .replacingOccurrences(of: "十", with: "拾")
            .replacingOccurrences(of: "百", with: "佰")
            .replacingOccurrences(of: "千", with: "仟")
            .replacingOccurrences(of: "〇", with: "零")
        let components = str.components(separatedBy: "点")
        if components.count > 1 {
            var intStr = components[0].appending("元")
            let decimalStr = components[1]
            intStr = intStr.appending("\(decimalStr.first!)角")
            if decimalStr.count > 1 {
                intStr = intStr.appending("\(decimalStr[decimalStr.index(decimalStr.startIndex, offsetBy: 1)])分")
            }
            return intStr
        }
        return str.appending("元整")
    }
}
