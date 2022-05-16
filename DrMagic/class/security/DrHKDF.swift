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
    
    /// HKDF秘钥派生所需的hash函数
    public enum HashFunc {
        case md5
        case sha1
        case sha256
        case sha384
        case sha512
    }
}

@available(iOS 14.0, macOS 11.0, watchOS 7.0, tvOS 14.0, *)
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

@available(iOS 14.0, macOS 11.0, watchOS 7.0, tvOS 14.0, *)
extension DrHKDF {
    
    /**
     使用HKDF算法派生对称密钥。
     
     - Parameter hashFunc: 生成秘钥的hash算法
     - Parameter inputKeyMaterial: Input key material.
     - Parameter salt: A non-secret random value.
     - Parameter info: Context and application specific information.
     - Parameter byteCount: 秘钥的字节长度
     
     - Returns 对称秘钥
     */
    public static func deriveKey(hashFunc: DrHKDF.HashFunc, inputKeyMaterial: Data, salt: Data, info: Data, byteCount: Int) -> Data {
        let inputKey = SymmetricKey(data: inputKeyMaterial)
        let key: SymmetricKey
        switch hashFunc {
        case .md5:
            key = HKDF<Insecure.MD5>.deriveKey(inputKeyMaterial: inputKey, salt: salt, info: info, outputByteCount: byteCount)
            
        case .sha1:
            key = HKDF<Insecure.SHA1>.deriveKey(inputKeyMaterial: inputKey, salt: salt, info: info, outputByteCount: byteCount)
            
        case .sha256:
            key = HKDF<SHA256>.deriveKey(inputKeyMaterial: inputKey, salt: salt, info: info, outputByteCount: byteCount)
            
        case .sha384:
            key = HKDF<SHA384>.deriveKey(inputKeyMaterial: inputKey, salt: salt, info: info, outputByteCount: byteCount)
            
        case .sha512:
            key = HKDF<SHA512>.deriveKey(inputKeyMaterial: inputKey, salt: salt, info: info, outputByteCount: byteCount)
        }
        return key.withUnsafeBytes { bf -> Data in
            guard let base = bf.baseAddress else {
                return Data()
            }
            return Data(bytes: base, count: bf.count)
        }
    }
    
    /**
     使用HKDF算法派生对称密钥。
     
     - Parameter hashFunc: 生成秘钥的hash算法
     - Parameter inputKeyMaterial: Input key material.
     - Parameter salt: A non-secret random value.
     - Parameter byteCount: 秘钥的字节长度
     
     - Returns 对称秘钥
     */
    public static func deriveKey(hashFunc: DrHKDF.HashFunc, inputKeyMaterial: Data, salt: Data, byteCount: Int) -> Data {
        let inputKey = SymmetricKey(data: inputKeyMaterial)
        let key: SymmetricKey
        switch hashFunc {
        case .md5:
            key = HKDF<Insecure.MD5>.deriveKey(inputKeyMaterial: inputKey, salt: salt, outputByteCount: byteCount)
            
        case .sha1:
            key = HKDF<Insecure.SHA1>.deriveKey(inputKeyMaterial: inputKey, salt: salt, outputByteCount: byteCount)
            
        case .sha256:
            key = HKDF<SHA256>.deriveKey(inputKeyMaterial: inputKey, salt: salt, outputByteCount: byteCount)
            
        case .sha384:
            key = HKDF<SHA384>.deriveKey(inputKeyMaterial: inputKey, salt: salt, outputByteCount: byteCount)
            
        case .sha512:
            key = HKDF<SHA512>.deriveKey(inputKeyMaterial: inputKey, salt: salt, outputByteCount: byteCount)
        }
        return key.withUnsafeBytes { bf -> Data in
            guard let base = bf.baseAddress else {
                return Data()
            }
            return Data(bytes: base, count: bf.count)
        }
    }
    
    /**
     使用HKDF算法派生对称密钥。
     
     - Parameter hashFunc: 生成秘钥的hash算法
     - Parameter inputKeyMaterial: Input key material.
     - Parameter info: Context and application specific information.
     - Parameter byteCount: 秘钥的字节长度
     
     - Returns 对称秘钥
     */
    public static func deriveKey(hashFunc: DrHKDF.HashFunc, inputKeyMaterial: Data, info: Data, byteCount: Int) -> Data {
        let inputKey = SymmetricKey(data: inputKeyMaterial)
        let key: SymmetricKey
        switch hashFunc {
        case .md5:
            key = HKDF<Insecure.MD5>.deriveKey(inputKeyMaterial: inputKey, info: info, outputByteCount: byteCount)
            
        case .sha1:
            key = HKDF<Insecure.SHA1>.deriveKey(inputKeyMaterial: inputKey, info: info, outputByteCount: byteCount)
            
        case .sha256:
            key = HKDF<SHA256>.deriveKey(inputKeyMaterial: inputKey, info: info, outputByteCount: byteCount)
            
        case .sha384:
            key = HKDF<SHA384>.deriveKey(inputKeyMaterial: inputKey, info: info, outputByteCount: byteCount)
            
        case .sha512:
            key = HKDF<SHA512>.deriveKey(inputKeyMaterial: inputKey, info: info, outputByteCount: byteCount)
        }
        return key.withUnsafeBytes { bf -> Data in
            guard let base = bf.baseAddress else {
                return Data()
            }
            return Data(bytes: base, count: bf.count)
        }
    }
    
    /**
     使用HKDF算法派生对称密钥。
     
     - Parameter hashFunc: 生成秘钥的hash算法
     - Parameter inputKeyMaterial: Input key material.
     - Parameter salt: A non-secret random value.
     - Parameter info: Context and application specific information.
     - Parameter byteCount: 秘钥的字节长度
     
     - Returns 对称秘钥（16进制字符串）
     */
    public static func deriveKeyHex(hashFunc: DrHKDF.HashFunc, inputKeyMaterial: Data, salt: Data, info: Data, byteCount: Int) -> String {
        deriveKey(hashFunc: hashFunc, inputKeyMaterial: inputKeyMaterial, salt: salt, info: info, byteCount: byteCount).mg.hexString
    }
    
    /**
     使用HKDF算法派生对称密钥。
     
     - Parameter hashFunc: 生成秘钥的hash算法
     - Parameter inputKeyMaterial: Input key material.
     - Parameter salt: A non-secret random value.
     - Parameter byteCount: 秘钥的字节长度
     
     - Returns 对称秘钥（16进制字符串）
     */
    public static func deriveKeyHex(hashFunc: DrHKDF.HashFunc, inputKeyMaterial: Data, salt: Data, byteCount: Int) -> String {
        deriveKey(hashFunc: hashFunc, inputKeyMaterial: inputKeyMaterial, salt: salt, byteCount: byteCount).mg.hexString
    }
    
    /**
     使用HKDF算法派生对称密钥。
     
     - Parameter hashFunc: 生成秘钥的hash算法
     - Parameter inputKeyMaterial: Input key material.
     - Parameter info: Context and application specific information.
     - Parameter byteCount: 秘钥的字节长度
     
     - Returns 对称秘钥（16进制字符串）
     */
    public static func deriveKeyHex(hashFunc: DrHKDF.HashFunc, inputKeyMaterial: Data, info: Data, byteCount: Int) -> String {
        deriveKey(hashFunc: hashFunc, inputKeyMaterial: inputKeyMaterial, info: info, byteCount: byteCount).mg.hexString
    }
    
}
