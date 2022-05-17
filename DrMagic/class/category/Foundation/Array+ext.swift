//
//  Array+ext.swift
//  DrMagic
//
//  Created by dr.box on 2022/5/17.
//

import Foundation

extension Array: MagicBoxExt {}

extension MagicBox where T: Sequence {
    
    /// 数组转成json字符串
    public var jsonString: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: value, options: .fragmentsAllowed) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    /// 数组转json字符串（格式化后的）
    public var jsonPrettyString: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}
