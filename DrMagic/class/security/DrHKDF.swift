//
//  DrHKDF.swift
//  DrMagic
//
//  Created by admin on 2022/5/16.
//

import Foundation
import CryptoKit

/// HKDF算法派生对称密钥。
@available(iOS 14.0, macOS 11.0, watchOS 7.0, tvOS 14.0, *)
public enum DrHKDF {
    
    /// Input key material size
    public enum MaterialSize {
        case bits128
        case bits192
        case bits256
        
        var keySize: SymmetricKeySize {
            switch self {
            case .bits128:
                return .bits128
            case .bits192:
                return .bits192
            case .bits256:
                return .bits256
            }
        }
    }
}

extension DrHKDF {
    
    /**
     Input key material.
     
     - Parameter size: input key bit size.
     
     - Returns HKDF input key material.
     */
    public static func inputKeyMaterial(size: MaterialSize) -> Data  {
        SymmetricKey(size: size.keySize).withUnsafeBytes { bf -> Data in
            guard let base = bf.baseAddress else {
                return Data()
            }
            return Data(bytes: base, count: bf.count)
        }
    }
    /**
     Input key material.
     
     - Parameter size: input key bit size.
     
     - Returns HKDF input key material.（16进制字符串）
     */
    public static func inputKeyMaterialHex(size: MaterialSize) -> String  {
        inputKeyMaterial(size: size).mg.hexString
    }
}

extension DrHKDF {
    
    /**
     使用HKDF算法派生对称密钥。
     
     - Parameter inputKeyMaterial: Input key material.
     - Parameter salt: A non-secret random value.
     - Parameter info: Context and application specific information.
     - Parameter byteCount: 秘钥的字节长度
     - Returns 对称秘钥
     */
    @available(iOS 14.0, macOS 11.0, watchOS 7.0, tvOS 14.0, *)
    public static func deriveKey(inputKeyMaterial: Data, salt: Data, info: Data, byteCount: Int) -> Data {
        
    }
}
