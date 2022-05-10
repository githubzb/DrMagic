//
//  Data+ext.swift
//  DrMagic
//
//  Created by admin on 2022/5/10.
//

import Foundation
import CryptoKit
import CommonCrypto

extension Data: MagicBoxExt {}

// MARK: - encode and decode
extension MagicBox where T == Data {
    
    
    public md5String: String
    
    
    fileprivate var _md5Str: String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        withUnsafeBytes(of: value) { bytes in
            guard let baseAddress = bytes.baseAddress else {
                return
            }
            CC_MD5(baseAddress, CC_LONG(self.value.count), &digest)
        }
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        return digestHex
    }
}
