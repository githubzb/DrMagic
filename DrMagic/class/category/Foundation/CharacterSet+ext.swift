//
//  CharacterSet+ext.swift
//  DrMagic
//
//  Created by admin on 2022/5/17.
//

import Foundation

extension CharacterSet {
    
    /// 获取字符集的Unicode10进制编码集合
    public var unicodeList: [Int] {
        var result: [Int] = []
        var plane = 0
        // following documentation at https://developer.apple.com/documentation/foundation/nscharacterset/1417719-bitmaprepresentation
        for (i, w) in bitmapRepresentation.enumerated() {
            let k = i % 0x2001
            if k == 0x2000 {
                // plane index byte
                plane = Int(w) << 13
                continue
            }
            let base = (plane + k) << 3
            for j in 0 ..< 8 where w & 1 << j != 0 {
                result.append(base + j)
            }
        }
        return result
    }
    
    /// 获取字符集中的字符列表
    public var characterList: [Character] {
        unicodeList.compactMap { code -> Character? in
            guard let scalar = UnicodeScalar(code) else {
                return nil
            }
            return Character.init(scalar)
        }
    }
    
    /// 字符集的字符串表示
    public var characterString: String { String(characterList) }
}
